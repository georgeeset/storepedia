import 'package:device_info/device_info.dart';

class DeveiceInfo{

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<String> androidDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.fingerprint; 
  }
 
  Future<String> iosDeviceInfo()async{
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }

}