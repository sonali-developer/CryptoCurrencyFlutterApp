import 'package:http/http.dart' as http;
import 'dart:convert';

const coinAPIBaseURL = "https://rest.coinapi.io/v1/exchangerate/";

const apiKey = "31A5BB58-C335-421A-A9F8-2CFC5D9DD9D4";

const BTCCrypto = "BTC";

const ETHCrypto = "ETH";

const XCrypto = "X";

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

class CoinData {
  Future getCoinData(String currencyType) async {
    Map<String, String> cryptoPrices = {};

    for (String cryptoType in cryptoList) {
      String cryptoCoinURL =
          "$coinAPIBaseURL$cryptoType/$currencyType?apikey=$apiKey";
      print(cryptoCoinURL);

      http.Response coinResponse = await http.get(cryptoCoinURL);
      if (coinResponse.statusCode == 200) {
        print(coinResponse.statusCode);
        print(coinResponse.body);
        print(jsonDecode(coinResponse.body));
        String rate = jsonDecode(coinResponse.body)["rate"].toStringAsFixed(0);
        print(rate);
        cryptoPrices[cryptoType] = rate;
      } else {
        print(coinResponse.statusCode);
      }
    }

    return cryptoPrices;
  }
}
