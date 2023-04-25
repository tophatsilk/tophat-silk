: '
# install-stable-0.1.7.sh

Linux installation shell script for TopHat UI framework development project
which may be found at:
https://github.com/mark-gerarts/ou-afstuderen-artefact

This shell script is used to install the required software for a stable version
of the development frontend and backend.

Warning:
This script installs all software globally, using sudo rights. It is advisable to use a 
non-sudo user for the compilation of the development server. The compilation/build script
should, therefore, preferably be run separately by a different (non-sudo) user in the 
projects root directory.

Note: 
The software to be installed requires a download of about 270 Mb and uses about 2.3 Gb of
space after installation.

version 0.1.7
Tested in:
- Ubuntu 22.04

Requires execute permission:
sudo chmod +x install-stable-0.1.7.sh
'
#--------- Versions -------------------------------------------------------
# Stable versions of the required software
# [This is the only information to be updated by the development team.]
# Updated to commit: 38b8414 (Nov. 30, 2022)
# To be installed with apt:
# GHC, npm, cabal, zlib1g-dev, stack, hpack:
GHCVersion="8.8.4"
NPMVersion="8.5.1"
CABALVersion="3.0.0.0"
ZLib1GVersion="1:1.2.11"
STACKVersion="2.9.1"
HPACKVersion="0.34.2"
# To be installed with npm:
# purescript, spago:
PURESCRIPTVersion="0.14"
SPAGOVersion="0.20"

# Note: The stack version for Ubuntu 22.04 is too old.
# Required is: stack version 2.9.1
# Once the Ubuntu repository contains version 2.91 and higher
# the script may be adapted below at lines 104-111.

#--------- Functions -------------------------------------------------------
# Function aptInstallStableVersion()
# Tests the availability of the required software version, and if available, 
# installs it with apt.
# Param $1: name of the software
# Param $2: stable version number

aptInstallStableVersion()
{
  softwareName=$1
  versionNr=$2
  if apt list --all-versions $softwareName | grep -q $versionNr
  then 
    sudo apt -o Apt::Get::Assume-Yes=true install $softwareName=$versionNr*
    echo "Successful installation of $softwareName is completed."
  else
    echo "Installation of stable software failed on installation of $softwareName-version: $versionNr"
    exit;
  fi
}


# Function npmInstallStableVersion()
# Tests the availability of the required software version, and if available, 
# installs it with npm.
# Param $1: name of the software
# Param $2: stable version number

npmInstallStableVersion()
{
  softwareName=$1
  versionNr=$2
  if npm show $softwareName versions | grep -q $versionNr
  then 
    sudo yes | npm install -g $softwareName@^$versionNr
    echo "Successful installation of $softwareName is completed."
  else
    echo "Installation of stable software failed on installation of $softwareName-version: $versionNr"
    exit;
  fi
}


#--------- Main ----------------------------------------------------------
echo "Installing stable versions of required software.";

# Installing software with apt:
 
aptInstallStableVersion "ghc" $GHCVersion;
aptInstallStableVersion "ghc-prof" $GHCVersion;
aptInstallStableVersion "ghc-doc" $GHCVersion;

aptInstallStableVersion "zlib1g-dev" $ZLib1GVersion;

# Note: The stack version for Ubuntu 22.04 is too old.
# Required is: stack version 2.9.1
# Once the Ubuntu repository contains version 2.91 and higher
# you can comment the two lines below and uncomment the standard
# install line below those two.
sudo apt -o Apt::Get::Assume-Yes=true install haskell-stack
sudo stack upgrade --force-download;
# aptInstallStableVersion "stack" $STACKVersion;

aptInstallStableVersion "hpack" $HPACKVersion;

aptInstallStableVersion "npm" $NPMVersion;

aptInstallStableVersion "cabal-install" $CABALVersion;

# Installing software with npm:
npmInstallStableVersion "purescript" $PURESCRIPTVersion

npmInstallStableVersion "spago" $SPAGOVersion

echo "Installation successful!"



