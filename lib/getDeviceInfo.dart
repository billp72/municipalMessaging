import 'dart:io';

import 'package:device_info/device_info.dart';

// Get the device ID
Future getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    // For Android devices, get the Android ID
    return deviceInfo.androidInfo.then((androidInfo) {
      return androidInfo.androidId;
    });
  } else if (Platform.isIOS) {
    // For iOS devices, get the identifierForVendor
    return deviceInfo.iosInfo.then((iosInfo) {
      return iosInfo.identifierForVendor;
    });
  }
}
