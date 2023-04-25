# Usage

## Installation

The project is currently untested as a library, however it *should* just work.

However, the project was written in purescript version 14 and is not compatible with version 15 or higher. Windows or Mac users will have to downgrade purescript to version 14. For linux users we provide an installation script below.

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


## Linux installation script
For linux (debian distros) we provide an installation script which will install all the required software (GHC, npm, cabal, zlib1g-dev, stack, hpack, purescript, and spago). The script was tested on Ubuntu 22.04, but should work with all debian derivatives.
You may find the installation script [here](../install/install-stable-0.1.7.sh).
The installation requires sudo rights. Please install it from the within the directory in which you downloaded the script into, with:
```console
$ sudo apt update
$ sudo apt upgrade
$ sudo sh ./install-stable-0.1.7.sh
```


## Usage

The library exposes a single function: `visualizeTask`. The library will spin up
a web server to visualize the passed task. By default, the application can be
accessed at [http://localhost:3000](http://localhost:3000). The port number can
be changed by passing it as an environment variable, e.g.:

```console
$ PORT=3001 stack run
```

Consider the following example:

```
{-# LANGUAGE OverloadedStrings #-}

import Task (Task, enter, view, (>>?))
import Visualize (visualizeTask)

main :: IO ()
main = visualizeTask greet

greet :: Task h Text
greet =
  (question >< promptName)
    >>? \(_, name) -> view ("Hello, " <> name)
  where
    question :: Task h Text
    question = view "What is your name?"

    promptName :: Task h Text
    promptName = enter
```

This will produce the following application when run:

![Hello World](./hello_world.png)

Take a look at the `app` directory for some more examples. To run a specific
example:

```$console
$ stack runghc app/TemperatureCalculator.hs
```
