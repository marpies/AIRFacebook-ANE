# iOS patch

Fix for `ld: library not found for -lclang_rt.ios` error when packaging IPA.

Copy `libclang_rt.ios` file from this repository to `AIR_SDK/lib/aot/lib`. Vote for this bug in [Adobe Tracker](https://tracker.adobe.com/#/view/AIR-4198557).