#!/bin/sh

METAINFO_TEMPLATE="metainfo.xml"
OUTPUT_DIRECTORY="output"

###############################
# Image information (edit this)
IMAGE_URGENCY="high"
IMAGE_DATE="2022-12-24"
IMAGE_URL="https://gitlab.shift-gmbh.com/ShiftOSS/android_proprietary_vendor_firmware/-/raw/1bb90b71d9658c74c6643429008480da12a850a8/axolotl/radio/abl.img"
IMAGE_VERSION="5.0.20221224"
IMAGE_DESCRIPTION=$(cat << EOF
<p>This release brings the following fixes and improvements:</p>
<ul>
  <li>Disable parallel download flash operations</li>
  <li>Fix slot switching issues for vendor_boot partitions</li>
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
SHA1=$(sha1sum "${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}" | awk -F' ' '{print $1}')
SHA256=$(sha256sum "${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}" | awk -F' ' '{print $1}')

# Generate final metainfo file
awk \
    -v IMAGE_FILE="${OUTPUT_IMAGE_FILE}" \
    -v VERSION="${IMAGE_VERSION}" \
    -v DATE="${IMAGE_DATE}" \
    -v SHA1="${SHA1}" \
    -v SHA256="${SHA256}" \
    -v DESCRIPTION="${IMAGE_DESCRIPTION}" \
    -v URGENCY="${IMAGE_URGENCY}" '{
        sub(/SCRIPT_MARKER_FILENAME/, IMAGE_FILE);
        sub(/SCRIPT_MARKER_VERSION/, VERSION);
        sub(/SCRIPT_MARKER_DATE/, DATE);
        sub(/SCRIPT_MARKER_SHA1/, SHA1);
        sub(/SCRIPT_MARKER_SHA256/, SHA256);
        sub(/SCRIPT_MARKER_DESCRIPTION/, DESCRIPTION);
        sub(/SCRIPT_MARKER_URGENCY/, URGENCY);
        print;
    }' "${METAINFO_TEMPLATE}" > "${OUTPUT_DIRECTORY}/${OUTPUT_METAINFO_FILE}"

echo "[+] Generating '${OUTPUT_DIRECTORY}/${OUTPUT_GCAB_FILE}' using:"
echo "[+]   - image:    ${OUTPUT_DIRECTORY}/${OUTPUT_IMAGE_FILE}"
echo "[+]   - metainfo: ${OUTPUT_DIRECTORY}/${OUTPUT_METAINFO_FILE}"
(
    cd "${OUTPUT_DIRECTORY}" || echo "Error: directory does not exist: ${OUTPUT_DIRECTORY}" || exit
    gcab --create \
        "${OUTPUT_GCAB_FILE}" \
        "${OUTPUT_IMAGE_FILE}" \
        "${OUTPUT_METAINFO_FILE}"
)
echo ""

echo "Done, have a nice day!"
