# The Frontend and Data Types
As we mentioned in the Introduction, the vizualization code must somehow choose how to present data: In a user interface a request to enter a string for e.g. a name will usually be presented in a different way then a request to enter a number for e.g. the amount of items a user wants.

In this project the choice was made to base this distinction upon the data type. So, data of the type 'string' will be presented in a certain manner, while boolean data will be presented in a different manner. This choice is seen best at the 'end' of the representation process, to wit in the 'Forms' that are used to build the UI. Therefore, we will now discuss the Form.purs module, which is part of the HTML code in Component (Component/HTML/Form.purs).

#### The (Halogen) Component itself
As one may see on line 56 in the Form.purs module, a component is defined in the same way as in the Halogen Guide (https://github.com/purescript-halogen/purescript-halogen/tree/master/docs/guide).
The essential parts of the Component are its State, the render function, and the (handle)Action/evaluation part.

### The Form module theory
As mentioned in the Form.purs module itself, it is "*Very* loosely inspired by
https://github.com/fpco/halogen-form." However, the corresponding introduction in https://github.com/fpco/halogen-form gives a very good introduction into the principles of form usage, and may be very helpful for understanding the form.purs module in this project. Furthermore, the formlet concept upon this form usage is based is introduced by Cooper, Lindley, Wadler and Yallop's paper [The Essence of Form Abstraction](http://homepages.inf.ed.ac.uk/slindley/papers/formlets-essence.pdf). Reading this paper, as well as the aforementioned introduction by chrisdone on github could be very helpful in designing more complex forms. 

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
**Figure 2**  FromWidget definition in Form.purs.

These FormWidget are called in the helper functions at lines 78-104 in the Form.purs, that verify input.

Expanding the number of data types will have to start here.

The FormStates that are produced by the helper functions at lines 78-104 in the Form.purs, are used to choose the ComponentHTML (HTML representation) which is used to present the inputs. This is done in the render section of Form.purs which starts at line 144. The rendering will be discussed later on.


And finally, there is the manner upon which the information in the interface is updated, something that is not discussed in detail in the above theory. In the current project a 'timestamp' was chosen to distinguish old data from new data. This timestamp is generated using the standard purescript Data.DateTime.Instant module (https://pursuit.purescript.org/packages/purescript-datetime/6.1.0/docs/Data.DateTime.Instant). In the FormState type shown in Fig. 1, the timestamp is recorded as the 'lastChaneAt' value.

#### Component rendering
In accordance to the Halogen component structure, a render function is provided (line 144 in Form.purs). In the definition of this structure, again, the distinction is made between the three datatypes (Int, Text, Boolean). For each type a separate render function is defined. This implies that, if we were to introduce a new datatype, a new, separate render function will have to be defined using the Halogen syntax.

#### Component action handling
The Halogen handleAction function is defined at line 106. The input is obtained for the Compenent (H.get) and validated, but the state is only modified when the user has stopped type for 500 ms (the 'delay' defined at line 54). Here we see the use of the state parameter 'lastChangedAt' to record the input timing.
As long as a proper validation function ('validate') is provided for the datatype, a new datatype apparently requires no changes here.

### User Input and Numbers
The form that is used to enter numbers, uses the HTML class input with type 'number' (https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/number). This limits the entry options, because without special measures this input class only accepts integers, although this may depend on the browser type. Considering there is no guarantee that the input will accept on-integer numbers, this input type should be used for integers only. 
One might use a relatively simple workaround to add non-integer values. This is by adding the 'step' attribute (https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/number). However, giving this 'step' attribute a low value, such as 0.001, will create the weird effect that changing the number using the stepper arrows in the right part of the input will only increase the input value by this small step. It also requires a step value small enough to obtain the desired floating point number. Which begs the question: "Which step size is small enough to accomodate all future uses of the input type?" A possible solution is using the 'step="any"' attribute.

However, the 'step' attribute does not seem to be supported in the purescript Halogen version used in the current project. In future versions, this may be a solution, because there is a new module: "Html.Codegen.Halogen" (current version: 0.01) that does support the 'step' attribute.

An alternative approach is using the attribute: 'inputmode="decimal"', and possibly a 'pattern="[0-9]*[.,]?[0-9]*" ' attribute.
(https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/inputMode)

However, purescript does not, at the moment, support the 'inputmode' attribute.
When we try to add the property as described in the "Rendering HTML" chapter of the Halogen Guide.
```
inputmode :: forall r i. String -> HH.IProp ( sandbox :: String | r ) i
inputmode = HH.prop (HH.PropName "inputmode")
```
We get a type error. So it seems this property is not supported by Halogen neither.

#Note: Using alternative input modes, such as the pattern attribute, may void the standard validation supplied by the HTML input number type, and may require extra validation of the user input.


### Datatype distinction beyond the Form module
In the sections above we discussed how the frontend treats the datatypes differently when it renders a user interface. But the frontend also makes distinction in how the handle the datatypes in its communication. This distinction may be found in the Task.purs module, which we will discuss in the next chapter: [Tasks and Data Types](./Tasks.md).

[Next chapter ->](./Tasks.md)