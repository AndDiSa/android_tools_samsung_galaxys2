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

    echo "Copying tools for bootpackage ..."
    cp -R boot/updater/* temp/

    echo "Copying system files ..."
    cp -R boot/files/* temp/

    echo "Removing .git files"
    find temp/ -name '.git' -exec rm -r {} \;

    echo "Compressing package ..."
    pushd temp
    zip -r ../$OUTDIR/bootimage-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip ./
    popd

    echo "Signing bootpackage ..."
    java -jar SignApk/signapk.jar SignApk/platform.x509.pem SignApk/platform.pk8 $OUTDIR/bootimage-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip $OUTDIR/bootimage-cm-9-$PRODUCTNAME-$VERSION-signed.zip

    rm $OUTDIR/bootimage-cm-9-$PRODUCTNAME-$VERSION-unsigned.zip
    rm -rf temp/
    echo "bootimage-cm-9-$PRODUCTNAME-$VERSION-signed.zip is at $OUTDIR"
    echo "Done."
else
	echo -e "\n";
	echo "USAGE: boot.sh DEVICE VERSION";
	echo "EXAMPLE: boot.sh galaxys2 02102012";
	echo "Supported Devices: galaxys2";
fi
