# Suggestions for future development
This fork of the TopHat GUI developed by Gerarts, De Hoog, Naus, and Steenvoorden (Gerarts, De Hoog, Naus, and Steenvoorden [1]) has seen several changes in comparison to the original. During the development we discovered some issues and ideas that may be the basis for future development. In the following we will suggest several options for future development ordered by increasing complexity and efforts. Several of those may be combined, for example, the generic flexbox-based Form could be combined with Haskell Reflex as well.
- Rearranging the code to separate datatype dependent code from independent code. This is partly done already in this fork by moving code to the /Component/Datastructure/Typedefinitions.purs module.
- Introducing generic Json encoding and decoding instead of datatype specific encoding (See the [chapter on Json](./JsonEncoding.md).) This entails the choice whether to keep the encoding of the basic datatypes (Boolean, Int, Number, and String) separate or to encode these as records with a tag.
- Developing a generic Form, for example based on the CSS flexbox container (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox) that may be used for a number of datatypes, containing multiple input and output boxes.
- Changing the entire backend-frontend design by using Haskell Reflex package: https://hackage.haskell.org/package/reflex to create the GUI instead of  Purescript.


# References

[1] https://github.com/mark-gerarts/ou-afstuderen-artefact