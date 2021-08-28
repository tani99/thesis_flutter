import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/request.dart';
import 'package:flutter_project/toggle_buttons_set.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'dart:convert' show utf8;

// {"Text1":{"0":"Its life can be extended for one year at a time during a national emergency. During the 13th Lok Sabha, Bhartiya Janata Party lost a no-confidence motion by one vote and had to resign.","1":"The Lok Sabha is elected for a term of five years. It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion.","2":"The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545."},
// "Text2":{"0":"It cannot be dissolved. The total strength of the Rajya Sabha cannot be more than 250 \nof which 238 are elected while 12 arc nominated by the President of India.","1":"However, each member of the Rajya Sabha enjoys a six-year tcrm. Every \ntwo years one-third of its members retire by rotation.","2":"The Rajya Sabha is a permanent House. When the Lok Sabha is not in session or is \ndissolved, the permanent house still functions."}}


class TablesPage extends StatefulWidget {
  TablesPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TablesPageState createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  int _counter = 0;
  var _table_data;
  var isEditting = false;
  var isLoading = false;
  var toggleButtonSet =  ToggleButtonsSet();
  var _json_data = {};
  var tableControllers = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List> words_from_text(text) async {
    var url = Uri.parse(
        'http://127.0.0.1:5000/tokenize/' +
            text
                .replaceAll("\/", "%20or%20")
                .replaceAll("\n", ""));
    var responseJson = await getResponseJson(url);
    return responseJson["words"];

  }

  Future<List<dynamic>> keywords_from_text(text) async {
    var url_key = Uri.parse(
        'http://127.0.0.1:5000/keywords/' +
            text
                .replaceAll("\/", "%20or%20")
                .replaceAll("\n", ""));
    var responseJson_keywords = await getResponseJson(url_key);
    return responseJson_keywords["keywords"];
  }

  Widget table(json) {
    tableControllers = [];
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  10, bottom: 10),
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Id',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Text 1',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Text 2',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows:  data(json),
      )
    );
  }

  List<DataRow> data(json) {
    return [for (final k in json.keys)
        row(k, json[k]["Text1"], json[k]["Text2"])
        ];

  }

  DataRow row(id, text1, text2){
    var idController = TextEditingController();
    var text1Controller = TextEditingController();
    var text2Controller = TextEditingController();

    var text1_text = text1["text"];
    var text1_words = text1["words"];
    var text1_keywords = text1["keywords"];

    var text2_text = text2["text"];
    var text2_words = text2["words"];
    var text2_keywords = text2["keywords"];

    print("test");
    print(id);
    print(text1);
    print(text2);
    idController.text = id.toString();
    text1Controller.text = text1_text;
    text2Controller.text = text2_text;

    setState(() {
      tableControllers.add([idController, text1Controller, text2Controller]);
    });

    return DataRow(
      cells: <DataCell>[
        DataCell(Container(
            // margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  20, bottom: 20),
    width: 100,child:
        isEditting ?
        TextFormField(
          controller: idController,
          // minLines: 10,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 3, color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            // labelText: 'Text 1',
            contentPadding: EdgeInsets.all(15.0),
          ),
        )

            : Text(idController.text)

        )),
        DataCell(Container(
            // margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  20, bottom: 20),
    width: 450,child:
        isEditting ?
    TextFormField(
    controller: text1Controller,
    // minLines: 10,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    decoration: InputDecoration(
    border: OutlineInputBorder(
    borderSide: BorderSide(
    width: 3, color: Colors.blue),
    borderRadius: BorderRadius.circular(15),
    ),
    // labelText: 'Text 1',
    contentPadding: EdgeInsets.all(15.0),
    ),
    )

        : get_spans(text1_words, text1_keywords)
        )),
        DataCell(
            Container(
            // margin: const EdgeInsets.only(left: 0.0, right: 10.0, top:  0, bottom: 0),
    width: 450,child:
        isEditting ?
    TextFormField(
    controller: text2Controller,
    // minLines: 10,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    decoration: InputDecoration(
    border: OutlineInputBorder(
    borderSide: BorderSide(
    width: 3, color: Colors.blue),
    borderRadius: BorderRadius.circular(15),
    ),
    // labelText: 'Text 1',
    contentPadding: EdgeInsets.all(15.0),
    ),
    )

        :get_spans(text2_words, text2_keywords)
        )),
      ],
    );
  }
  Widget buildEditable(json){
    return table(json);
  }

  jsonFromControllers() async {
    var json = {};
    var i = 0;
    for (var pair in tableControllers) {
      print("got a triplet");
      var url = Uri.parse(
          'http://127.0.0.1:5000/tokenize/' +
              pair[1].text
                  .replaceAll("\/", "%20or%20")
                  .replaceAll("\n", ""));
      var responseJson = await getResponseJson(url);

      var url_key = Uri.parse(
          'http://127.0.0.1:5000/keywords/' +
              pair[1].text
                  .replaceAll("\/", "%20or%20")
                  .replaceAll("\n", ""));
      var responseJson_keywords = await getResponseJson(url_key);

      json[i] = {};
      json[i]["Text1"] = {};
      json[i]["Text1"]["text"] = pair[1].text;
      json[i]["Text1"]["words"] = responseJson["words"];
      json[i]["Text1"]["keywords"] =responseJson_keywords["keywords"];


      url = Uri.parse(
          'http://127.0.0.1:5000/tokenize/' +
              pair[2].text
                  .replaceAll("\/", "%20or%20")
                  .replaceAll("\n", ""));
       responseJson = await getResponseJson(url);

       url_key = Uri.parse(
          'http://127.0.0.1:5000/keywords/' +
              pair[2].text
                  .replaceAll("\/", "%20or%20")
                  .replaceAll("\n", ""));
       responseJson_keywords = await getResponseJson(url_key);
      json[i]["Text2"] = {};
      json[i]["Text2"]["text"] = pair[2].text;
      json[i]["Text2"]["words"] = responseJson["words"];
      json[i]["Text2"]["keywords"] =responseJson_keywords["keywords"];

      // json[pair[0].text] = {"Text1": pair[1].text, "Text2": pair[2].text};
      i += 1;
    }
    print("json from controllers");
    print(json);
    return json;
  }

  void tabulate(json) {
    setState(() {
      _table_data = buildEditable(json);
      print("has the table data been updated? ");
      print(_table_data);
          // buildTable(json);
    });

  }


  Widget get_spans(words, keywords) {
    print("enters");
    print("WORDS ARE: " + words.toString());
    print("KEYS ARE: " + keywords.toString());
    // var words = words_from_text(text);
    // var keywords = keywords_from_text(text);
    return RichText(
        text: new TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan> [for (final word in words)
              (keywords.contains(word.toLowerCase())) ?
              TextSpan(text: word + " ", style:TextStyle(fontWeight: FontWeight.bold)):
              TextSpan(text: word + " "),
            ]
        ));
  }

  @override
  Widget build(BuildContext context) {
    final input1controller = TextEditingController();
    final input2controller = TextEditingController();
    final numcontroller = TextEditingController();

    // setState(() {
    //   input1controller.text = "The Lok Sabha is elected for a term of five years. Its life can be extended for one year at a time during a national emergency. It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion. During the 13\" Lok Sabha, Bhartiya Janata Party lost a no~confidence motion by one vote and had to resign.  The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545.  Election to the Lok Sabha is by universal adult franchise. Every Indian citizen above the age; of 18 can vote for his/her representative in the Lok Sabha. The election is direct but by secret ballot, so that nobody is threatened or coerced into voting for a particular party or an individual. The Election Commission, an autonomous body elected by the President of India, organises, manages and oversees the entire process of election. What's More The provision for the Anglo-Indian community was included at the behest of the British Government to protect their nationals who had decided to stay back.";
    //   input2controller.text = "Term The Rajya Sabha is a permanent House. It cannot be dissolved. When the Lok Sabha is not in session or is dissolved, the permanent house still functions. However, each member of the Rajya Sabha enjoys a six-year tcrm. Every two years one-third of its members retire by rotation. The total strength of the Rajya Sabha cannot be more than 250 of which 238 are elected while 12 arc nominated by the President of India. Election to the Rajya Sabha is done indirectly. The members of the state legislature elect the state representatives to the Rajya Sabha in accordance with the system of proportional representation by means of a single transferable vote. The seats in the Rajya Sabha for each state and Union Territory arc fixed on the basis of its population. A constituency is an area demarcated for the purpose of election. In other words, it is an area or locality with a certain number of people who choose a person to represent them in the Lok Sabha. Each State and Union Territory is divided into territorial constituencies. The division is not based on area but on population. Let us consider Mizoram, Rajasthan and Uttar Pradesh. Uttar Pradesh, a large state with dense population, has 80 constituencies.";
    //   numcontroller.text = "3";
    // });
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
          ),
          body:
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
              child: Container(
                child:Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            child:
                          Row(
                          children: [
                          toggleButtonSet,
                    Expanded(
                        child:Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 20, bottom: 10),
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                      ),
                                      child: Center(
                                          child: Text(
                                            "Text 1",
                                            textAlign: TextAlign.center,
                                          ))
                                  ),

                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 20, bottom: 20),
                                      color: Colors.white,
                                      child:
                                      TextFormField(
                                        controller: input1controller,
                                        // minLines: 10,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.blue),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          labelText: 'Text 1',
                                          contentPadding: EdgeInsets.all(15.0),
                                        ),
                                      )
                                  ),
                                ],
                              )),
                    Expanded(child: Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 20.0, right: 20.0, top: 20, bottom: 10),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                        ),
                                        child: Center(
                                            child: Text(
                                              "Text 2",
                                              textAlign: TextAlign.center,
                                            ))
                                    ),

                                    Container(
                                        margin: const EdgeInsets.only(left: 20.0,
                                            right: 20.0,
                                            top: 20,
                                            bottom: 20),
                                        // color: Colors.white,
                                        child:
                                        TextFormField(
                                          controller: input2controller,
                                          // minLines: 10,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 3,
                                                // color: Colors.blue
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            labelText: 'Text 2',
                                            contentPadding: EdgeInsets.all(15.0),
                                          ),

                                        )
                                    ),

                                  ],
                                ))

                          ])
                          ),

                          Center(
                              child:
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 10, bottom: 20),

                                child:
                                TextFormField(
                                  controller: numcontroller,
                                  // minLines: 10,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3,
                                          // color: Colors.blue
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Number of segments',
                                    contentPadding: EdgeInsets.all(15.0),
                                  ),
                                ),
                              )),

                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 10, bottom: 20),

                                  // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  0, bottom: 20),
                                  child: isLoading
                                      ? Center(child: CircularProgressIndicator())
                                      : ElevatedButton(
                                    child: Text('Generate'),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading=true;
                                      });

                                      var url = Uri.parse(
                                          'http://127.0.0.1:5000/tabulate/' +
                                              input1controller.text
                                                  .replaceAll("\/", "%20or%20")
                                                  .replaceAll("\n", "").replaceAll("\'", "'") + '/' + input2controller.text
                                              .replaceAll("\/", "%20or%20")
                                              .replaceAll("\n", "").replaceAll("\'", "'") + '/' + toggleButtonSet.state.currentRangeValue.toString() + '/' + toggleButtonSet.state.sum_bool[0].toString() + '/' + toggleButtonSet.state.simp_bool[0].toString()+ '/' + toggleButtonSet.state.stucture_bool[0].toString() + '/' + toggleButtonSet.state.include_bool[0].toString() + "/" + numcontroller.text);
                                      var jsonResponse = await getResponseJson(url);
                                      // var jsonResponse = {0: {"Text1": "The Lok Sabha is elected for a term of five years. Its life can be extended for one year at a time during a national emergency.", "Text2": "Term The Rajya Sabha is a permanent House. It cannot be dissolved. When the Lok Sabha is not in session or is dissolved, the permanent house still functions. However, each member of the Rajya Sabha enjoys a six-year tcrm. Every two years one-third of its members retire by rotation. The total strength of the Rajya Sabha cannot be more than 250 of which 238 are elected while 12 arc nominated by the President of India. Election to the Rajya Sabha is done indirectly. The members of the state legislature elect the state representatives to the Rajya Sabha in accordance with the system of proportional representation by means of a single transferable vote. The seats in the Rajya Sabha for each state and Union Territory arc fixed on the basis of its population."}, 1: {"Text1": "It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion. During the 13\" Lok Sabha, Bhartiya Janata Party lost a no~confidence motion by one vote and had to resign.  The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545.  Election to the Lok Sabha is by universal adult franchise.", "Text2": "A constituency is an area demarcated for the purpose of election. In other words, it is an area or locality with a certain number of people who choose a person to represent them in the Lok Sabha.}, 2: {Text1: Every Indian citizen above the age; of 18 can vote for his or her representative in the Lok Sabha. The election is direct but by secret ballot, so that nobody is threatened or coerced into voting for a particular party or an individual.", "Text2": "The division is not based on area but on population. Let us consider Mizoram, Rajasthan and Uttar Pradesh."}};
                                      tabulate(jsonResponse);
                                      this.setState(() {
                                        _table_data = buildEditable(jsonResponse);
                                        print("table updated with new data");
                                        print(_table_data);
                                        this.isLoading = false;
                                      });
                                    },
                                  )),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: [

                                  Container(
                                    // height:100,
                                        margin: const EdgeInsets.only(left: 10.0,
                                            right: 10.0,
                                            top: 0,
                                            bottom: 10),
                                        color: Colors.white,
                                        child: (_table_data != null) ?
                                        _table_data : Center(child:Text("Your table will appear here!"))
                                    ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var json_from_controllers = await jsonFromControllers();
              this.setState(()  {
                isEditting = !isEditting;
                print("issue hereee");
                _json_data = json_from_controllers;
                print("issue boo");
                _table_data = buildEditable(_json_data);
              });
            },
            tooltip: 'Switch edit mode',
            child: Icon(Icons.edit),
          ),// This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
