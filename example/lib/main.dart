import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ift_form/ift_form.dart';
import 'form_default.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ift-form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ift-form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  String resultJson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              DefaultForm(
                key: formKey,
                formExpression: '''
email        Email                email   > req,v-len(50)
userName    'User Name'           string  > req,len(2,35)
date        'Reg Date'    				date    >
''',
                onValueChanged: (Field field, dynamic value) {},
                initData: {'email': 'test@iflutter.cn'},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('check'),
                    onPressed: () {
                      formKey.currentState.validate();
                      final result = formKey.currentState.save();
                      setState(() {
                        resultJson = jsonEncode(result);
                      });
                    },
                  ),
                ],
              ),
              Visibility(
                visible: resultJson != null,
                child: Text(
                  'result:$resultJson',
                  style: TextStyle(color: Colors.green, fontSize: 21),
                ),
              ),
            ],
          ),
        ));
  }
}
