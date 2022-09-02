#!/bin/bash

METAINFO_TEMPLATE="metainfo.xml"
OUTPUT_DIRECTORY="output"

###############################
# Image information (edit this)
IMAGE_DATE="2022-08-31"
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

echo "##########################"
echo "# IMAGE_DATE=${IMAGE_DATE}"
echo "# IMAGE_URL=${IMAGE_URL}"
echo "# IMAGE_VERSION=${IMAGE_VERSION}"
echo "# IMAGE_DESCRIPTION="
echo "${IMAGE_DESCRIPTION}"
echo "##########################"
echo ""

IMAGE_NAME="abl_${IMAGE_VERSION}"
METAINFO_FILE="${IMAGE_NAME}.${METAINFO_TEMPLATE}"

OUTPUT_GCAB_FILE="${IMAGE_NAME}.cab"
OUTPUT_IMAGE_FILE="${IMAGE_NAME}.img"
OUTPUT_METAINFO_FILE="${METAINFO_FILE}"

# Clean output directory
rm -rf "${OUTPUT_DIRECTORY}"
mkdir -p "${OUTPUT_DIRECTORY}"

# Download firmware image
curl --silent --output "${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}" "${IMAGE_URL}"

# Generate checksums
SHA1=($(sha1sum "${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}"))
SHA256=($(sha256sum "${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}"))

# Generate final metainfo file
awk \
    -v IMAGE_FILE="${OUTPUT_IMAGE_FILE}" \
    -v VERSION="${IMAGE_VERSION}" \
    -v DATE="${IMAGE_DATE}" \
    -v SHA1="${SHA1}" \
    -v SHA256="${SHA256}" \
    -v DESCRIPTION="${IMAGE_DESCRIPTION}" '{
        sub(/SCRIPT_MARKER_FILENAME/, IMAGE_FILE);
        sub(/SCRIPT_MARKER_VERSION/, VERSION);
        sub(/SCRIPT_MARKER_DATE/, DATE);
        sub(/SCRIPT_MARKER_SHA1/, SHA1);
        sub(/SCRIPT_MARKER_SHA256/, SHA256);
        sub(/SCRIPT_MARKER_DESCRIPTION/, DESCRIPTION);
        print;
    }' "${METAINFO_TEMPLATE}" > "${OUTPUT_DIRECTORY}/${OUTPUT_METAINFO_FILE}"

echo "[+] Generating '${OUTPUT_DIRECTORY}/${OUTPUT_GCAB_FILE}' using:"
echo "[+]   - image:    ${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}"
echo "[+]   - metainfo: ${OUTPUT_DIRECTORY}/${OUTPUT_METAINFO_FILE}"
cd "${OUTPUT_DIRECTORY}"
gcab --create \
    "${OUTPUT_GCAB_FILE}" \
    "${OUTPUT_IMAGE_FILE}" \
    "${OUTPUT_METAINFO_FILE}"
cd ..
echo ""

echo "Done, have a nice day!"
