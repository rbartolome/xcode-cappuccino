#!/bin/sh

##################
### CAPPUCCINO ###
##################

#validate cappuccino Frameworks path
if test -n "$CAPP_FRAMEWORKS_PATH";
then
	cappFrameworksPath=$CAPP_FRAMEWORKS_PATH;
else
	#search for cappuccino frameworks with spotlight
	cappFrameworksPaths=$(mdfind "kMDItemContentType == 'public.folder' && kMDItemDisplayName == 'Frameworks'");
	cappFrameworksPath="/usr/local/narwhal/packages/cappuccino/Frameworks";
	for aCappFrameworksPath in $cappFrameworksPaths; do
		if test $aCappFrameworksPath -nt $cappFrameworksPath;
		then
			if test ! -z "$(echo $aCappFrameworksPath | awk '/cappuccino\/Frameworks/')";
				then 
				cappFrameworksPath=$aCappFrameworksPath;
			fi
		fi
	done;
fi

#copy cappuccino frameworks
if test -d $cappFrameworksPath;
then
	rm -rf ./Frameworks;
	cp -rf $cappFrameworksPath .;
	echo "Copy Cappuccino Frameworks from location '$cappFrameworksPath'";
fi

#validate cappuccino bin path
if test -d "$CAPP_BIN_PATH";
then
	cappBinPath="$CAPP_BIN_PATH";
else
	#search for objj bin with spotlight
	cappBinPaths=$(mdfind "kMDItemContentType == 'public.unix-executable' && kMDItemDisplayName == 'nib2cib'");
	cappBinPath="/usr/local/narwhal/packages/cappuccino/bin";
	for aCappBinPath in $cappBinPaths; do
		if test $aCappBinPath -nt $cappBinPath;
		then
			if test ! -z "$(echo $aCappBinPath | awk '/cappuccino\/bin/')";
				then 
				cappBinPath=$aCappBinPath;
			fi
		fi
	done;
	cappBinPath=$(echo $cappBinPath | sed -e 's/\/objj$//');
fi

echo "Cappuccino binary path is '$cappBinPath'";

#add cappuccino bin to profile
PATH=${PATH}:$cappBinPath;


##################
### OBJECTIVE-J###
##################

# validate objj runtime path
if test -n "$OBJJ_RUNTIME_PATH";
then
	objjRuntimePath="$OBJJ_RUNTIME_PATH";
else
	objjRuntimePath="/usr/local/narwhal/packages/objective-j/Frameworks";
	#search for cappuccino frameworks with spotlight
	objjRuntimePaths=$(mdfind "kMDItemContentType == 'public.folder' && kMDItemDisplayName == 'Frameworks'");
	objjRuntimePath="/usr/narwhal/packages/objective-j/Frameworks";
	for aObjjRuntimePath in $objjRuntimePaths; do
		if test $aObjjRuntimePath -nt $objjRuntimePath;
		then
			if test ! -z "$(echo $aObjjRuntimePath | awk '/objective-j\/Frameworks/')";
				then 
				objjRuntimePath=$aObjjRuntimePath;
			fi
		fi
	done;
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
	#search for objj bin with spotlight
	objjBinPaths=$(mdfind "kMDItemContentType == 'public.unix-executable' && kMDItemDisplayName == 'objj'");
	objjBinPath="/usr/local/narwhal/packages/objective-j/bin";
	for aObjjBinPath in $objjBinPaths; do
		if test $aObjjBinPath -nt $objjBinPath;
		then
			if test ! -z "$(echo $aObjjBinPath | awk '/objective-j\/bin/')";
				then 
				objjBinPath=$aObjjBinPath;
			fi
		fi
	done;
	objjBinPath=$(echo $objjBinPath | sed -e 's/\/objj$//');
fi

echo "Objective-J binary path is '$objjBinPath'";

#add objj bin to profile
PATH=${PATH}:$objjBinPath;


###############
### NARWHAL ###
###############

#search for narwhal bin with spotlight
narwhalBinPaths=$(mdfind "kMDItemContentType == 'public.unix-executable' && kMDItemDisplayName == 'narwhal'");
narwhalBinPath="narwhalBin";
for aNarwhalBin in $narwhalBinPaths; do
	if test $aNarwhalBin -nt $narwhalBinPath;
	then
		if test ! -z "$(echo $aNarwhalBin | awk '/narwhal\/bin/')";
			then 
			narwhalBin=$aNarwhalBin;
		fi
	fi
done;
narwhalBin=$(echo $narwhalBin | sed -e 's/\/narwhal$//');
PATH=${PATH}:$narwhalBin;
echo "NARWHAL binary path is '$narwhalBin'";


### Handle custom frameworks ###
#copy custom frameworks or files to Frameworks
if test -n "$CUSTOM_FRAMEWORKS";
then
	cp -rf $CUSTOM_FRAMEWORKS ./Frameworks/
fi


###############
### NIB2CIB ###
###############

echo "Check Interface Builder Files ....";

# for xib files
xibFiles=$(find . -type f -name "*.xib");
for xibFile in $xibFiles; do
 cibFile=$(echo $xibFile | sed -e 's/\.xib$/.cib/');
 test $xibFile -nt $cibFile && nib2cib $xibFile || echo "- Interface Builder File '$cibFile' is up-to-date";
done;

# for nib files
nibFiles=$(find . -type d -name "*.nib");
for nibFile in $nibFiles; do
 	cibFile=$(echo $nibFile | sed -e 's/\.nib$/.cib/');
	test $nibFile -nt $cibFile && nib2cib $nibFile || echo "- Interface Builder File \'$cibFile\' is up-to-date";
done;


#################
### CORE DATA ###
#################

momcBinPaths=$(mdfind "kMDItemContentType == 'public.unix-executable' && kMDItemDisplayName == 'momc'");
momcBin="momc";
for aMomcBin in $momcBinPaths; do
	if test $aMomcBin -nt $momcBin;
	then
		momcBin=$(echo $aMomcBin | sed -e 's/\momc$//');
	fi
done;
echo 'MOMC file location is '$momcBin'';
PATH=${PATH}:momcBin;

xcdmodels=$(find . -type d -name "*.xcdatamodel");
for xcdmodel in $xcdmodels; do
	xccpdfile=$(echo $xcdmodel | sed -e 's/\.xcdatamodel$/.cxcdatamodel/');
	momc $xcdmodel $xccpdfile
	plutil -convert xml1 $xccpdfile
	echo "- Core Data Model '$xcdmodel' converted";
done;