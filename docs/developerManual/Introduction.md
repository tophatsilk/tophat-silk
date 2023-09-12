# Developer manual for TopHat vizualization project: Introduction
This manual is intended for developers of the purescript-based proof-of-concept TopHat GUI developed by Gerarts, De Hoog, Naus, and Steenvoorden (Gerarts, De Hoog, Naus, and Steenvoorden [1]). The current framework is not yet a fully fledged TOP framework [2] and this manual is meant for developers working on its expansion. In this manual we will elaborate on the information in the introductory paper [2]. The aim of this manual is to aid new developers by providing background information on the modules and functions. This part of the manual describes the frontend of the framework.

A separate manual to help install and set up the development environment is given [here](../development.md).



## TopHat
The TopHat language for which the UI was developed, is a task oriented language developed for modular interactive workflows, which allows formal reasoning about programs. It was developed by Steenvoorden, Naus. and Klinik [3]. A Haskell implementation of it may be found on: https://github.com/timjs/tophat-haskell. The current vizualization framework is build upon this Haskell implementation.

## Purescript and structural programming
The framework is build in purescript. If you are not familiar with structural programming languages, it is highly recommended to read "Purescript by Example" (https://book.purescript.org/) before reading this manual. If you are familiar with structural programming languages, such as Haskell, you are still recommended to look through this introductory book, but you could probably skip through some parts.

## Frontend structure
The frontend has a modular structure typical of purescript projects as shown below:
<pre>
├── App
│   ├── Client.purs
│   └── Task.purs
├── Component
│   ├── Datastructure
│   │   ├── Typedefinitions.purs<sup>(i)</sup>
│   ├── HTML
│   │   ├── Bulma.purs
│   │   ├── Form.purs
│   │   └── Utils.purs
│   └── TaskLoader.purs
└── Main.purs

<sup>(i)</sup>This module and its directory were added in this fork to start the separation of datatype dependent code fron non-dependent code.
</pre>

**Figure 1: Directory structure of the frontend.**

And though we will try to avoid copying code that is already in the project, in this manual, the Main module is shown below to demonstrate the peculiarities of 'programming for the web', or, in this case, 'programming for an UI' in purescript:
```
module Main where

import Prelude
import Component.TaskLoader (taskLoader)
import Data.Foldable (for_)
import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.ParentNode (QuerySelector(..))

main :: Effect Unit
main =
  HA.runHalogenAff do
    entryPoint <- HA.selectElement $ QuerySelector "#halogen-app"
    for_ entryPoint (runUI taskLoader unit)
```
**Figure 2: Listing of the Main.purs module.**

As you can see, the entire main module is a call to something called Halogen. This Halogen module is the current standard for HTML programming in purescript, and much of this manual will cover its specifics.
Closer study of the above Main module reveals there is only one function that is not part of the standard purescript libraries: the taskLoader function imported from the Component module which can be seen in Figure 1 above. The "#halogen-app" which is used for the QuerySelector, is simply the id of the HTML division used in the index.html main file.


Therefore, to understand the frontend, we need to understand how Halogen is applied. The Halogen module framework is explained in detail in the 'Halogen Guide' (https://github.com/purescript-halogen/purescript-halogen/tree/master/docs/guide). However, as with more Purescript modules and functions, once you start to deviate from the examples in the books, it can be a bit daunting.
We have written an introductory manual for web programming with purescript: https://github.com/tophatsilk/Purescript-HTML-tutorial, which could be helpful for understanding Halogen. However, this manual is more of an introduction into HTML programming with purescript and does not treat the Halogen module used in this project. It may be helpful to read it anyway.

### Vizualization
As the project is meant to provide a UI for TopHat, an essential part of it is how the information (data) is presented to the user. In other words, how the tasks are presented using HTML. A query for a string, for example, will have to be presented in a different manner than a query for a boolean. In the following chapter we will  look at the way the data types are handled by the vizualization using Halogen: [The Frontend and Data Types](./Datatypes.md).

[Next chapter ->](./Datatypes.md)

# References

[1] https://github.com/mark-gerarts/ou-afstuderen-artefact

[2] Mark Gerarts, Marc de Hoog, Nico Naus, and Tim Steenvoorden. 2021. Creating Interactive Visualizations of TopHat Programs. arXiv:2208.13870v1 [cs.SE] 29 Aug 2022

[3] Tim Steenvoorden, Nico Naus, and Markus Klinik. 2019. TopHat: A formal foundation for task-oriented programming. In *PPDP ’19, October 7–9, 2019, Porto, Portugal*. https://doi.org/10.1145/3354166.3354182