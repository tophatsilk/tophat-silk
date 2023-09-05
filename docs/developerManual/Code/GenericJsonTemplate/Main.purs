{-
Test template for generic Json encoding and decoding in Purescript.

The example below is written for purescript #15 and deviates from the 
'Quick start' example shown on github: 
https://github.com/purescript-contrib/purescript-argonaut-generic
The genericDecodeJson and genericEncodeJson functions are imported from 
the 'Data.Argonaut.Encode.Generic' module, not the 
'Data.Argonaut.Encode.Generic.Rep' module.
-}
module Main  where

import Prelude

import Data.Argonaut (JsonDecodeError, decodeJson, encodeJson, parseJson, stringify)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Number
import Effect (Effect)
import Web.DOM.Document (Document, createElement)
import Web.DOM.Element (Element, toNode)
import Web.DOM.Node (appendChild, setTextContent)
import Web.DOM.ParentNode (querySelector, QuerySelector(QuerySelector))
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDoc
import Web.HTML.Window (document)

import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)

import Data.Generic.Rep (class Generic)

---------------------------------------------------------------------------
-- Setting up the main HTML page.

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
createElementWithTagAndContent ∷ String → String → Document → Effect Element
createElementWithTagAndContent tag contents nonHTMLdoc = do
  -- Create the new element
  createdElement <- createElement tag nonHTMLdoc
  -- Add its contents (no return needed, hence the anonymous function '_'.)
  _ <- setTextContent contents (toNode createdElement)
  -- Return the element.
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

---------------------------------------------------------------------------
-- Next, we create a data type and define the type class instances for it for show
-- and the json encoding and decoding, and the functions to provide safe
-- default decoded data.

-- ** DATATYPE DEFINITION and ENCODING **
data Information = 
  Information { text :: String 
              , coordinates :: {x :: Number, y :: Number}
              }

-- Define the generic JSON encoding and decoding.
derive instance genericInformation :: Generic Information _
  
instance encodeJsonInformation :: EncodeJson Information where
  encodeJson a = genericEncodeJson a

instance decodeJsonInformation :: DecodeJson Information where
  decodeJson a = genericDecodeJson a


-- Create a type class instance to show the content of an Information data item.
instance showInformation :: Show Information where
  show (Information info) = info.text <> ", (" <> show info.coordinates.x <> ", " <> show info.coordinates.y <> " )"


-- Create some input as information to work with
inputInformation ∷ Information
inputInformation = Information { text: "innertext", coordinates: {x : 0.23, y: 0.3} }

-- Give the Information data from a decoded Json object with a possible error.
-- Give default Information data in case of a decoding error.
defaultInfoFromJson :: Either JsonDecodeError Information -> Information
defaultInfoFromJson (Left _) = Information { text: "default", coordinates: {x : 0.32, y : 0.4} }
defaultInfoFromJson (Right json) = json


-- Extract json information from a string.
-- We use the parseJson function from the Argonaut module of the type:
-- parseJson :: String -> Either JsonDecodeError Json
-- and bind the result to decodeJson, which will give a
-- result of type 'Either JsonDecodeError Information
tryParseJson ∷ DecodeJson Information ⇒ String → Either JsonDecodeError Information
tryParseJson stringIn = do 
  out <- decodeJson =<< parseJson stringIn
  pure out



main :: Effect Unit
main = do
   -- Get the body element and the (nonHTML)document
  bodyEl <- selectDivTargetFromDocument "body" =<< document =<< window
  nonHTMLdoc <- HTMLDoc.toDocument <$> (document =<< window)

  -- We will use a separate, new 'main' division instead of the body as the container
  -- for our other divisions, and add three divisions to it.
  mainDivElement <- createElementWithTagAndContent "div" "" nonHTMLdoc
  -- And add the created element to the body.
  maybeAppendChildNode bodyEl mainDivElement 

  -- First we create an element of type "div" to show the input data.
  dataInputElement <- createElementWithTagAndContent "div" "input" nonHTMLdoc
  -- And add the created element to the new 'main' division.
  maybeAppendChildNode (Just mainDivElement) dataInputElement

  -- Then we create an element of type "div" for the JSON converted to a string.
  jsonStringElement <- createElementWithTagAndContent "div" "json as a string" nonHTMLdoc
  -- And add the created element to the new 'main' division.
  maybeAppendChildNode (Just mainDivElement) jsonStringElement

  -- And finally we create another element of type "div" to show the data after the full cycle of conversions.
  dataOutputElement <- createElementWithTagAndContent "div" "full circle result" nonHTMLdoc
  -- And add the created element to the new 'main' division.
  maybeAppendChildNode (Just mainDivElement) dataOutputElement

  -- Now we will demonstrate the Json conversions.
  -- First we will show the data in our record in the first element ('input').
  updateText (show "test") (Just dataInputElement)

  -- Now, we will encode the Information to json.
  let encodedInformation = encodeJson inputInformation
  -- Because we cannot show json directly, we will turn it into a string using the 'stringify'
  -- function from the Argonaut module.
  let informationAsString = stringify encodedInformation
  -- And show it in the second division.
  updateText (informationAsString) (Just jsonStringElement)

  -- Now use the string extract the information (This may give a JsonDecodeError.)
  -- tryParseJson ∷ DecodeJson Information ⇒ String → Either JsonDecodeError Information
  let newTryJsonObject = tryParseJson informationAsString

  -- We will catch the JsonDecodeError and give a default Information object on an error, or
  -- the actual Information data object if there is no error.
  let newSafeExtractedInformation = defaultInfoFromJson newTryJsonObject

  -- To make full circle we will now show the record extracted from the json object.
  updateText (show newSafeExtractedInformation) (Just dataOutputElement)

  -- We return unit to close the 'do' block.
  pure unit
