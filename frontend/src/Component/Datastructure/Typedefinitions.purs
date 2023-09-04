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
import Data.Either
import Math (round)
import Data.Int as DI -- for fromNumber

-- Module import for generic JSON.
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)

-- 'Old' JSON
import Data.Argonaut (JsonDecodeError, Json, class DecodeJson, class EncodeJson, decodeJson, encodeJson, isBoolean, isNumber, isObject, jsonEmptyObject, jsonNull, (.!=), (.:), (.:?), (:=), (~>))

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

{-
-- Define the generic JSON encoding and decoding for Value.
derive instance genericValue :: Generic Value _

instance encodeJsonValue :: EncodeJson Value where
  encodeJson a = genericEncodeJson a

instance decodeJsonValue :: DecodeJson Value where
  decodeJson a = genericDecodeJson a
-}

{-
-- Definition of a suggested new example type for the content of a Task.
type TaskContentType = { type :: String 
              , UI :: String
              , coordinates :: {x :: Number, y :: Number}
              }
-}

-- Suggestions for a type contructor for a new datatype.
{- 
-- TaskContentTypeConstructor
data TaskContentTypeConstructor =
  TaskContentTypeConstructor TaskContentType

-- Default TaskContentType.
defaultTaskContentType :: TaskContentType
defaultTaskContentType = { type: "coordinates", UI: "canvas", coordinates: {x:0.11, y:0.22} }

-- Attempts to extract/parse a TaskContentType from a string. WIP: Temporarily always gives back Just s
verifyDatatype0Value :: String -> Maybe TaskContentType
verifyDatatype0Value s = Just defaultTaskContentType
-}
