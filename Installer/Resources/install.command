#!/bin/sh

#*************************************************************************
# Installation
#********************************************************************************

#create temp directory if necessary
#mkdir /tmp/capp_devtools

# download the latest cappuccino build tool
curl -L http://github.com/280north/cappuccino-package/zipball/master > cappuccino.zip

# unzip cappuccino frameworks
#cd /tmp/capp_devtools
extractDir=$(unzip -l cappuccino.zip | grep "^ *[0-9]\+ \+[0-9\-]\+ \+[0-9:]\+ \+.*" | head -n1 | awk '{print $4}')
unzip cappuccino.zip
rm cappuccino.zip
mv $extractDir Cappuccino

# download the latest Objective-J Runtime
curl -L http://github.com/280north/objective-j-package/zipball/master > objj.zip

# unzip the Objective-J Runtime
#cd /tmp/capp_devtools
extractDir=$(unzip -l objj.zip | grep "^ *[0-9]\+ \+[0-9\-]\+ \+[0-9:]\+ \+.*" | head -n1 | awk '{print $4}')
unzip objj.zip
rm objj.zip 
mv $extractDir Objective-J
