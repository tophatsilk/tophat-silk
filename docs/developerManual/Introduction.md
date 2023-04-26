# Developer manual for TopHat vizualization project: Introduction
This manual is intended for developers of the purescript-based proof-of-concept TopHat GUI developed by Gerarts, De Hoog, Naus, and Steenvoorden ([Gerarts, De Hoog, Naus, and Steenvoorden](https://github.com/mark-gerarts/ou-afstuderen-artefact)). The current framework is not yet a fully fledged TOP framework [A] and this manual is meant for developers working on its expansion. In this manual we will elaborate on the information in the introductory paper [A]. The aim of this manual is to aid new developers by providing background information on the modules and functions. This part of the manual describes the frontend of the framework.

## TopHat
The TopHat language for which the UI was developed, is a task oriented language developed for modular interactive workflows, which allows formal reasoning about programs. It was developed by Steenvoorden, Naus. and Klinik [B]. A Haskell implementation of it may be found on: https://github.com/timjs/tophat-haskell. The current vizualization framework is build upon this Haskell implementation.

## Software Requirements and Installation
As mentioned, the original project may be found at: https://github.com/mark-gerarts/ou-afstuderen-artefact.

The project was written in purescript version 14 and is not compatible with version 15 or higher. Windows or Mac users will have to downgrade purescript to version 14. For linux users we provide an installation script below.

The software versions needed are:

General software:
- ghc 8.8.4
- npm 8.5.1
- cabal 3.0.0.0
- zlib1g 1:1.2.11
- stack 2.9.1
- hpack 0.34.2

To be installed with npm:
- purescript 0.14
- spago 0.20

### Linux installation script
For linux (debian derivatives) we provide an installation script which will install all the required software (GHC, npm, cabal, zlib1g-dev, stack, hpack, purescript, and spago). The script was tested on Ubuntu 22.04, but should work with all debian derivatives.
You may find the installation script [here](../install/install-stable-0.1.7.sh).
The installation requires sudo rights. Please install it from the within the directory in which you downloaded the script into, with:
```console
$ sudo apt update
$ sudo apt upgrade
$ sudo sh ./install-stable-0.1.7.sh
```

### Developer notes on upgrading
The installation script may be easily adapted to new software versions, when the project is updated. The versions of the relevant software are given in a list (single point of definition) and may be changed according to requirements.


## Purescript and structural programming
The framework is build in purescript. If you are not familiar with structural programming languages, it is highly recommended to read "Purescript by Example" (https://book.purescript.org/) before reading this manual. If you are familiar with structural programming languages, such as Haskell, you are still recommended to look through this introductory book, but you could probably skip through some parts.

## Frontend structure
The frontend has a modular structure typical of purescript projects as shown below:
<pre>
├── App
│   ├── Client.purs
│   └── Task.purs
├── Component
│   ├── HTML
│   │   ├── Bulma.purs
│   │   ├── Form.purs
│   │   └── Utils.purs
│   └── TaskLoader.purs
└── Main.purs
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