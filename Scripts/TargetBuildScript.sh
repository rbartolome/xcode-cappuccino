#!/bin/sh

### CAPPUCCINO
#validate cappuccino Frameworks path
if test -n "$CAPP_FRAMEWORKS_PATH";
then
	cappFrameworksPath=$CAPP_FRAMEWORKS_PATH;
else
	cappFrameworksPath="/usr/local/narwhal/packages/cappuccino/Frameworks";
fi

#copy cappuccino frameworks
if test -d $cappFrameworksPath;
then
	rm -rf ./Frameworks;
	cp -rf $cappFrameworksPath .;
	echo "Copy Cappuccino Frameworks from location '$cappFrameworksPath'";
fi

#validate cappuccino bin path
if test -n "$CAPP_BIN_PATH";
then
	cappBinPath="$CAPP_BIN_PATH";
else
	cappBinPath="/usr/local/narwhal/packages/cappuccino/bin";
fi

#add cappuccino bin to profile
PATH=${PATH}:$cappBinPath;

### OBJECTIVE-J
# validate objj runtime path
if test -n "$OBJJ_RUNTIME_PATH";
then
	objjRuntimePath="$OBJJ_RUNTIME_PATH";
else
	objjRuntimePath="/usr/local/narwhal/packages/objective-j/Frameworks";
fi

# copy the objective-j runtime
if test -d $objjRuntimePath;
then
	echo "Copy Objective-J Frameworks from location '$objjRuntimePath'";
	cp -rf $objjRuntimePath/* Frameworks
fi

# validate objj bin path
if test -n "$OBJJ_BIN_PATH";
then
	objjBinPath="$OBJJ_BIN_PATH";
else
	objjBinPath="/usr/local/narwhal/packages/objective-j/bin";
fi

#add objj bin to profile
PATH=${PATH}:$objjBinPath;
#PATH=${PATH}:"/usr/local/narwhal/bin";

### Handle custom frameworks
#copy custom frameworks or files to Frameworks
cp -rf $CUSTOM_FRAMEWORKS ./Frameworks/


### Handle nib and cib files
echo "Check Interface Builder Files ....";

### for xib files
xibFiles=$(find . -type f -name "*.xib");
for xibFile in $xibFiles; do
 cibFile=$(echo $xibFile | sed -e 's/\.xib$/.cib/');
 test $xibFile -nt $cibFile && nib2cib $xibFile || echo "Interface Builder File '$cibFile' is up-to-date";
done;

### for nib files
nibFiles=$(find . -type d -name "*.nib");
for nibFile in $nibFiles; do
 	cibFile=$(echo $nibFile | sed -e 's/\.nib$/.cib/');
	test $nibFile -nt $cibFile && nib2cib $nibFile || echo "Interface Builder File \'$cibFile\' is up-to-date";
done;


### Handle CoreData model files
# xcode 3.0
PATH=${PATH}:"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
#xcode 3.1
PATH=${PATH}:"/Developer/usr/bin/momc";

xcdmodels=$(find . -type d -name "*.xcdatamodel");
for xcdmodel in $xcdmodels; do
	xccpdfile=$(echo $xcdmodel | sed -e 's/\.xcdatamodel$/.cxcdatamodel/');
	#3.0 momc location: "/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"
	/Developer/usr/bin/momc $xcdmodel $xccpdfile
	plutil -convert xml1 $xccpdfile
done;