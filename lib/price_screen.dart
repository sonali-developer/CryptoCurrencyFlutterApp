import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";

  CoinData coinData = CoinData();

  String priceText = '1 BTC = ? USD';

  String cryptoType = "";

  DropdownButton getDropdownButton() {
    List<DropdownMenuItem<String>> currenciesType = [];

    for (String currencytype in currenciesList) {
      DropdownMenuItem<String> dropDownMenuItem = DropdownMenuItem(
        child: Text(currencytype),
        value: currencytype,
      );

      currenciesType.add(dropDownMenuItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: currenciesType,
        onChanged: (value) {
          setState(() {
            print(value);
            selectedCurrency = value;
            getData();
          });
        });
  }

  CupertinoPicker getiOSPicker() {
    List<Widget> currenciesType = [];

    for (String currencytype in currenciesList) {
      Widget pickerMenuItem = Text(
        currencytype,
      );
      currenciesType.add(pickerMenuItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedItemIndex) async {
        setState(() {
          print(selectedItemIndex);
          selectedCurrency = currenciesList[selectedItemIndex];
          getData();
        });
      },
      children: currenciesType,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<Widget> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? "?" : coinValues[crypto],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
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
            makeCards(),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getiOSPicker() : getDropdownButton(),
            ),
          ],
        ));
  }
}
