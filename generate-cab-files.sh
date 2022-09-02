#!/bin/bash

METAINFO_TEMPLATE="metainfo.xml"

###############################
# Image information (edit this)
IMAGE_DATE="2022-08-31"
IMAGE_NAME="abl_20220831"
IMAGE_URL="https://gitlab.shift-gmbh.com/ShiftOSS/android_proprietary_vendor_firmware/-/raw/047d5c8ced59a95c509d4894178999a5edbd05eb/axolotl/radio/abl.img"
IMAGE_VERSION="3.9.20220831"
IMAGE_DESCRIPTION=$(cat << EOF
<p>Improvements:</p>
<ul>
  <li>Report ABL version through cmdline</li>
</ul>
EOF
)
#
###############################

METAINFO_FILE="${IMAGE_NAME}.${METAINFO_TEMPLATE}"

# Download firmware image
curl -o "${IMAGE_NAME}.img" "${IMAGE_URL}"

# Generate checksums
SHA1=($(sha1sum "${IMAGE_NAME}.img"))
SHA256=($(sha256sum "${IMAGE_NAME}.img"))

# Generate final metainfo file
awk \
    -v FILENAME="${IMAGE_NAME}.img" \
    -v VERSION="${IMAGE_VERSION}" \
    -v DATE="${IMAGE_DATE}" \
    -v SHA1="${SHA1}" \
    -v SHA256="${SHA256}" \
    -v DESCRIPTION="${IMAGE_DESCRIPTION}" '{
        sub(/SCRIPT_MARKER_FILENAME/, FILENAME);
        sub(/SCRIPT_MARKER_VERSION/, VERSION);
        sub(/SCRIPT_MARKER_DATE/, DATE);
        sub(/SCRIPT_MARKER_SHA1/, SHA1);
        sub(/SCRIPT_MARKER_SHA256/, SHA256);
        sub(/SCRIPT_MARKER_DESCRIPTION/, DESCRIPTION);
        print;
    }' "${METAINFO_TEMPLATE}" > "${METAINFO_FILE}"

gcab --create \
    "${IMAGE_NAME}.cab" \
    "${IMAGE_NAME}.img" \
    "${IMAGE_NAME}.${METAINFO_TEMPLATE}"
