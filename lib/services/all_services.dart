import 'package:get/get.dart';
import 'package:portfolio_tracker/controllers/currency_controller.dart';
import 'package:portfolio_tracker/services/http_service.dart';

class AllServices {
  Future<void> registerServices() async {
    Get.put(HttpService());
  }

  Future<void> registerControllers() async {
    Get.put(CurrencyController());
  }
}
