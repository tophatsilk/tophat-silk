# Tasks and Data Types
As we mentioned in the Introduction, the vizualization code must somehow choose how to present data, but it also needs to be able to communicate its data to the backend. This is handled in the Tasks.purs module, which may be found in the "/frontend/src/App" directory. In this module the JSON decoding and encoding is performed for the communication between the frontend and backend.

Every datatype require a JSON encoder and decoder definition. The input datatypes are handled from line 134 on. The Value datatype is introduced with three constructors; one for each datatype Int, String, and Boolean:
```
data Value
  = Int Int
  | String String
  | Boolean Boolean
```
**Figure 1**  Value type in Tasks.purs.

Adding a new datatype, such as Long or Byte, requires the addition of a new contructor, but also new definitions for all three instances (Show, EncodeJson, and DecodeJson). 

If you are not familiar with the JSON data representation, you may read about it in our introductory manual for web programming with purescript: https://github.com/tophatsilk/Purescript-HTML-tutorial/Chapter4.md, in which we also discuss the standard purescript Argonaut module for JSON that is used in this project.


**Note:** The json decoding instance (instance decodeJsonValue) uses the Argonaut 'isNumber' function (https://pursuit.purescript.org/packages/purescript-argonaut-core/7.0.0/docs/Data.Argonaut.Core#v:isNumber), which in itself uses the built-in definition for Number (https://pursuit.purescript.org/builtins/docs/Prim#t:Number). This means that any number type (including non-integers) will be decoded and interpreted as being integers. When adding a new numerical datatype, one should be wary of this.
