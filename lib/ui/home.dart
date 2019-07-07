import 'package:led_client/src/json_parse.dart' as models;
import 'package:led_client/src/state.dart' as models;
import 'package:led_client/src/state_led.dart' as models;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_button/progress_button.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();
  static final int _row = 5;
  static final int _col = 5;
//  static final _ip = 'http://192.168.0.175:8000/';
  static final _ip = 'http://172.16.243.16:8000/';
  String _curState = 'default';
  int _curLed = 0;
  int _red = 0;
  int _green = 0;
  int _blue = 0;
  Color _curColor = Color.fromARGB(255, 0, 0, 0);
  List<Widget> _rowWid;
  ButtonState _submitLebButton = ButtonState.normal;
  ButtonState _submiNewState = ButtonState.normal;
  TextEditingController _newState = TextEditingController();
  List<models.StateLed> _stateLeds;
//  List<models.StateLed> _stateLeds =
//      List<models.StateLed>.generate(_row * _col, (i) {
//    return models.StateLed((b) {
//      b.state = 'default';
//      b.led = -1;
//      b.r = 0;
//      b.g = 0;
//      b.b = 0;
//    });
//  });

  @override
  void initState() {
    super.initState();
    _getStateLeds(_curState);
  }

  void _showSnackBar(String value) {
    FocusScope.of(context).requestFocus(FocusNode());
    _homeKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showStates({bool canDismiss: true}) async {
    final res = await http.get("${_ip}led/state_list/");
    if (res.statusCode != 200) {
      _showSnackBar("联网错误");
    } else {
      List<models.State> states = models.parseStateList(utf8.decode(res.bodyBytes));
      List<ButtonState> buttonStates =
          List<ButtonState>.generate(states.length, (_) => ButtonState.normal);
      showDialog(
          context: context,
          barrierDismissible: canDismiss,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white.withOpacity(0.88),
              child: Container(
                width: 500,
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  shrinkWrap: true,
                  children: List<Widget>.generate(states.length, (i) {
                    return Container(
                      padding: EdgeInsets.all(5.0),
                      child: ProgressButton(
                        child: Text(states[i].name),
                        buttonState: buttonStates[i],
                        onPressed: () async {
                          setState(() {
                            buttonStates[i] = ButtonState.inProgress;
                          });
                          await _getStateLeds(states[i].name);
                          setState(() {
                            buttonStates[i] = ButtonState.normal;
                            _buildLedMatrix(context);
                            _curState = states[i].name;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
                ),
              ),
            );
          });
    }
  }

  Future<void> _getStateLeds(String name) async {
    final res =
        await http.post("${_ip}led/stateLed_list/", body: {"name":name});
    if (res.statusCode != 200) {
      _showSnackBar("联网错误");
    } else {
      setState(() {
        _stateLeds = models.parseStateLedList(res.body);
      });
    }
  }

  //TODO refactor: only redraw the colors
  void _buildLedMatrix(BuildContext context) {
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
        colWid[c] = _buildLed(
            context,
            Color.fromARGB(
                255, _stateLeds[no].r, _stateLeds[no].g, _stateLeds[no].b),
            no);
      }
      rowWid[i] = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: colWid,
      );
    }
    _rowWid = rowWid;
  }

  @override
  Widget build(BuildContext context) {
    if (_stateLeds == null) {
      return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Text("正在加载"),
              CircularProgressIndicator(),
            ],
          ),
        ),
        appBar: AppBar(
          leading: SizedBox(
            width: 5,
          ),
          title: Text('请稍后'),
        ),
      );
    }
    _buildLedMatrix(context);
    return Scaffold(
      key: _homeKey,
      drawer: Drawer(
          child: ListView(
        shrinkWrap: true,
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _colorPrefab(context, Colors.green),
              _colorPrefab(context, Colors.red),
              _colorPrefab(context, Colors.blue),
              _colorPrefab(context, Colors.white),
              _colorPrefab(context, Colors.black),
              _colorPrefab(context, Colors.yellow),
              _colorPrefab(context, Colors.deepOrange),
              _colorPrefab(context, Colors.cyan),
              _colorPrefab(context, Colors.purple),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Icon(
                Icons.brightness_high,
                size: 60.0,
                color: _curColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: ProgressButton(
                buttonState: _submitLebButton,
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _submitLebButton = ButtonState.inProgress;
                  });
                  final body =
                      models.serialStateLed(_stateLeds[_curLed].rebuild((b) {
                    b.r = _red;
                    b.g = _green;
                    b.b = _blue;
                  }));
                  final res = await http.post("${_ip}led/light/", body: body);
                  if (res.statusCode != 202) {
                    setState(() {
                      _submitLebButton = ButtonState.error;
                    });
                    _showSnackBar("网络错误");
                  } else {
                    setState(() {
                      _submitLebButton = ButtonState.normal;
                      _stateLeds[_curLed] = _stateLeds[_curLed].rebuild((b) {
                        b.r = _red;
                        b.g = _green;
                        b.b = _blue;
                      });
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      )),
      appBar: AppBar(
        leading: SizedBox(
          width: 5,
        ),
        title: Text('LED控制-$_curState'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _rowWid,
      ),
      //TODO replace with progress button
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            width: 500,
                            height: 200,
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TextField(
                                  textAlign: TextAlign.center,
                                  controller: _newState,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "新名字",
                                  ),
                                ),
                                ProgressButton(
                                  child: Text(
                                    "提交",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  buttonState: _submiNewState,
                                  onPressed: () async {
                                    setState(() {
                                      _submiNewState = ButtonState.inProgress;
                                    });
                                    Map<String, String> body = {
                                      "name": _newState.text
                                    };
                                    final res = await http.post(
                                        "${_ip}led/save_state/",
                                        body: body);
                                    setState(() {
                                      _submiNewState = ButtonState.normal;
                                    });
                                    if (res.statusCode != 202) {
                                      _showSnackBar("网络错误");
                                    } else {
                                      _showSnackBar("保存成功");
                                      setState(() {
                                        _curState = _newState.text;
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("另存为"),
              ),
              RaisedButton(
                onPressed: () async {
                  Map<String, String> body = {"name": _curState};
                  final res =
                      await http.post("${_ip}led/save_state/", body: body);
                  if (res.statusCode != 202) {
                    _showSnackBar("网络错误");
                  } else {
                    _showSnackBar("保存成功");
                  }
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("覆盖当前"),
              ),
              RaisedButton(
                onPressed: () async {
                  if (_curState == "default") {
                    _showSnackBar("无法删除默认");
                    return;
                  }
                  Map<String, String> body = {"name": _curState};
                  final res =
                      await http.post("${_ip}led/remove_state/", body: body);
                  if (res.statusCode != 204) {
                    _showSnackBar("网络错误");
                  } else {
                    _showSnackBar("删除成功");
                    _showStates(canDismiss: false);
                  }
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("删除当前"),
              ),
            ],
          ),
        ),
      ),
      //TODO progress button?
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _showStates();
          setState(() {});
        },
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  Widget _colorPrefab(BuildContext context, Color color) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(color: color),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _red = color.red;
            _blue = color.blue;
            _green = color.green;
            _curColor = color;
          });
        },
        color: color,
      ),
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
        onPressed: () {
          setState(() {
            _curLed = key;
            _red = _stateLeds[key].r;
            _green = _stateLeds[key].g;
            _blue = _stateLeds[key].b;
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
