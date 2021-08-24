import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleButtonsSet extends StatefulWidget {

  late _ToggleButtonsSetState state;



  @override
  _ToggleButtonsSetState createState() {
    {
      this.state = _ToggleButtonsSetState();
      return state;
    }
  }
}

class _ToggleButtonsSetState extends State<ToggleButtonsSet> {
  var _sum_bool =  [false];
  var _simp_bool= [false];
  var _stucture_bool= [false];
  var _include_bool = [false];
  var _currentRangeValue = 80.0;

  get sum_bool =>  _sum_bool;
  get simp_bool => _simp_bool;
  get stucture_bool => _stucture_bool;
  get include_bool => _include_bool;
  get currentRangeValue => _currentRangeValue;
  @override
  Widget build(BuildContext context) {
    return Column(

      // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [                            Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child:
            Container(
                height: 35,
                child:
                ToggleButtons(

                  children: <Widget>[
                    Container(
                        width:100,
                        margin: const EdgeInsets.only(
                            left: 5, right: 5, top: 0, bottom: 0),
                        child: Center(child:Text("Summarise"))),
                  ],
                  // color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderWidth: 3,
                  textStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.blueGrey,
                  selectedColor: Colors.white,
                  // selectedBorderColor: Colors.blueAccent,

                  onPressed: (int index) {
                    setState(() {
                      _sum_bool[index] = !_sum_bool[index];
                    });
                  },
                  isSelected: _sum_bool,
                ))),
          Padding(
              padding: EdgeInsets.fromLTRB(5,5, 5, 5),
              child:
              Container(
                  height: 35,
                  child: ToggleButtons(
                    children: <Widget>[
                      Container(
                          width: 100,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 0, bottom: 0),
                          child:
                          Center(child:Text("Simplify"))),

                    ],
                    // color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // decoration: BoxDecoration(
                    //     color: Colors.white70,
                    //     borderRadius: BorderRadius.all(
                    //         Radius.circular(10)
                    //     )),
                    // borderColor: Colors.blueAccent,
                    borderWidth: 3,
                    textStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.blueGrey,
                    selectedColor: Colors.white,
                    // selectedBorderColor: Colors.blueAccent,

                    onPressed: (int index) {
                      setState(() {
                        _simp_bool[index] = !_simp_bool[index];
                      });
                    },
                    isSelected: _simp_bool,
                  ))),
          Padding(
              padding: EdgeInsets.fromLTRB(5,5, 5, 5),
              child:
              Container(
                  height: 35,
                  child:ToggleButtons(
                    children: <Widget>[
                      Container(
                          width:100,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 0, bottom: 0),
                          child:Center(child:Text("Bullet points"))),

                    ],
                    // color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // decoration: BoxDecoration(
                    //     color: Colors.white70,
                    //     borderRadius: BorderRadius.all(
                    //         Radius.circular(10)
                    //     )),
                    // borderColor: Colors.blueAccent,
                    borderWidth: 3,
                    textStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.blueGrey,
                    selectedColor: Colors.white,
                    // selectedBorderColor: Colors.blueAccent,

                    onPressed: (int index) {
                      setState(() {
                        _stucture_bool[index] = !_stucture_bool[index];
                      });
                    },
                    isSelected: _stucture_bool,
                  ))),
          Padding(
              padding: EdgeInsets.fromLTRB(5,5, 5, 5),
              child:
              Container(
                  height: 35,

                  child: ToggleButtons(
                    children: <Widget>[
                      Container(
                          width:100,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 0, bottom: 0),
                          child:Center(child:Text("Complete form"))),
                    ],
                    // color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // decoration: BoxDecoration(
                    //     color: Colors.white70,
                    //     borderRadius: BorderRadius.all(
                    //         Radius.circular(10)
                    //     )),
                    // borderColor: Colors.blueAccent,
                    borderWidth: 3,
                    textStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.blueGrey,
                    selectedColor: Colors.white,
                    // selectedBorderColor: Colors.blueAccent,

                    onPressed: (int index) {
                      setState(() {
                        _include_bool[index] = !_include_bool[index];
                      });
                    },
                    isSelected: _include_bool,
                  ))),
          Container(
              width: 100,
              margin: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 10),
              child: Center(child:Text("Percentage \nreduction"))),
          Container(
            // margin: const EdgeInsets.only(
            //     left: 10.0, right: 10.0, top: 10, bottom: 10),
              child:Slider(
                activeColor: Colors.blue,
                value: _currentRangeValue,
                label: "Value: ${_currentRangeValue.round().toString()} %",
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (double value) {
                  setState(() {
                    _currentRangeValue = value;
                  });
                },
              )),]);
  }
}
