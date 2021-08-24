import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/request.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/toggle_buttons_set.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

enum TextMode {
  normal,
  bold,
  italic,
  underline,
  // link,  <- I'm not sure what you want to have happen with this one
}

const normalStyle = TextStyle();
const boldStyle = TextStyle(fontWeight: FontWeight.bold);
const italicStyle = TextStyle(fontStyle: FontStyle.italic);
// const underlineStyle = TextStyle(textDecoration: TextDecoration.underline);

// Helper method
TextStyle getStyle(TextMode mode) {
  switch (mode) {
    case TextMode.bold:
      return boldStyle;
    case TextMode.italic:
      return italicStyle;
    // case TextMode.underline: return underlineStyle;
    default:
      return normalStyle;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _summary = "";
  var isLoading = false;
  var currentMode = TextMode.normal;
  var myController = TextEditingController();
  var summaryController = TextEditingController();
  var percentController = TextEditingController();

  var isEditting = false;

  var _currentRangeValue = 80.0;
  var toggleButtonSet =  ToggleButtonsSet();


  // quill.QuillController
  // QuillController _controller = QuillController.basic();
  // QuillController quillController = QuillController.basic();
  // var controller = markdown
  var _focusNode = FocusNode();
  final _textfieldFocusNode = FocusNode();

  var isSelected = [false, false, false, false];
  var sum_bool = [false];
  var simp_bool = [false];
  var stucture_bool = [false];
  var include_bool = [false];
  // String? html = await keyEditor.currentState?.getHtml();
  // print(html);

  @override
  void initState() {
    super.initState();
    percentController.text = "0.8";
  }

  getSelectedText(controller) {
    print(controller.text.substring(
        controller.selection.baseOffset, controller.selection.extentOffset));
  }

  void handleMenu(String value) {
    switch (value) {
      case 'Summarization':
        Navigator.pushNamed(context, '/');
        break;
      case 'Tabulate':
        Navigator.pushNamed(context, '/tables');
        break;
      case 'Timelines':
        Navigator.pushNamed(context, '/timelines');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenu,
            itemBuilder: (BuildContext context) {
              return {'Summarization', 'Tabulate', 'Timelines'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child:Container(
           child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Flexible(
                child: ListView(
                children: [
                    Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 20, top: 20, bottom: 10),
                      child:
                    Row(
                      children: [
                        toggleButtonSet,
                        Container(
                            child:
                            Flexible (
                              child:
                            TextFormField(
                              controller: myController,
                              minLines: 13,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 3,
                                    // color: Colors.blue
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Enter text here',
                                contentPadding: EdgeInsets.all(15.0),
                              ),
                            )))
                      ]
                    )),
                  Container(
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),

                  ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10, bottom: 10),

                        width: MediaQuery.of(context).size.width / 3,

                        // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  0, bottom: 20),
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                child: Text('Generate'),
                                onPressed: () async {
                                  setState(() {
                                    isLoading=true;
                                  });
                                  print("Value of incldue frist half");
                                  // print(includeFirstHalf);
                                  var url = Uri.parse(
                                      'http://127.0.0.1:5000/summarise/' +
                                          myController.text
                                              .replaceAll("\/", "%20or%20")
                                              .replaceAll("\n", "") + '/' + toggleButtonSet.state.currentRangeValue.toString() + '/' + toggleButtonSet.state.sum_bool[0].toString() + '/' + toggleButtonSet.state.simp_bool[0].toString()+ '/' + toggleButtonSet.state.stucture_bool[0].toString() + '/' + toggleButtonSet.state.include_bool[0].toString());
                                  var response = await getResponse(url);
                                  summaryController.text = response.replaceAll("\-", "\u2022");
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              )),
             Container(
                 margin: const EdgeInsets.only(
                     left: 20.0, right: 20.0, top: 10, bottom: 10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        height: 35,
                        decoration: BoxDecoration(
                          // color: Colors.blueAccent,
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Summary",
                              textAlign: TextAlign.center,
                            ))),
                    Container(
                      height:300,
                      // color: Colors.white10,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: isEditting? CupertinoTextField(
                            controller: summaryController,
                            style: TextStyle().merge(getStyle(currentMode)),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            enableInteractiveSelection: true,
                          ): Text(summaryController.text)
                          ),
                    )])),
          ])
        )]
    )
    )
    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              this.setState(() {
                isEditting = !isEditting;
              });
            },
            tooltip: 'Switch edit mode',
            child: Icon(Icons.edit),
          ),
    ));
  }
}
