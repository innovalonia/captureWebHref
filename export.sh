#!/bin/sh
set -e

echo "* Compressing project into CaptureWebHref-iOS.zip"
zip --symlinks -r CaptureWebHref-iOS.zip . -x *.git*

echo "Done"
