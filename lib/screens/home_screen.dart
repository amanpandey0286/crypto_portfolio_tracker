import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_tracker/add_currency_widget.dart';
import 'package:portfolio_tracker/controllers/currency_controller.dart';

class HomeScreen extends StatelessWidget {
  CurrencyController currencyController = Get.find();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // this is to avoid bottom Overflow because of keyboard.
      appBar: AppBar(
        title: Container(
          height: 30.0,
          width: 30.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: const Center(child: Text('A')),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(AddCurrencyWidget());
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "\$",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text:
                          "${currencyController.getPortfolioValue().toStringAsFixed(2)}\n",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(text: "Portfolio value\n")
                  ],
                ),
              ),
              SizedBox(
                height: 500.0,
                child: ListView.builder(
                  itemCount: currencyController.trackedCurrencies.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        currencyController.trackedCurrencies[index].name!,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(
                        'USD : ' +
                            currencyController.trackedCurrencies[index].amount!
                                .toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        currencyController.trackedCurrencies[index].amount
                            .toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
