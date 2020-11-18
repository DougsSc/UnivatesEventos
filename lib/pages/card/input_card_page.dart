import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minicurso/entitys/credit_card/credit_card.dart';
import 'package:minicurso/pages/card/input_formatters.dart';
import 'package:minicurso/pages/card/payment_card.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/widgets/button.dart';

import 'card_api.dart';
//import 'package:core_card_io/core_card_io.dart';

class InputCard extends StatefulWidget {
  bool isDebit;

  InputCard(this.isDebit);

  @override
  _InputCardState createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var _numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;
  bool _haveDigits = false;

  final _loadC = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.OTHERS;
    _numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text("Adicionar cartão")),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[Expanded(child: _cardNumber())]),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: _cardValidDate(), flex: 5),
                Flexible(child: Container(), flex: 1),
                Expanded(child: _cardCVV(), flex: 5),
              ],
            ),
            SizedBox(height: 32),
            Row(children: <Widget>[Expanded(child: _cardButton())]),
          ],
        ),
      ),
    );
  }

  _cardNumber() {
    return TextFormField(
      autofocus: true,
      controller: _numberController,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(19),
        CardNumberInputFormatter()
      ],
      onChanged: _onNumberCardChanged,
      keyboardType: TextInputType.number,
      validator: CardUtils.validateCardNum,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      onSaved: (String value) {
        _paymentCard.number = CardUtils.getCleanedNumber(value);
      },
      decoration: InputDecoration(
        prefixIcon: CardUtils.getCardIcon(_paymentCard.type),
        suffixIcon: _haveDigits
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: _onClickCleanNumber,
              )
            : IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _onClickCamera,
              ),
        labelText: "Número do cartão",
        contentPadding: EdgeInsets.all(0),
        hintText: "0000 0000 0000 0000",
        hintStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  _cardValidDate() {
    return TextFormField(
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        CardMonthInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      validator: CardUtils.validateDate,
      style: TextStyle(fontSize: 16, color: Colors.black),
      onSaved: (value) {
        List<int> expiryDate = CardUtils.getExpiryDate(value);
        _paymentCard.month = expiryDate[0];
        _paymentCard.year = expiryDate[1];
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: _onClickInfoValidDate,
        ),
        labelText: "Data de venc.",
        contentPadding: EdgeInsets.all(0),
        hintText: "MM/AA",
        hintStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  _cardCVV() {
    return TextFormField(
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      keyboardType: TextInputType.number,
      validator: CardUtils.validateCVV,
      style: TextStyle(fontSize: 16, color: Colors.black),
      onSaved: (value) => _paymentCard.cvv = int.parse(value),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: _onClickInfoCVV,
        ),
        labelText: "CVV",
        contentPadding: EdgeInsets.all(0),
        hintText: "1234",
        hintStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  _onClickInfoCVV() {}

  _onClickInfoValidDate() {}

  _onClickCamera() async {
    print("Camera");

//    Map<String, dynamic> details = await CoreCardIo.scanCard({
//      "requireExpiry": true,
//      "scanExpiry": true,
//      "requireCVV": false,
//      "requirePostalCode": true,
//      "restrictPostalCodeToNumericOnly": true,
//      "requireCardHolderName": true,
//      "scanInstructions": "Olá! Ajuste o cartão dentro do quadrado",
//    });
//
//    print(details);
  }

  _onClickCleanNumber() {
    _numberController.clear();
    _onNumberCardChanged(_numberController.text);
  }

  _onNumberCardChanged(String text) {
    if (text.length == 0) {
      setState(() => _haveDigits = false);
    } else {
      setState(() => _haveDigits = true);
    }
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(_numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() => this._paymentCard.type = cardType);
  }

  _cardButton() {
    return StreamBuilder<bool>(
      stream: _loadC.stream,
      initialData: false,
      builder: (context, snapshot) {
        return UniButton(
          "ADICIONAR",
          onPressed: _validateInputs,
          showProgress: snapshot.data,
        );
      }
    );
  }

  void _validateInputs() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() => _autoValidate = true);
      showSnackBar(_scaffoldKey, 'Por favor corrija os erros');
    } else {
      form.save();

      print(_paymentCard.toString());
      CreditCard card = _paymentCard.toCard();
      card.debit = widget.isDebit ? 1 : 0;

      _cardRegister(card);
    }
  }

  _cardRegister(CreditCard card) async {
    _loadC.add(true);

    try {
      ApiResponse response = await CardApi.add(card);

      if (response.ok) {
        Navigator.pop(context, response.result);
      } else {
        showError(context, response.result);
      }
    } catch (e) {
      print(e);
      showDefaultError(context);
    }


    _loadC.add(false);
  }

  @override
  void dispose() {
    _numberController.removeListener(_getCardTypeFrmNumber);
    _numberController.dispose();
    _loadC.close();
    super.dispose();
  }
}
