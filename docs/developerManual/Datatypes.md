# The Frontend and Data Types
As we mentioned in the Introduction, the vizualization code must somehow choose how to present data: In a user interface a request to enter a string for e.g. a name will usually be presented in a different way then a request to enter a number for e.g. the amount of items a user wants.

In this project the choice was made to base this distinction upon the data type. So, data of the type 'string' will be presented in a certain manner, while boolean data will be presented in a different manner. This choice is seen best at the 'end' of the representation process, to wit in the 'Forms' that are used to build the UI. Therefore, we will now discuss the Form.purs module, which is part of the HTML code in Component (Component/HTML/Form.purs).

### The Form module theory
As mentioned in the Form.purs module itself, it is "*Very* loosely inspired by
https://github.com/fpco/halogen-form/blob/master/src.Halogen/Form.purs. However, the corresponding introduction in https://github.com/fpco/halogen-form gives a very good introduction into the principles of form usage, and may be very helpful for understanding the form.purs module in this project. Furthermore, the formlet concept upon this form usage is based is introduced by Cooper, Lindley, Wadler and Yallop's paper [The Essence of Form Abstraction](http://homepages.inf.ed.ac.uk/slindley/papers/formlets-essence.pdf). Reading this paper, as well as the aforementioned introduction by chrisdone on github could be very helpful in designing more complex forms. 

However, as mentioned, the code in the Form.purs module is not an exact replication of the above principles, so we will discuss the actual code as well.

### The Form module in practice
#### Component State
An essential part of the formlet concept is the state that is associated with a component. In the current Form.purs module (line 31) this state is represented by the 'FormState' type shown below:

```
type FormState a
  = { rawValue :: String
    , isValid :: Boolean
    , validate :: Validator a
    , widget :: FormWidget
    , lastChangeAt :: Instant
    }
```
**Figure 1**  FromState type in Form.purs.

The 'rawValue' of the state is a String. This data type was probably chosen based on the JSON data representation of raw data in the project. If you are not familiar with the JSON data representation, you may read about it in our introductory manual for web programming with purescript: https://github.com/tophatsilk/Purescript-HTML-tutorial/Chapter4.md, in which we also discuss the standard purescript Argonaut module for JSON that is used in this project.

The parser-based validation (represented by the isValid and validate types) is based on the validation principle for formlets (See: https://github.com/fpco/halogen-form).

The 'widget of the 'FromWidget' type is an essential part of the form when it comes to data type handling. This is where the choice of the form, based on the data type, is stored. This may be seen in the definition of the FormWidget on line 45:
```
data FormWidget
  = IntInput
  | TextInput
  | BooleanInput
```
Expanding the number of data types will have to start here.


And finally, there is the manner upon which the information in the interface is updated, something that is not discussed in detail in the above theory. In the current project a 'timestamp' was chosen to distinguish old data from new data. This timestamp is generated using the standard purescript Data.DateTime.Instant module (https://pursuit.purescript.org/packages/purescript-datetime/6.1.0/docs/Data.DateTime.Instant). In the FormState type shown in Fig. 1, the timestamp is recorded as the 'lastChaneAt' value.
