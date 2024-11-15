import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:portfolio_tracker/controllers/currency_controller.dart';
import 'package:portfolio_tracker/models/api_response.dart';
import 'package:portfolio_tracker/services/http_service.dart';

class AddCurrencyWidgetController extends GetxController {
  RxBool loading = false.obs; //.obs will make it observable,
  RxList<String> currencies =
      <String>[].obs; //list of all currencies fetched from api.
  RxString selectedCurrency = ''.obs; // selected currency.
  RxDouble currencyValue = 0.0.obs;

  //called immediatly when this controller is allocated in memory.
  @override
  void onInit() {
    _loadData();
    super.onInit();
  }

  void _loadData() async {
    loading.value = true;
    HttpService httpService = Get.find<HttpService>();
    var responseData = await httpService.getResponse('currencies');
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach((coin) {
      currencies.add(coin.name!);
    });

    selectedCurrency.value = currencies.first;
    loading.value = false;
    dev.log(currencies.toString());
  }
}

class AddCurrencyWidget extends StatelessWidget {
  final addCurrencyWidgetController = Get.put(AddCurrencyWidgetController());

  AddCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Obx(
      //* to update the changes in the UI.
      () => Material(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: _currencyWidget(context),
        ),
      ),
    ));
  }

  Widget _currencyWidget(BuildContext context) {
    if (addCurrencyWidgetController.loading.isTrue) {
      return SizedBox(
        height: 10.0,
        width: 10.0,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton(
                  value: addCurrencyWidgetController.selectedCurrency.value,
                  items: addCurrencyWidgetController.currencies.map((currency) {
                    return DropdownMenuItem(
                      child: Text(
                        currency,
                      ),
                      value: currency,
                    );
                  }).toList(),
                  onChanged: (value) {
                    addCurrencyWidgetController.selectedCurrency.value = value!;
                  }),
              TextField(
                onChanged: (value) {
                  addCurrencyWidgetController.currencyValue.value =
                      double.parse(value);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
              ElevatedButton(
                  onPressed: () {
                    CurrencyController currencyController = Get.find();
                    currencyController.addCurrencies(
                        addCurrencyWidgetController.selectedCurrency.value,
                        addCurrencyWidgetController.currencyValue.value);

                    Get.back(closeOverlays: true);
                  },
                  child: Text('Add'))
            ]),
      );
    }
  }
}
