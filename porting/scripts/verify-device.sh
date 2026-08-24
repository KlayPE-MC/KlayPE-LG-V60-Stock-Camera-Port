#!/usr/bin/env bash
set -euo pipefail

adb root >/dev/null

echo "Packages"
adb shell pm path com.lge.camera
adb shell pm path com.lge.camerasolution

echo "Shared library"
adb shell dumpsys package libraries | grep -F com.lge.camerasolution

echo "Critical files"
adb shell 'for f in \
  /system_ext/framework/com.lge.camerasolution.jar \
  /system_ext/lib64/libLGCameraSolution-jni.so \
  /vendor/lib64/com.lge.feature2.swmf.so \
  /vendor/lib64/com.qti.feature2.hdr.so \
  /vendor/etc/camera/iqm/ai_checker_graph.dlc \
  /vendor/etc/camera/film/0_film.dat; do \
    if [ -r "$f" ]; then echo "OK $f"; else echo "MISSING $f"; fi; \
  done'

echo "Camera provider"
adb shell dumpsys media.camera | head -80

