# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# 0.0.1

New features:

- Added [installation script](/install/install-stable-0.1.7.sh). To install purescript 14 and other requirements in Linux.
- Added [Developer Manual](/docs/developerManual/Introduction.md) with instructions.

- Added a separate [Typedefinitions module](/frontend/src/Component/Datastructure/Typedefinitions.purs) and:
	- Moved datatypes to it, like 'Value' (formerly in Task.purs).
	- Added suggestions for datatypes to it, like 'TaskContentType'.
	
- Added Number datatype to existing basic (Int, Boolean, and String) datatypes. Required changes in:
	- FRONTEND
	    * Typedefinitions
	    * TaskLoader
	    * Forms
	    * all hs-examples
	- BACKEND
	    * Communication.hs

 **WIP:** This last addition is not complete. JSON encoding of Number and Int is not typesafe. Rounded numbers (such as 1.0) are converted to integers (i.e. 1). A possible solution using generic encoding is suggested in [Suggestions for Future Development](/docs/developerManual/FutureDevelopments.md).