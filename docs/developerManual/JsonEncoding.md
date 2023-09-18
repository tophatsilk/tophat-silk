[Introduction](./Introduction.md) |  [The Frontend and Data Types](./Datatypes.md)  |  [JSON Encoding](./JsonEncoding.md)  |  [Suggestions for Future Developments](./FutureDevelopments.md)

# JSON encoding and decoding
As JSON encoding and decoding is essential for the communication in the project, we dedicate a separate chapter to it. We even provide two code templates: one for datatype specific JSON encoding, and one for generic JSON encoding.

If you are not familiar with the JSON data representation, you may read about it in our introductory manual for web programming with Purescript: https://github.com/tophatsilk/Purescript-HTML-tutorial/Chapter4.md, in which we also discuss the standard Purescript Argonaut module for JSON that is used in this project.

### JSON Template for encode testing of new datatypes using non-generic JSON
When you would like to add new datatypes, we would recommend testing the JSON encoding and decoding separately from the main code. That is why we provide a template code for testing the JSON encoding and decoding of new datatypes in a separate directory:
[Non-generic JSON test code template](./Code/GenericJsonTemplate/Main.purs).
This code was written for Purescript v14, and you will have to rewrite the imports to try it in  try.purescript.org, or use the code locally, using the Purescript v14 install script provided. If you would like to try generic encoding and decoding, please look at the following section.

### JSON Template for encode testing of new datatypes using generic JSON
The project was initially developed with a number of basic datatypes (Boolean, Integer, and String). Purescript, however, provides more complex datatypes in the generic module of Argonaut (https://github.com/purescript-contrib/purescript-argonaut-generic). We provide a template at: [Non-generic JSON test code template](./Code/GenericJsonTemplate/Main.purs). This example is based on the JSON example in our introductory manual for web programming with Purescript: https://github.com/tophatsilk/Purescript-HTML-tutorial\Chapter4.md. This template is written in Purescript v15 and you can try it in https://try.purescript.org.

**Note:** The example is written for Purescript v15 and deviates from the  'Quick start' example shown on github. The genericDecodeJson and genericEncodeJson functions are imported from the 'Data.Argonaut.Encode.Generic' module, not the 'Data.Argonaut.Encode.Generic.__Rep__' module.

As you can see in the template, the datatype is defined ("data Information =") and a generic instance is defined with its encoding and decoding. Defining a new datatype is only a matter of a new definition with its instances.

In the Component.Datastructure.Typedefinitions module there is already {-commented out-} code given with suggestions on how to apply generic encoding. To clarify, we will copy part of that code here:
```
{-
-- Definition of a suggested new example type for the content of a Task.
type TaskContentType = { type :: String 
              , UI :: String
              , coordinates :: {x :: Number, y :: Number}
              }
-}
```
**Figure 1**. An example of a record datatype used in generic encoding.
In principle, this record datatype has three parts:
1. The name or tag of the datatype, such as: Boolean, Int, or, in this case 'coordinates', to be encoded.
2. The type of the User Interface. For example, numbers may use a standard input box in which the user can type the number, but you could also,for example, use a slider to enter a number. In the example in Fig. 1, coordinates may be entered by typing numbers, but also by moving a mouse over a canvas. The latter interface is demonstrated in our [Introductory manual for web programming with Purescript](https://github.com/tophatsilk/Purescript-HTML-tutorial/blob/main/Chapter5.md). (**Note:** The event handling in this example deviates from the event handling in our project and may require extra recoding.)
3. The actual datatype data to be encoded.


It might be a good idea to encode all datatypes, even the basic datatypes, using generics. In that case, it would be highly recommended to use a 'tag' with the datatype name, because the decoded product of generic JSON encoding is always a record. The current code would not be able the datatype as such.

As we mentioned above, as well as several times earlier, the project might be expanded by new datatypes, requiring changes in the JSON encoding and decoding. This, however, is not the only way in which the project might develop. That is why we will give suggestions for new developments in our chapter on [Suggestions for Future Developments](./FutureDevelopments.md).

[Next chapter ->](./FutureDevelopments.md)
