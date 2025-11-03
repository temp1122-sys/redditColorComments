#!/usr/bin/env bash

make package
cp ./.theos/_/var/jb/Library/MobileSubstrate/DynamicLibraries/*.dylib packages/
