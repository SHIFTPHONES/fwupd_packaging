#!/bin/bash

METAINFO_TEMPLATE="metainfo.xml"

###############################
# Image information (edit this)
IMAGE_DATE="2022-08-31"
IMAGE_NAME="abl_20220831"
IMAGE_URL="https://gitlab.shift-gmbh.com/ShiftOSS/android_proprietary_vendor_firmware/-/raw/047d5c8ced59a95c509d4894178999a5edbd05eb/axolotl/radio/abl.img"
IMAGE_VERSION="3.9.20220831"
#
###############################

METAINFO_FILE="${IMAGE_NAME}.${METAINFO_TEMPLATE}"

echo "[!] Do not forget to adjust the description of metainfo.xml"
echo "[!] to contain the real changelog before committing"

# Download firmware image
curl -o "${IMAGE_NAME}.img" "${IMAGE_URL}"

# Generate checksums
SHA1=($(sha1sum "${IMAGE_NAME}.img"))
SHA256=($(sha256sum "${IMAGE_NAME}.img"))

# Copy template and fill out fields
cp "${METAINFO_TEMPLATE}" "${METAINFO_FILE}"
sed -i "s/SCRIPT_MARKER_FILENAME/${IMAGE_NAME}.img/g" ${METAINFO_FILE}
sed -i "s/SCRIPT_MARKER_VERSION/${IMAGE_VERSION}/g"   ${METAINFO_FILE}
sed -i "s/SCRIPT_MARKER_DATE/${IMAGE_DATE}/g"         ${METAINFO_FILE}
sed -i "s/SCRIPT_MARKER_SHA1/${SHA1}/g"               ${METAINFO_FILE}
sed -i "s/SCRIPT_MARKER_SHA256/${SHA256}/g"           ${METAINFO_FILE}

gcab --create \
    "${IMAGE_NAME}.cab" \
    "${IMAGE_NAME}.img" \
    "${IMAGE_NAME}.${METAINFO_TEMPLATE}"
