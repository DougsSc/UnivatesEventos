import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minicurso/entitys/event.dart';
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/pages/profile/profile_api.dart';
import 'package:minicurso/pages/ticket/qr_expanded.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/utils/currency.dart';
import 'package:minicurso/utils/helper.dart';
import 'package:minicurso/utils/nav.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/widgets/label.dart';

import 'drawer_list.dart';
import 'events_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _eventsController = StreamController<List<Event>>();

  @override
  void initState() {
    super.initState();
    _updateUser();
    _listEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Eventos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _body(),
      drawer: DrawerList(() => setState(() {})),
    );
  }

  _body() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<List<Event>>(
          stream: _eventsController.stream,
          builder: _listBuilder,
        ),
      ),
    );
  }

  Widget _listBuilder(context, snapshot) {
    if (snapshot.hasError) return Container();
    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

    List<Event> tickets = snapshot.data;
    //if (tickets.isEmpty) return Container();
    final events = tickets.toList();

    return RefreshIndicator(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              _bodyItem(event),
//                Container(
//                  height: 40,
//                  margin: EdgeInsets.only(left: 4),
//                  child: VerticalDivider(color: Colors.black),
//                ),
            ],
          );
        },
      ),
      onRefresh: _listEvents,
      backgroundColor: Colors.white,
    );
  }

  _bodyItem(Event event) {
    return InkWell(
      onTap: _onClickItem,
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            child: Column(
              children: <Widget>[
                Text(
                  'Referência:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
                UniLabel('${event.id}'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                UniLabel(event.title, fontSize: 14),
                UniLabel(event.description, fontSize: 12),
                SizedBox(height: 8),
                Text(
                  'Data: ${formatDate(event.date)}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            child: Column(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: Colors.black,
                ),
                SizedBox(height: 8)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateUser() async {
    try {
      ApiResponse response = await ProfileApi.data();

      if (response.ok) {
        User cliente = response.result;
        if (cliente != null) {
          session.user = cliente;
          session.user.save();
          setState(() {});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listEvents() async {
    try {
      ApiResponse response = await EventsApi.list();

      if (response.ok) {
        List<Event> trips = response.result;
        if (trips != null) _eventsController.add(trips);
      } else {
        showError(context, response.result);
        _eventsController.addError(response.result);
      }
    } catch (e) {
      print(e);
      _eventsController.addError(e);
    }
  }

  void _onClickItem() {
    push(context, QrExpanded('zOkhH9fq4jQp8xB7Y3i9uk2RIo8Pw9OI'));
  }
}
