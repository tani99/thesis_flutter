import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/request.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:rich_editor/rich_editor.dart';


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
  switch(mode) {
    case TextMode.bold: return boldStyle;
    case TextMode.italic: return italicStyle;
    // case TextMode.underline: return underlineStyle;
    default: return normalStyle;
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



  final _textfieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  getSelectedText(controller){
    print(controller.text.substring(controller.selection.baseOffset,controller.selection.extentOffset));
  }

  void handleMenu(String value) {
    switch (value) {
      case 'Summarization':
        Navigator.pushNamed(context, '/');
        break;
      case 'Tabulate':
        Navigator.pushNamed(context, '/tables');
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
                  return {'Summarization', 'Tabulate'}.map((String choice) {
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
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
              child: Container(
                  child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex:2,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                        ),
                                        child:
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                            child:Text(
                                          "Enter text here",
                                          textAlign: TextAlign.center,
                                        ))
                                    ),
                                  IconButton(

                                  icon: Icon(LineIcons.bold),
                                  onPressed: () {
                                    print(summaryController.selection);
                                    var currentText = summaryController.text;
                                    var lowerIndex = summaryController.selection.baseOffset > summaryController.selection.extentOffset ? summaryController.selection.extentOffset: summaryController.selection.baseOffset;
                                    var higherIndex = summaryController.selection.baseOffset < summaryController.selection.extentOffset ? summaryController.selection.extentOffset: summaryController.selection.baseOffset;
                                    print(lowerIndex);
                                    print(higherIndex);

                                    var firstHalf = currentText.substring(0, lowerIndex);
                                    var highlighted = currentText.substring(lowerIndex, higherIndex);
                                    var secondHalf = currentText.substring(higherIndex, currentText.length);

                                    print(firstHalf);
                                    print(highlighted);
                                    print(secondHalf);

                                    setState(() {
                                      currentMode == TextMode.bold ? currentMode = TextMode.normal:
                                      currentMode = TextMode.bold;
                                    });
                                    },
                                ),

                            Expanded(child:
                                    Container(
                                        color: Colors.white,
                                        child:
                                        TextFormField(
                                          style: TextStyle().merge(getStyle(currentMode)),
                                          controller: myController,
                                          // minLines: 10,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Text',
                                            contentPadding: EdgeInsets.all(15.0),
                                          ),

                                        )
                                    )),
                                    Container(
                                        width: MediaQuery.of(context).size.width/3,

                                        // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  0, bottom: 20),
                                        child:

                                        isLoading ?  Center(child:CircularProgressIndicator()) :
                                        ElevatedButton(
                                          child: Text('Summarise'),
                                          onPressed: () async {
                                            // setState(() {
                                            //   isLoading=true;
                                            // });
                                            var url = Uri.parse('http://127.0.0.1:5000/summarise/' + myController.text);
                                            var response = await getResponse(url);
                                            summaryController.text = response;
                                            // setState(() {
                                            //   isLoading = false;
                                            // });
                                            },
                                          //     () async {
                                          //   print("loading");
                                          //   setState((){
                                          //     isLoading=true;
                                          //     summaryController.text = "Bull bull";
                                          //     print("setting state ??");
                                          //   });
                                          //   var url = Uri.parse('http://127.0.0.1:5000/summarise/' + myController.text);
                                          //   var response = await getResponse(url);
                                          //   print(response);
                                          //   print("1 ----------------- \n");
                                          //
                                          //   print("2 ----------------- \n");
                                          //   // getResponse(url).then((value)=> {
                                          //
                                          //   // // print("3 ----------------- \n" + value)
                                          //   // });
                                          //   setState(()
                                          //   {
                                          //     print("Done");
                                          //     isLoading=false;
                                          //     print(response);
                                          //     print(" ----------- here ----------- \n");
                                          //     _summary = response;
                                          //     summaryController.text = "THIS IS TEST TEXT";
                                          //     print(" ----------- state set ----------- \n");
                                          //   });
                                          //   summaryController.text = "THIS IS TEST TEXT";
                                          //   //   setState((){
                                          //   //   isLoading=false;
                                          //   //   })
                                          //   // });
                                          // },
                                        )
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex:3,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                        ),
                                        child:
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                            child:Text(
                                              "Summary",
                                              textAlign: TextAlign.center,
                                            ))
                                    ),
                                    Expanded(child:Container(
                                      color: Colors.white10,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  10, bottom: 10),
                                          child:

                                          CupertinoTextField(
                                            controller: summaryController,
                                            style: TextStyle().merge(getStyle(currentMode)),
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                              enableInteractiveSelection:true,
                                          )


                                          // TextField(
                                          //   autofocus: true,
                                          //   maxLines: null,
                                          //   backgroundCursorColor: Colors.amber,
                                          //   cursorColor: Colors.green,
                                          //   style: TextStyle().merge(getStyle(currentMode)),
                                          //   focusNode:  FocusNode(),
                                          //   controller: summaryController,
                                          //   enableInteractiveSelection: true,
                                          //     showSelectionHandles: true,
                                          // )
                                        // SelectableText(_summary,
                                        // toolbarOptions: ToolbarOptions(copy:true, cut:true, paste:true, selectAll: true),)
                                      ),
                                    )),
                                  ],
                                )),
                            Expanded(
                                flex:3,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,

                                  children: [
                                    Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                        ),
                                        child:
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                            child:Text(
                                              "Keywords",
                                              textAlign: TextAlign.center,
                                            ))
                                    ),

                                    Expanded(child:Container(
                                      // margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  15, bottom: 10),
                                      color: Colors.white,
                                      child: Container(margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  10, bottom: 10),
                                          child:Text("...")),
                                    )),

                                  ],
                                )),
                          ]
                      )
              )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              summaryController.text = "My Stringt";
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

// import 'package:flutter/widgets.dart';
//
// class Annotation extends Comparable<Annotation> {
//   Annotation({@required this.range, this.style});
//   final TextRange range;
//   final TextStyle style;
//
//   @override
//   int compareTo(Annotation other) {
//     return range.start.compareTo(other.range.start);
//   }
//
//   @override
//   String toString() {
//     return 'Annotation(range:$range, style:$style)';
//   }
// }
// //

// class AnnotatedEditableTextState extends EditableTextState {
//   @override
//   AnnotatedEditableText get widget => widget;
//
//   List<Annotation> getRanges() {
//     var source = widget.annotations;
//     source.sort();
//     var result = new List<Annotation>.filled(length:source.length);
//     Annotation prev = new Annotation(range: TextRange(start: 0, end:0));
//     for (var item in source) {
//       if (prev == null) {
//         // First item, check if we need one before it.
//         if (item.range.start > 0) {
//           result.add(new Annotation(
//             range: TextRange(start: 0, end: item.range.start),
//
// // class AnnotatedEditableText extends EditableText {
// //   AnnotatedEditableText({
// //     Key? key,
// //     required FocusNode focusNode,
// //     required TextEditingController controller,
// //     required TextStyle style,
// //     ValueChanged<String>? onChanged,
// //     ValueChanged<String>? onSubmitted,
// //     required Color cursorColor,
// //     Color? selectionColor,
// //     TextSelectionControls? selectionControls,
// //     required this.annotations,
// //   }) : super(
// //     focusNode: focusNode,
// //     controller: controller,
// //     cursorColor: cursorColor,
// //     style: style,
// //     keyboardType: TextInputType.text,
// //     autocorrect: true,
// //     autofocus: true,
// //     selectionColor: selectionColor,
// //     selectionControls: selectionControls,
// //     onChanged: onChanged,
// //     onSubmitted: onSubmitted,
// //     backgroundCursorColor: Colors.blue
// //   );
// //
// //   final List<Annotation> annotations;
// //
// //   @override
// //   AnnotatedEditableTextState createState() => new AnnotatedEditableTextState();
// // }         ));
//         }
//         result.add(item);
//         prev = item;
//         continue;
//       } else {
//         // Consequent item, check if there is a gap between.
//         if (prev.range.end > item.range.start) {
//           // Invalid ranges
//           throw new StateError(
//               'Invalid (intersecting) ranges for annotated field');
//         } else if (prev.range.end < item.range.start) {
//           result.add(Annotation(
//             range: TextRange(start: prev.range.end, end: item.range.start),
//           ));
//         }
//         // Also add current annotation
//         result.add(item);
//         prev = item;
//       }
//     }
//     // Also check for trailing range
//     final String text = textEditingValue.text;
//     if (result.last.range.end < text.length) {
//       result.add(Annotation(
//         range: TextRange(start: result.last.range.end, end: text.length),
//       ));
//     }
//     return result;
//   }
//
//   @override
//   TextSpan buildTextSpan() {
//     final String text = textEditingValue.text;
//
//     if (widget.annotations != null) {
//       var items = getRanges();
//       var children = <TextSpan>[];
//       for (var item in items) {
//         children.add(
//           TextSpan(style: item.style, text: item.range.textInside(text)),
//         );
//       }
//       return new TextSpan(style: widget.style, children: children);
//     }
//
//     return new TextSpan(style: widget.style, text: text);
//   }
// }