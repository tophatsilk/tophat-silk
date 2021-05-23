{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE NoImplicitPrelude #-}

import "tophat" Task (Task, update, view, (>>?), enter, Task(Done), Task(Fail))
import "ou-afstuderen-artefact" Visualize (visualizeTaskDevel)
import "tophat" Prelude

-- This file is used for development purposes in combination with yesod-devel.
main :: IO ()
main = visualizeTaskDevel initialTask

-- Some dummy task to showcase all 3 currently supported types working together.
initialTask :: Task h Unit
initialTask =
  Fail