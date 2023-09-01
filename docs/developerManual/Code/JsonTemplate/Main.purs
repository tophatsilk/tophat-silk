module Main  where

import Prelude

import Data.Maybe -- (Maybe(..), fromJust)
import Effect (Effect)
import Web.DOM.Document (Document, createElement)
import Web.DOM.Element (Element, setId, toEventTarget, toNode)
import Web.DOM.Node (appendChild, setTextContent)
import Web.DOM.ParentNode (querySelector, QuerySelector(QuerySelector))
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDoc
import Web.HTML.Window (document)
import Data.Argonaut
import Data.Either
import Data.Number

-- Data definitions and Json encoding and decoding.
data Value
  = Int Int
  | Number Number
  | String String
  | Boolean Boolean

instance showValue :: Show Value where
  show (Int int) = show int
  show (Number number) = show number
  show (String string) = string
  show (Boolean boolean) = show boolean

instance decodeJsonValue :: DecodeJson Value where
  decodeJson json = do
    value <- decodeJson json
    fromValue value
    where
    fromValue v
      | isBoolean v = Boolean <$> decodeJson v
      | isInt v = Int <$> decodeJson v
      | isNumber v = Number <$> decodeJson v
      | otherwise = String <$> decodeJson v

instance encodeJsonValue :: EncodeJson Value where
  encodeJson (String string) = encodeJson string
  encodeJson (Int int) = encodeJson int
  encodeJson (Number number) = encodeJson number
  encodeJson (Boolean bool) = encodeJson bool


-- Json parser for Int
-- Warning: This test fails if a Number is encoded that is rounded: e.g. '1.0' is tested as Int!
-- This is due to way in which the information is encoded in Argonaut Json. 
-- The trailing '.0' is not encoded! Even '2.000' is still encoded as '2'.
isInt :: Json -> Boolean
isInt v = (isNumber v && (isRoundNumber (decodeJson v)))
  
-- Simple function to check if a Number is an integer.
isRoundNumber :: Either JsonDecodeError Number -> Boolean
isRoundNumber (Right v) = 0.0 == v - (round v)
isRoundNumber (Left _) = false


-- Help functions for the GUI.
decodedValue :: Either JsonDecodeError Value -> Value
decodedValue (Right v) = v
decodedValue (Left _) = String "error"

safeDecodedValue  v = decodedValue (decodeJson v)

---------------------------------------------------------------------------
-- Functions for HTML page creation.

-- Take the document ('doc') itself and select from this document an element (division) by its id.
-- This division will be the target element for any changes.
-- Parameters: 
-- doc - the (HTML) document to be manipulated
-- divId - a String representing the HTML id of the division of element.
selectDivTargetFromDocument :: String -> HTMLDoc.HTMLDocument -> Effect (Maybe Element)
selectDivTargetFromDocument divId doc = querySelector (QuerySelector (divId)) (HTMLDoc.toParentNode doc)

-- Create an element with an HTML tag type and contents.
-- Parameters:
-- tag - the HTML tag type, e.g. 'div' or 'button'.
-- contents - the text content of the element as string.
-- nonHTMLdoc - the (nonHTML)document itself.
createElementWithTagAndContent ∷ String → String → Document -> Effect Element
createElementWithTagAndContent tag contents nonHTMLdoc = do
  -- Create the new element
  createdElement <- createElement tag nonHTMLdoc
  -- Add its contents (no return needed, hence the anonymous function '_'.)
  _ <- setTextContent contents (toNode createdElement)
  pure createdElement

-- Append a child if a parent element is given.
-- The function appendChild from Web.DOM.Node takes nodes as arguments 
-- (appendChild :: Node → Node → Effect Unit), so the elements need to be
-- converted to nodes with toNode from Web.DOM.Element.
maybeAppendChildNode ∷ Maybe Element → Element → Effect Unit
maybeAppendChildNode (Just parent1) child1 = appendChild (toNode child1) (toNode parent1)
maybeAppendChildNode _ _ = pure unit

-- Take a string and replace the content of an element with this string. If there is no element, do nothing.
-- Parameters:
-- str - the string representing the new content of the element
-- el - the element to be altered
updateText :: String -> Maybe Element -> Effect Unit
updateText str (Just el) = setTextContent str (toNode el)
updateText _ _ = pure unit


main :: Effect Unit
main = do
   -- Get the body element and the (nonHTML)document
  bodyEl <- selectDivTargetFromDocument "body" =<< document =<< window
  nonHTMLdoc <- HTMLDoc.toDocument <$> (document =<< window)

  -- We will use a separate, new 'main' division instead of the body 
  -- as the container for our other divisions.
  mainDivElement <- createElementWithTagAndContent "div" "" nonHTMLdoc
  -- And add the created element to the body.
  maybeAppendChildNode bodyEl mainDivElement 

  -- Creating a new element of type "div" with text.
  
  -- Enter the value to be tested here:
  -- Examples:
  -- let testValue = Int 3
  let testValue = Number 2.000
  -- let testValue = Number 1.43
  -- let testValue = String "text for fun"
  
  let parseResultString json = ("isBoolean: " <> show (isBoolean json) <> "; isInt: " <> show (isInt json) <> "; isNumber: " <> show (isNumber json) )
  let testString json = ("testValue = " <> (show (safeDecodedValue json)) <> ". Stringified Json: '" <> (stringify json) <> "'. Type tests: " <> (parseResultString json)) 
  testElement <- createElementWithTagAndContent "div" (testString (encodeJson (testValue))) nonHTMLdoc
  
  -- And add the created element to the new 'main' division.
  maybeAppendChildNode (Just mainDivElement) testElement
