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

  final _textfieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
          child: Column(
                children: [
                Expanded(
                child: ListView(
                children: [
                    Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Enter text here",
                              textAlign: TextAlign.center,
                            ))),
                    Container(
                      height:350,
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 10),
                        color: Colors.white,
                        child: Expanded (
                          child:
                        TextFormField(
                          controller: myController,
                          // minLines: 10,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Text 1',
                            contentPadding: EdgeInsets.all(15.0),
                          ),
                        ))),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,

                        // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top:  0, bottom: 20),
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                child: Text('Summarise'),
                                onPressed: () async {
                                  setState(() {
                                    isLoading=true;
                                  });
                                  var url = Uri.parse(
                                      'http://127.0.0.1:5000/summarise/' +
                                          myController.text
                                              .replaceAll("\/", "%20or%20")
                                              .replaceAll("\n", ""));
                                  var response = await getResponse(url);
                                  summaryController.text = response;
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
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
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Summary",
                              textAlign: TextAlign.center,
                            ))),
                    Container(
                      height:400,
                      color: Colors.white10,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: CupertinoTextField(
                            controller: summaryController,
                            style: TextStyle().merge(getStyle(currentMode)),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            enableInteractiveSelection: true,
                          )
                          ),
                    )])),

           Container(
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Keywords",
                              textAlign: TextAlign.center,
                            ))),
                    Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 10.0, top:  15, bottom: 10),
                      color: Colors.white,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: Text("...")),
                    ),
                  ])),

          ])
        )]
    )
    )
    )
    );
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

class Bullet extends Text {
  const Bullet(
    String data, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
  }) : super(
          '• $data',
          key: key,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        );
}
