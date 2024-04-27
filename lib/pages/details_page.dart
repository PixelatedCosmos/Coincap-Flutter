import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> coinCurrencies;

  const DetailsPage({super.key, required this.coinCurrencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _coinCurrenciesWidget(coinCurrencies),
      ),
    );
  }

  Widget _coinCurrenciesWidget(Map<String, dynamic> coinCurrencies) {
    return ListView.builder(
      itemCount: coinCurrencies.length,
      itemBuilder: (context, index) {
        String key = coinCurrencies.keys.elementAt(index);
        return ListTile(
          title: Text(
            "$key: ${coinCurrencies[key]}",
            style: const TextStyle(
              color: Color.fromRGBO(226, 223, 210, 1),
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}
