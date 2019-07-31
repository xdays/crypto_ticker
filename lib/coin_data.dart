import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const api = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future getCoinPrice(String currency) async {
    Map<String, String> coinPrices = {};
    for (String coin in cryptoList) {
      var url = '$api/$coin$currency';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        coinPrices[coin] = jsonDecode(data)['last'].toString();
      } else {
        print(response.statusCode);
      }
    }
    return coinPrices;
  }
}
