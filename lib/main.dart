import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project/request.dart';
import 'package:flutter_project/tablespage.dart';
import 'package:flutter_project/timelinepage.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],

        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      // home: TablesPage(title: 'EduSum'),
      initialRoute: '/tables',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(title: "Summarisation"),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/tables': (context) => TablesPage(title: "Tabulate"),
        '/timelines': (context) => TimelinePage(title: "Timelines"),
      },
    );
  }
}



