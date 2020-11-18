import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minicurso/entitys/credit_card/credit_card.dart';
import 'package:minicurso/entitys/credit_card/credit_card_dao.dart';
import 'package:minicurso/pages/card/payment_card.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/utils/nav.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:minicurso/widgets/dividing_line.dart';

import 'card_api.dart';
import 'input_card_page.dart';

class ListCards extends StatefulWidget {
  @override
  _ListCardsState createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  List<CreditCard> _cards = [];

  final _cardsController = StreamController<List<CreditCard>>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text("Cartões")),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Divider(),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              child: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: _onClickSelectType,
            title: Text('Adicionar Cartão'),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<List<CreditCard>>(
                stream: _cardsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Container();
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  _cards = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cards.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _cardItem(_cards[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _cardItem(CreditCard card) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CardUtils.getCardIcon(CardUtils.getCardType(card.flag)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _onClickDeleteCard(card),
          ),
//          onTap: () => _onClickCardSelect(card),
          title: Text('${card.number}'),
          subtitle: Text(
            'Cartão de ${card.debit == 1 ? 'débito' : 'crédito'}',
          ),
        ),
        Divider(),
      ],
    );
  }

  _onClickSelectType() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 50,
                  margin: EdgeInsets.only(bottom: 8),
                  child: DividingLine(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.credit_card, size: 30),
                  title: Text('Cartão de Crédito'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _onClickAddCard(false),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.credit_card, size: 30),
                  title: Text('Cartão de Débito'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _onClickAddCard(true),
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  _loadCards() async {
    try {
      ApiResponse response = await CardApi.list();

      if (response.ok) {
        List<CreditCard> cards = response.result;

       final dao = CardDAO();
       cards.forEach(dao.save);
       // cards.forEach((element) { dao.save(element); });

        // List<CreditCard> cards = await dao.findAll();

        if (cards != null) _cardsController.add(cards);
      } else {
        if (response.result is ApiError) showError(context, response.result);
      }
    } catch (e) {
      print(e);
      _cardsController.addError(e);
    }
  }

  _onClickAddCard(bool isDebit) async {
    Navigator.pop(context);

    List<CreditCard> cards = await push(context, InputCard(isDebit));
    if (cards != null) {
      _cardsController.add(cards);
      showSnackBar(_scaffoldKey, 'Cartão adicionado com sucesso!');
    }
  }

  _onClickDeleteCard(CreditCard card) {
    showBottomQuestion(
      context,
      'Remover cartão',
      'Você deseja remover o cartão ${card.numberCard()}?',
      UniButton('Remover', onPressed: () => _deleteCard(card)),
    );
  }

  _deleteCard(card) async {
    Navigator.pop(context);

    showLoadingSnackBar(_scaffoldKey, 'Removendo cartão...');

    try {
      ApiResponse response = await CardApi.delete(card);

      if (_scaffoldKey.currentState.context != null) {
        _scaffoldKey.currentState.hideCurrentSnackBar();

        if (response.ok) {
          List<CreditCard> cards = response.result;
          if (cards != null) _cardsController.add(cards);

          showSnackBar(_scaffoldKey, 'Cartão removido com sucesso!');
        } else {
          showError(context, response.result);
        }
      }
    } catch (e) {
      print(e);
      if (context != null) showDefaultError(context);
    }
  }

  @override
  void dispose() {
    _cardsController.close();
    super.dispose();
  }
}
