#!/bin/bash
set -euo pipefail

FTP_HOST="ftp.world4you.com"
FTP_USER="ftp2964639"
REMOTE_DIR="/" # change if needed
LOCAL_DIR="public"

echo "Building Hugo site..."
rm -rf public
hugo --minify

if [ ! -d "$LOCAL_DIR" ]; then
    echo "Error: $LOCAL_DIR directory not found."
    exit 1
fi

echo "Retrieving password from macOS Keychain..."
FTP_PASS=$(security find-internet-password -a "$FTP_USER" -s "$FTP_HOST" -w 2>/dev/null) || {
    echo "Error: FTP password not found in Keychain."
    echo "Store it with:"
    echo "security add-internet-password -a $FTP_USER -s $FTP_HOST -r ftps -w 'your_password'"
    exit 1
}

curl -T "${LOCAL_DIR}/" \
    --ftp-create-dirs \
    --user "${FTP_USER}:${FTP_PASS}" \
    "${FTP_HOST}${REMOTE_DIR}" \
    --ftp-method nocwd \
    --globoff \
    --silent \
    --show-error \
    --fail \
    --ftp-pasv \
    --quote "EPSV" \
    --upload-file <(tar -C "$LOCAL_DIR" -cf - .) || true

# Safer recursive upload using lftp if available
if command -v lftp >/dev/null 2>&1; then
    echo "Using lftp mirror for reliable recursive upload..."
    lftp -u "${FTP_USER}","${FTP_PASS}" "${FTP_HOST}" <<EOF
set ftp:passive-mode true
mirror -R --delete --verbose $LOCAL_DIR $REMOTE_DIR
bye
EOF
else
    echo "Warning: lftp not installed. Install it for proper recursive sync:"
    echo "brew install lftp"
    exit 1
fi

echo "Deployment complete."
