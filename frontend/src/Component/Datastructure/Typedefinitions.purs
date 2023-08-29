{-|
Module      : Component.Datastructure.Typedefinitions
Description : Module for complex datatype definitions
Copyright   : (c) Some Guy, 2023
                  
License     : ...
Maintainer  : ...
Stability   : experimental

Module to for the definition of complex datatypes and relevant functions (into Tasks, Editors, Values and InputDescription).
-}

{-
Changes in the datatypes also require changes in:
- /Component/Taskloader in:
    - renderEditor
    - renderEditorEnter

-}

module Component.Datastructure.Typedefinitions where

import Prelude
import Data.Maybe (Maybe(..), isJust)

-- New import after adding Number datatype
import Data.Int as DI -- for fromNumber

-- Module import for generic JSON.
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)

-- Old JSON
import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson, isBoolean, isNumber, isObject, jsonEmptyObject, jsonNull, (.!=), (.:), (.:?), (:=), (~>))
import Data.Argonaut.Decode.Error as JsonDecodeError




data Value
  = Int Int
  | Number Number
  | String String
  | Boolean Boolean
--2  | Datatype0 TaskContentType

instance showValue :: Show Value where
  show (Int int) = show int
  show (Number number) = show number
  show (String string) = string
  show (Boolean boolean) = show boolean
--2  show (Datatype0 info) = info.text <> ", (" <> show info.coordinates.x <> ", " <> show info.coordinates.y <> " )"


instance decodeJsonValue :: DecodeJson Value where
  decodeJson json = do
    value <- decodeJson json
    fromValue value
    where
    fromValue v
      | isBoolean v = Boolean <$> decodeJson v
      | isNumber v = Number <$> decodeJson v        
      | otherwise = String <$> decodeJson v

instance encodeJsonValue :: EncodeJson Value where
  encodeJson (String string) = encodeJson string
  encodeJson (Int int) = encodeJson int
  encodeJson (Number number) = encodeJson number
  encodeJson (Boolean bool) = encodeJson bool

{-
-- Define the generic JSON encoding and decoding for Value.
derive instance genericValue :: Generic Value _

instance encodeJsonValue :: EncodeJson Value where
  encodeJson a = genericEncodeJson a

instance decodeJsonValue :: DecodeJson Value where
  decodeJson a = genericDecodeJson a
-}

{-
-- Definition of a new type for the content of a Task.
type TaskContentType = { text :: String 
              , coordinates :: {x :: Number, y :: Number}
              }
-}

{-
-- TaskContentTypeConstructor
data TaskContentTypeConstructor =
  TaskContentTypeConstructor TaskContentType


-- Default TaskContentType.
defaultTaskContentType :: TaskContentType
defaultTaskContentType = { text: "text", coordinates: {x:0.11, y:0.22} }

-- Attempts to extract/parse a TaskContentType from a string. WIP: Temporarily always gives back Just s
verifyDatatype0Value :: String -> Maybe TaskContentType
verifyDatatype0Value s = Just defaultTaskContentType
-}
