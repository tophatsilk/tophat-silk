{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE NoImplicitPrelude #-}

import qualified Data.HashMap.Strict as HashMap
import "tophat" Task (Label, Task, enter, select, update, view, (<?>), (>>?))
import Visualize (visualizeTaskDevel)
import "tophat" Prelude

-- This file is used for development purposes in combination with yesod-devel.
main :: IO ()
main = visualizeTaskDevel startCandyMachine

--Example tasks

stepViewUpdate :: Task h Text
stepViewUpdate =
  update ("Hello!" :: Text) >< (update True >< update (1 :: Int)) >>? \(t, (b, i)) ->
    view
      <| unwords
        [ "The left value was \"",
          t,
          "\", the right value was",
          display (b, i)
        ]

oneStep' :: Task h Int
oneStep' =
  update 0 >>? \x ->
    view x

pick2 :: Task h Int
pick2 = view 1 <?> view 2

hashmap :: HashMap Label (Task h Int)
hashmap = HashMap.insert ("B" :: Label) (view (22 :: Int)) (HashMap.insert ("A" :: Label) (view (11 :: Int)) HashMap.empty)

pick3' :: Task h Int
pick3' = select hashmap

-- Multiplication-by-seven machine

multiplication :: Int -> Int -> Task h Int
multiplication x y = view (x * y)

multBySeven :: Int -> Task h Int
multBySeven x = multiplication x 7

multBySevenMachine :: Task h Int
multBySevenMachine =
  enter >>? \x ->
    multBySeven x

-- CandyMachine

fillCandyMachine:: Text -> Int -> HashMap Label (Task h (Text,Text)) -> HashMap Label (Task h (Text,Text))
fillCandyMachine name price = HashMap.insert (name::Label) (view ("You need to pay:"::Text) >< (view price >>? \x-> candyMachinePayDesk x))

filledCandyMachine:: HashMap Label (Task h (Text,Text))
filledCandyMachine = fillCandyMachine ("Pure Chocolate"::Text) (8::Int) (fillCandyMachine ("IO Chocolate"::Text) (7::Int) (fillCandyMachine ("Sem Chocolate"::Text) (9::Int) HashMap.empty))

payCoin :: Int ->HashMap Label (Task h Int)
payCoin bill = HashMap.insert ("5"::Label) (view (bill-5::Int)) (HashMap.insert ("2"::Label) (view (bill-2::Int)) (HashMap.insert ("1"::Label) (view (bill-1::Int)) HashMap.empty))

startCandyMachine:: (Task h (Text,Text))
startCandyMachine = select filledCandyMachine

candyMachinePayDesk:: Int -> Task h Text
candyMachinePayDesk bill = select (payCoin bill)  >>? \billLeft -> (if billLeft>0 then candyMachinePayDesk billLeft else (if billLeft<0 then candyMachineDispenser Evil else candyMachineDispenser Fair))

data CandyMachineMood = Fair | Evil

candyMachineDispenser:: CandyMachineMood -> Task h Text
candyMachineDispenser Fair = view ("You have paid. Here is your candy. Enjoy it!"::Text)
candyMachineDispenser Evil = view ("You have paid too much, fool! You don't get change, but here is your candy."::Text)

