import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> coinPrices;
  bool isWaiting = false;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData(selectedCurrency);
        });
      },
      children: pickerItems,
    );
  }

  getData(currency) async {
    isWaiting = true;
    Map<String, String> prices = await CoinData().getCoinPrice(currency);
    isWaiting = false;
    setState(() {
      coinPrices = prices;
    });
  }

  List<CoinCard> coinList() {
    List<CoinCard> coins = [];
    for (String coin in cryptoList) {
      coins.add(CoinCard(
        coinName: coin,
        coinPrice: isWaiting ? '?' : coinPrices[coin],
        selectedCurrency: selectedCurrency,
      ));
    }
    return coins;
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: coinList(),
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  final String coinName;
  final String coinPrice;
  final String selectedCurrency;

  CoinCard({
    this.coinName,
    this.coinPrice,
    this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $coinName = ${coinPrice ?? '?'} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
