
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/network_controller.dart';

class DependencyInjection{
  static void init(){
    Get.put<NeteworkCntroller>(NeteworkCntroller(),permanent: true);
  }
}