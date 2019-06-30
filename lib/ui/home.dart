import 'package:led_client/src/json_parse.dart' as models;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();
  final int _row = 5;
  final int _col = 5;
  int _curLed = 0;
  int _red = 0;
  int _green = 0;
  int _blue = 0;
  Color _curColor = Color.fromARGB(255, 0, 0, 0);
  List<List<int>> colors = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];

  Widget build(BuildContext context) {
    List<Widget> rowWid = List<Widget>(_row);
    for (var i = _row - 1; i >= 0; --i) {
      int r = _row - 1 - i;
      bool l2r = (r % 2 == 0);
      List<Widget> colWid = List<Widget>(_col);
      for (var c = 0; c < _col; ++c) {
        int no;
        if (l2r) {
          no = r * _row + c;
        } else {
          no = (r + 1) * _row - c - 1;
        }
        colWid[c] = _buildLed(context,
            Color.fromARGB(255, colors[no][0], colors[no][1], colors[no][2]), no);
      }
      rowWid[i] = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: colWid,
      );
    }
    return Scaffold(
      key: _homeKey,
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          Container(
            height: 80,
            child: DrawerHeader(
              child: Text("LED-$_curLed"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          Center(
              child: Column(
            children: <Widget>[
              Slider(
                value: _red.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double newValue) {
                  setState(() {
                    _red = newValue.round();
                    _curColor = _curColor.withRed(_red);
                  });
                },
              )
            ],
          )),
          Center(
              child: Column(
            children: <Widget>[
              Slider(
                value: _green.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.green,
                onChanged: (double newValue) {
                  setState(() {
                    _green = newValue.round();
                    _curColor = _curColor.withGreen(_green);
                  });
                },
              )
            ],
          )),
          Center(
              child: Column(
            children: <Widget>[
              Slider(
                value: _blue.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.blue,
                onChanged: (double newValue) {
                  setState(() {
                    _blue = newValue.round();
                    _curColor = _curColor.withBlue(_blue);
                  });
                },
              )
            ],
          )),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Icon(
                Icons.brightness_high,
                color: _curColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: (){
                setState(() {
                  colors[_curLed][0] = _red;
                  colors[_curLed][1] = _green;
                  colors[_curLed][2] = _blue;
                });
                Navigator.pop(context);
              },
              child: Text("提交"),
            ),
          ),
        ],
      )),
      appBar: AppBar(
        leading: SizedBox(
          width: 5,
        ),
        title: Text('LED控制-默认'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: rowWid,
//        List.generate(_row * _col, (i) {
//          int r = _row - 1 - (i / _row).floor();
//          int c = i % _col;
//          bool r2c = (r % 2 == 0);
//          int no;
//          if (r2c) {
//            no = r * _row + c;
//          } else {
//            no = (r + 1) * _row - c - 1;
//          }
//          print([r, c]);
//          return _buildLed(context, Colors.red);
//        }),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {});
//          _homeKey.currentState.openDrawer();
        },
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  Widget _buildLed(BuildContext context, Color color, int key) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(color: Colors.grey),
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 30,
        onPressed: (){
          setState(() {
            _curLed = key;
            _red = colors[key][0];
            _green = colors[key][1];
            _blue = colors[key][2];
            _curColor = Color.fromARGB(255, _red, _green, _blue);
          });
          _homeKey.currentState.openDrawer();
        },
        icon: Icon(
          Icons.brightness_high,
          color: color,
        ),
      ),
    );
  }
}
