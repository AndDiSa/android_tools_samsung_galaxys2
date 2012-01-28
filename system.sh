#/bin/bash 

PRODUCT="$1"
VERSION="$2"
OUTDIR="out/"

if ( [ $PRODUCT == "galaxys2" ] && [ ! $VERSION == "" ])
then

    case $PRODUCT in
        galaxys2 )
            PRODUCTNAME="SGS2"
            ;;
    esac

    rm -rf temp/
    mkdir -p temp/system
    mkdir -p out

    echo "Copying tools for systempackage ..."
    cp -R system/updater/* temp/

    echo "Copying system files ..."
    cp -R system/files/* temp/system/

    echo "Removing .git files"
    find temp/ -name '.git' -exec rm -r {} \;

    echo "Compressing package ..."
    pushd temp
    zip -r ../$OUTDIR/system-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip ./
    popd

    echo "Signing systempackage ..."
    java -jar SignApk/signapk.jar SignApk/platform.x509.pem SignApk/platform.pk8 $OUTDIR/system-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip $OUTDIR/system-cm-9-$PRODUCTNAME-$VERSION-signed.zip

    rm $OUTDIR/system-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip
    rm -rf temp/
    echo "system-cm-9-$PRODUCTNAME-$VERSION-signed.zip is at $OUTDIR"
    echo "Done."
else
	echo -e "\n";
	echo "USAGE: system.sh DEVICE VERSION";
	echo "EXAMPLE: system.sh galaxys2 GPS_KPA";
	echo "Supported Devices: galaxys2";
fi
