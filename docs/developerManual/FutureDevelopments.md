# Suggestions for future development
This fork of the TopHat GUI developed by Gerarts, De Hoog, Naus, and Steenvoorden (Gerarts, De Hoog, Naus, and Steenvoorden [1]) has seen several changes in comparison to the original. During the development we discovered some issues and ideas that may be the basis for future development. In the following we will suggest several options for future development ordered by increasing complexity and efforts. Several of those may be combined, for example, the generic flexbox-based Form could be combined with Haskell Reflex as well.
1. Rearranging the code to separate datatype dependent code from independent code. This is partly done already in this fork by moving code to the /Component/Datastructure/Typedefinitions.purs module.
2. Introducing generic Json encoding and decoding instead of datatype specific encoding (See the [chapter on Json](./JsonEncoding.md).) This entails the choice whether to keep the encoding of the basic datatypes (Boolean, Int, Number, and String) separate or to encode these as records with a tag.
3. Adding new datatypes. (**Note** This and the following, generic Form development should not be considered separately. It might be wise, if you were to introduce the generic Forms, to develop these first, before adding new datatypes, or develop these in tandem.)
4. Developing a generic Form, for example based on the CSS flexbox container (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox) that may be used for a number of datatypes, containing multiple input and output boxes.
5. Updating the project to a newer Purescript version. Purescript is a rather young language, and version updates may sometimes require serious recoding. Even core modules may change and require far more than just changing the imports. For example, Purescript v0.15.0 lists a switch form Common JS to ES modules as breaking change, but the Affjax module used in the App.Client module has undergone several changes as well.
6. Changing the entire backend-frontend design by using the [Haskell Reflex package](https://hackage.haskell.org/package/reflex) to create the GUI instead of Purescript.

Ad. 6. Reflex and Purescript both have advantages and disadvantages.
For example:
- Reflex has the advantage the entire project may be written in Haskell, but for the interface both are converted to Javascript to be used in a browser. In our project we found that this might, for example, endanger typesafety, as we found in our Json encoding and discussed in our chapter on [The Frontend and Data Types](./Datatypes.md).
- Using a Haskell backend and Purescript frontend requires running servers for both (yesod server and npm, respectively in our project), while Reflex only requires the [Obelisk framework](https://github.com/obsidiansystems/obelisk/#installing-obelisk), but Obelisk is developed and maintained by [Obsidian Systems](https://obsidian.systems/) and although they contribute to Open Source Libraries, Obelisk is not fully open in itself. This might be a disadvantage in future projects.
- In line with the above item, Purescript has a larger community, which is a pro for future support guarantees.




Developers, please add your own suggestions to this chapter, with explanations, so your knowledge may be passed on,



# References

[1] https://github.com/mark-gerarts/ou-afstuderen-artefact