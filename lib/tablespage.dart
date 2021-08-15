import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/request.dart';
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
  var isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  getTexts(obj) {
    var result = [];
    for(var i = 0; i< obj["Text1"].length; i++) {
      result.add(Text(obj["Text1"][i]));
      result.add(Text(obj["Text2"][i]));
    }
    return result;
  }

  Future<void> _incrementCounter() async {

    // var url = Uri.parse('https://summarisation-api-project.azurewebsites.net/');
    // var url = Uri.parse('http://127.0.0.1:5000/hello');
    var url = Uri.parse('http://127.0.0.1:5000/summarise/yoyo');
    // Await the http get response, then decode the json-formatted response.
    // var response = await getData(url);
    // if (response.statusCode == 200) {
    //   var jsonResponse =
    //   convert.jsonDecode(response.body) as Map<String, dynamic>;
    //   var query = jsonResponse['query'];
    //   print('Query: $query.');
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }

    var  result;
    var responseString = await getResponse(url); //.then((value) => value);
    print("Response string");
    print(responseString.runtimeType);
    // print(value);

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List buildCols(){
    List cols = [
      {"title": 'Id', 'widthFactor': 0.05, 'key': 'id', 'editable': false},
      {"title": 'Text 1', 'widthFactor': 0.45, 'key': 't1'},
      {"title": 'Text 2', 'widthFactor': 0.45, 'key': 't2'},
    ];
    return cols;
  }

  List buildRows(json){
    List rows = [for (final k in json.keys)
      {"id": k.toString(),
      "t1": json[k]["Text1"],
      "t2": json[k]["Text2"]}];
    return rows;
  }

  Widget buildEditable(json){
    List rows = buildRows(json);
    List cols = buildCols();
    // List rows = buildRows(json);
    // List cols = buildCols();
    return
      Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  10, bottom: 10),
      height:600,
        child:Editable(
      columns: cols,
      rows: rows,
      zebraStripe: true,
      stripeColor1: Colors.white70,
      stripeColor2: Colors.grey,
      onRowSaved: (value) {
        print(value);
      },
      onSubmitted: (value) {
        print(value);
      },
      borderColor: Colors.blueGrey,
      tdStyle: TextStyle(fontWeight: FontWeight.bold),
      trHeight: 200,
      thStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      thAlignment: TextAlign.center,
      thVertAlignment: CrossAxisAlignment.end,
      thPaddingBottom: 3,
      showSaveIcon: true,
      saveIconColor: Colors.black,
      showCreateButton: true,
      tdAlignment: TextAlign.left,
      tdEditableMaxLines: 100, // don't limit and allow data to wrap
      tdPaddingTop: 20,
      tdPaddingBottom: 0,
      tdPaddingLeft: 10,
      tdPaddingRight: 8,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0))),
    ));
  }
  Widget buildTable(json){
    return Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  10, bottom: 10),
        child:

    Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FlexColumnWidth(1),// fixed to 100 width
          1: FlexColumnWidth(15),
          2: FlexColumnWidth(15),//fixed to 100 width
        },
        children: [
          TableRow(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Flexible(child:Text("Id",
                            textAlign: TextAlign.left)),
                          ),
                Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Flexible(child:Text("Text 1",
                              textAlign: TextAlign.left))),
                Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Flexible(child:Text("Text 2",
                              textAlign: TextAlign.left)))
            ],
          ),
            for (final k in json.keys)
              TableRow(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Flexible(child: Text(k.toString()))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Flexible(child:Text(json[k]["Text1"]))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Flexible(child:Text(json[k]["Text2"]))),
                ]
              ),
                // )
            ])
    );
  }
  void tabulate(json) {
    setState(() {
      _table_data = buildEditable(json);
          // buildTable(json);
    });

  }
  @override
  Widget build(BuildContext context) {
    final text1controller = TextEditingController();
    final text2controller = TextEditingController();
    final numcontroller = TextEditingController();

    setState(() {
      text1controller.text = "The Lok Sabha is elected for a term of five years. Its life can be extended for one year at a time during a national emergency. It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion. During the 13\" Lok Sabha, Bhartiya Janata Party lost a no~confidence motion by one vote and had to resign.  The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545.  Election to the Lok Sabha is by universal adult franchise. Every Indian citizen above the age; of 18 can vote for his/her representative in the Lok Sabha. The election is direct but by secret ballot, so that nobody is threatened or coerced into voting for a particular party or an individual. The Election Commission, an autonomous body elected by the President of India, organises, manages and oversees the entire process of election. What's More The provision for the Anglo-Indian community was included at the behest of the British Government to protect their nationals who had decided to stay back.";
      text2controller.text = "Term The Rajya Sabha is a permanent House. It cannot be dissolved. When the Lok Sabha is not in session or is dissolved, the permanent house still functions. However, each member of the Rajya Sabha enjoys a six-year tcrm. Every two years one-third of its members retire by rotation. The total strength of the Rajya Sabha cannot be more than 250 of which 238 are elected while 12 arc nominated by the President of India. Election to the Rajya Sabha is done indirectly. The members of the state legislature elect the state representatives to the Rajya Sabha in accordance with the system of proportional representation by means of a single transferable vote. The seats in the Rajya Sabha for each state and Union Territory arc fixed on the basis of its population. A constituency is an area demarcated for the purpose of election. In other words, it is an area or locality with a certain number of people who choose a person to represent them in the Lok Sabha. Each State and Union Territory is divided into territorial constituencies. The division is not based on area but on population. Let us consider Mizoram, Rajasthan and Uttar Pradesh. Uttar Pradesh, a large state with dense population, has 80 constituencies.";
      numcontroller.text = "3";
    });
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
                          Column(
                                children: [
                                  Container(
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
                                          left: 10.0, right: 10.0, top: 10, bottom: 10),
                                      color: Colors.white,
                                      child:
                                      TextFormField(
                                        controller: text1controller,
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
                          Container(
                            child:Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 10, bottom: 10),
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
                                        margin: const EdgeInsets.only(left: 10.0,
                                            right: 10.0,
                                            top: 10,
                                            bottom: 10),
                                        color: Colors.white,
                                        child:
                                        TextFormField(
                                          controller: text1controller,
                                          // minLines: 10,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3, color: Colors.blue),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            labelText: 'Text 2',
                                            contentPadding: EdgeInsets.all(15.0),
                                          ),

                                        )
                                    ),

                              ],
                            )
                          ),
                          Center(
                              child:
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10, bottom: 10),

                                child:
                                TextFormField(
                                  controller: numcontroller,
                                  // minLines: 10,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Number of segments',
                                    contentPadding: EdgeInsets.all(15.0),
                                  ),
                                ),
                              )),
                          Center(
                              child:
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 15, bottom: 10),

                                  child:
                                  isLoading
                                      ? Center(child: CircularProgressIndicator())
                                      :
                                  ElevatedButton(
                                    child: Text('Tabulate'),
                                    onPressed: () async {
                                      print("loading");
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var url = Uri.parse(
                                          'http://127.0.0.1:5000/tabulate/' +
                                              text1controller.text.replaceAll(
                                                  "\/", "%20or%20").replaceAll("\n",
                                                  "") + "/" + text2controller.text
                                              .replaceAll("\/", "%20or%20").replaceAll(
                                              "\n", "") + "/" + numcontroller.text);
                                      var jsonResponse = await getResponseJson(url);
                                      // var jsonResponse = {0: {"Text1": "The Lok Sabha is elected for a term of five years. Its life can be extended for one year at a time during a national emergency.", "Text2": "Term The Rajya Sabha is a permanent House. It cannot be dissolved. When the Lok Sabha is not in session or is dissolved, the permanent house still functions. However, each member of the Rajya Sabha enjoys a six-year tcrm. Every two years one-third of its members retire by rotation. The total strength of the Rajya Sabha cannot be more than 250 of which 238 are elected while 12 arc nominated by the President of India. Election to the Rajya Sabha is done indirectly. The members of the state legislature elect the state representatives to the Rajya Sabha in accordance with the system of proportional representation by means of a single transferable vote. The seats in the Rajya Sabha for each state and Union Territory arc fixed on the basis of its population."}, 1: {"Text1": "It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion. During the 13\" Lok Sabha, Bhartiya Janata Party lost a no~confidence motion by one vote and had to resign.  The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545.  Election to the Lok Sabha is by universal adult franchise.", "Text2": "A constituency is an area demarcated for the purpose of election. In other words, it is an area or locality with a certain number of people who choose a person to represent them in the Lok Sabha.}, 2: {Text1: Every Indian citizen above the age; of 18 can vote for his or her representative in the Lok Sabha. The election is direct but by secret ballot, so that nobody is threatened or coerced into voting for a particular party or an individual.", "Text2": "The division is not based on area but on population. Let us consider Mizoram, Rajasthan and Uttar Pradesh."}};
                                      tabulate(jsonResponse);
                                      // tabulate();

                                      setState(() {
                                        isLoading = false;
                                      });

                                      /////////////
                                      // setState(()
                                      // {
                                      //   print("Done");
                                      //   isLoading=false;
                                      //   print(jsonResponse);
                                      //   print(jsonResponse.runtimeType);
                                      //   _table_data = jsonResponse;
                                      // });
                                    },
                                  )
                              )),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: [
                                  Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                      ),
                                      child: Center(
                                          child: Text(
                                            "Table",
                                            textAlign: TextAlign.center,
                                          ))
                                  ),

                                  Container(
                                    // height:100,
                                        margin: const EdgeInsets.only(left: 10.0,
                                            right: 10.0,
                                            top: 10,
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
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}