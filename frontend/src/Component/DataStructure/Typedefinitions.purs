{-|
Module      : Component.Datastructure.Typedefinitions
Description : Module for complex datatype definitions
Copyright   : (c) Some Guy, 2023
                  
License     : ...
Maintainer  : ...
Stability   : experimental

Module to for the definition of complex datatypes and relevant functions (into Tasks, Editors, Values and InputDescription).
-}
module Component.Datastructure.Typedefinitions where

type Datatypetype = { text :: String 
              , coordinates :: {x :: Number, y :: Number}
              }
