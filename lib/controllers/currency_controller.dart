import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:portfolio_tracker/models/api_response.dart';
import 'package:portfolio_tracker/models/coin_data.dart';
import 'package:portfolio_tracker/models/tracked_asset.dart';
import 'package:portfolio_tracker/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedCurrencies = <TrackedAsset>[].obs;

  @override
  void onInit() {
    getCurrenciesData();
    _loadTrackedCurrenciesFromStorage();
    super.onInit();
  }

  // get currency data from the api
  Future<void> getCurrenciesData() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var responseData = await httpService.getResponse("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  //add currencies to the portfolio
  void addCurrencies(String name, double amount) async {
    trackedCurrencies.add(TrackedAsset(
      name: name,
      amount: amount,
    ));

    List<String> data =
        trackedCurrencies.map((assets) => jsonEncode(assets)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tracked_assets", data);
  }

  void _loadTrackedCurrenciesFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_assets");
    if (data != null) {
      trackedCurrencies.value = data
          .map((e) => TrackedAsset.fromJson(
                jsonDecode(e),
              ))
          .toList();
    }
  }

  //sum the price and amount of all currencies in portfolio.
  double getPortfolioValue() {
    if (trackedCurrencies.isEmpty) {
      return 0;
    }

    double value = 0.0;
    for (TrackedAsset currencies in trackedCurrencies) {
      value += getCurrenciesPrice(currencies.name!) * currencies.amount!;
    }
    return value;
  }

  //get price of the currency
  double getCurrenciesPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  //get actual coin data object
  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
