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
import 'package:timelines/timelines.dart';

// {"Text1":{"0":"Its life can be extended for one year at a time during a national emergency. During the 13th Lok Sabha, Bhartiya Janata Party lost a no-confidence motion by one vote and had to resign.","1":"The Lok Sabha is elected for a term of five years. It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion.","2":"The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545."},
// "Text2":{"0":"It cannot be dissolved. The total strength of the Rajya Sabha cannot be more than 250 \nof which 238 are elected while 12 arc nominated by the President of India.","1":"However, each member of the Rajya Sabha enjoys a six-year tcrm. Every \ntwo years one-third of its members retire by rotation.","2":"The Rajya Sabha is a permanent House. When the Lok Sabha is not in session or is \ndissolved, the permanent house still functions."}}


class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _counter = 0;
  var _table_data;
  var isLoading = false;
  var isEditting = [false];
  var toggleButtonSet = ToggleButtonsSet();
  var _json_data = null;
  var timelineControllers = [];

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

  jsonFromControllers(){
    var json = {};
    var i = 0;
    for (var pair in timelineControllers) {
      print("got a pair");
      json[i] = {"Date": pair[0].text, "Event": pair[1].text};
      i += 1;
    }
    return json;
  }

  Widget initialiseEventCards(date, event){
    print("controller added");
    var dateEdittingController = TextEditingController();
    dateEdittingController.text = date;
    var eventEdittingController = TextEditingController();
    eventEdittingController.text = event;
    setState(() {
      timelineControllers.add([dateEdittingController, eventEdittingController]);
    });

    print("building event card");
    print(isEditting[0]);
    // return Text("hello");
      return TimelineTile(
      oppositeContents: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isEditting[0] ?
        CupertinoTextField(
          controller: dateEdittingController,
          style: TextStyle(),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          enableInteractiveSelection: true,
        ) : Text(dateEdittingController.text)
      ),
      contents: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: isEditting[0] ?  CupertinoTextField(
    controller: eventEdittingController,
    style: TextStyle(),
    keyboardType: TextInputType.multiline,
    maxLines: null,
    enableInteractiveSelection: true,
        ): Text(eventEdittingController.text),
        )),
      node: TimelineNode(
        indicator: DotIndicator(),
        startConnector: SolidLineConnector(),
        endConnector: SolidLineConnector(),
      ),
    );
  }


  Widget initTable(json){
    timelineControllers = [];
    print("Got json here");
    print(json);
    return Container(
      // color:Colors.red,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  10, bottom: 10),
        child:
         Column(
             // mainAxisSize: MainAxisSize.min,
            children: [
              for (final k in json.keys)
                // print(json[k]["Event"])
                initialiseEventCards(json[k]["Date"], json[k]["Event"])
                // TimelineCard(json[k]["Date"], json[k]["Event"])

            ])
    );
  }
  void tabulate(json) {
    setState(() {
      _table_data = initTable(json);
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
                  margin: const EdgeInsets.only(
                  left: 10, right: 20, top: 20, bottom: 10),
                child: Row(
                                    children: [
                                    toggleButtonSet,
                                    Container(
                                        child:
                                        Flexible (
                                            child:
                                            TextFormField(
                                              controller: text1controller,
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
                                  ],
                                )),
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
                                        'http://127.0.0.1:5000/timeline/' +
                                            text1controller.text
                                                .replaceAll("\/", "%20or%20")
                                                .replaceAll("\n", "").replaceAll("\'", "'") + '/' + toggleButtonSet.state.currentRangeValue.toString() + '/' + toggleButtonSet.state.sum_bool[0].toString() + '/' + toggleButtonSet.state.simp_bool[0].toString()+ '/' + toggleButtonSet.state.stucture_bool[0].toString() + '/' + toggleButtonSet.state.include_bool[0].toString() + "/" + numcontroller.text);
                                    var jsonResponse = await getResponseJson(url);
                                    // var jsonResponse = {0: {"Text1": "The Lok Sabha is elected for a term of five years. Its life can be extended for one year at a time during a national emergency.", "Text2": "Term The Rajya Sabha is a permanent House. It cannot be dissolved. When the Lok Sabha is not in session or is dissolved, the permanent house still functions. However, each member of the Rajya Sabha enjoys a six-year tcrm. Every two years one-third of its members retire by rotation. The total strength of the Rajya Sabha cannot be more than 250 of which 238 are elected while 12 arc nominated by the President of India. Election to the Rajya Sabha is done indirectly. The members of the state legislature elect the state representatives to the Rajya Sabha in accordance with the system of proportional representation by means of a single transferable vote. The seats in the Rajya Sabha for each state and Union Territory arc fixed on the basis of its population."}, 1: {"Text1": "It can be dissolved earlier than its term by the President on the advice of the Prime Minister. It can be voted out of power by a debate and vote on a no-confidence motion. During the 13\" Lok Sabha, Bhartiya Janata Party lost a no~confidence motion by one vote and had to resign.  The House may have not more than 552 members; 530 elected from the states, 20 from Union Territories and not more than 2 members nominated from the Anglo-Indian Community. At present, the strength of the Lok Sabha is 545.  Election to the Lok Sabha is by universal adult franchise.", "Text2": "A constituency is an area demarcated for the purpose of election. In other words, it is an area or locality with a certain number of people who choose a person to represent them in the Lok Sabha.}, 2: {Text1: Every Indian citizen above the age; of 18 can vote for his or her representative in the Lok Sabha. The election is direct but by secret ballot, so that nobody is threatened or coerced into voting for a particular party or an individual.", "Text2": "The division is not based on area but on population. Let us consider Mizoram, Rajasthan and Uttar Pradesh."}};
                                    // var jsonResponse = {"0":{"Date":"March 1917, the  end of March","Event":"The Bolshevik Revolution in Russia  \u2018The First World Warhad adisastrouseffecton the  Russian economy. Agitations and anger against  the royal family seemed to grow unchecked. By  March 1917 the streets of Petrograd had hordes  of people demanding peace and bread. By the  end of March, the Czar had been abdicated  and the Soviets had taken over. But the true  revolution occurred when Lenin and his fellow  Bolsheviks took over power from the unpopular  provincial government. Lenin negotiated peace  with Germany and left the war arena.      Depiction of Bolshevik Revolution by an artist          The American Entry into the War    When the War broke out in Europe, the USA had decided to remain neutral as it felt it was  a European war which had nothing to do with it. The American President, Woodrow Wilson  had asked Americans to be \u2018impartial in thought as well as in action\u2019. But Germany in an  attempt to break the British power decided to use its navy to isolate Britain. The German  submarines began to attack all merchant ships that crossed the Atlantic."},"1":{"Date":"early 1917","Event":"   In early 1917, the German U-boats sank the Lusitania which had a number of Americans on  board. USA broke-off diplomatic relations with Germany, and when it intercepted a message from Germany urging Mexico to join the war and reclaim land that it had lost to America,  it decided to declare war on Germany."},"2":{"Date":"July 28, 1914, November 11, 1918","Event":"Fresh  enthusiastic American troops helped boost the morale of the Allies and push the war in  their favour.    THE EFFECTS AND CONSEQUENCES OF THE WAR    Military Casualties    The \u2018Great War\u2019, which began on July 28, 1914 and ended with the German armistice of  November 11, 1918, had resulted in a vast number of casualties and deaths and similarly vast  numbers of missing soldiers."}};
                                    tabulate(jsonResponse);

                                    setState(() {
                                      _json_data = jsonResponse;
                                      isLoading = false;
                                      // buildEditable(json);
                                      // buildTable(json);
                                    });
                                  },
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              child:(_table_data != null) ?
                                        _table_data : Center(child:Text("Your table will appear here!"))
                            ) ],

                        ),
                      ),
                    ],
                  )




              )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
            this.setState(() {
              isEditting[0] = !isEditting[0];
              _json_data = jsonFromControllers();
              _table_data = initTable(_json_data);
            });
            },
            tooltip: 'Switch edit mode',
            child: Icon(Icons.edit),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
class TimelineCard extends StatefulWidget{
  final String date;
  final String event;
  late TimelineCardState state;
  TimelineCard(this.date,this.event);

  @override
  State<StatefulWidget> createState() {
    this.state = new TimelineCardState(this.date, this.event);
    return state;
  }
}

class TimelineCardState extends State<TimelineCard>{

  final String date;
  final String event;

  var dateEdittingController = TextEditingController();
  var eventEdittingController = TextEditingController();

  var editMode;

  @override
  void initState() {
    super.initState();
    dateEdittingController.text = date;
    eventEdittingController.text = event;
    editMode = false;
  }
  TimelineCardState(this.date,this.event);

      @override
      Widget build(BuildContext context) {
        // return Text(date + event);
      return TimelineTile(
             oppositeContents: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: editMode?
                 CupertinoTextField(
                   controller: dateEdittingController,
                   style: TextStyle(),
                   keyboardType: TextInputType.multiline,
                   maxLines: null,
                   enableInteractiveSelection: true,
                 ) : Text(dateEdittingController.text)
             ),
             contents: Card(
                 child: Container(
                   padding: EdgeInsets.all(8.0),
                   child: editMode ?  CupertinoTextField(
                     controller: eventEdittingController,
                     style: TextStyle(),
                     keyboardType: TextInputType.multiline,
                     maxLines: null,
                     enableInteractiveSelection: true,
                   ): Text(eventEdittingController.text),
                 )),
             node: TimelineNode(
               indicator: DotIndicator(),
               startConnector: SolidLineConnector(),
               endConnector: SolidLineConnector(),
             ),
           );
      }
}


