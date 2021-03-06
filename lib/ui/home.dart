import 'package:flutter/services.dart';
import 'package:led_client/src/model/config.dart';
import 'package:led_client/src/json_parse.dart' as models;
import 'package:led_client/src/model/state.dart' as models;
import 'package:led_client/src/model/state_led.dart' as models;
import 'package:led_client/src/model/config.dart' as models;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_button/progress_button.dart';
import 'dart:convert';
import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();
//  static final _ip = 'http://192.168.2.113:8000/';
  static final _ip = 'http://192.168.4.1:8000/';
  static final _ROW = 13;
  static final _COL = 13;
  //ToDo set row and col
  bool _startCheck = false;
  int _row = _ROW;
  int _col = _COL;
  String _default = '默认线路';
  String _curState = '默认线路';
  int _curLed = 0;
  Color _curColor = Color.fromARGB(255, 0, 0, 0);
  List<Widget> _rowWid;
  ButtonState _submitLebButton = ButtonState.normal;
  ButtonState _submiNewState = ButtonState.normal;
  Text _submitNewInfo = Text(
    "提交",
    style: TextStyle(color: Colors.white),
  );
  // new name
  TextEditingController _newState = TextEditingController();
  // set row & col
  TextEditingController _rowCon = TextEditingController();
  TextEditingController _colCon = TextEditingController();
//  List<models.StateLed> _stateLeds;
  List<models.StateLed> _stateLeds;

  @override
  void initState() {
    super.initState();
    _getConfig().then((config){
      _stateLeds = List<models.StateLed>.generate(_row * _col, (i) {
        return models.StateLed((b) {
          b.state = '默认线路';
          b.led = i;
          b.r = 0;
          b.b = 0;
          b.g = 0;
        });
      });
      _getStateLeds(_curState);
    });
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
                    return Dismissible(
                      background: Container(color: Colors.red),
                      confirmDismiss: (DismissDirection direction) async {
                        if (states[i].name == _default){
                          // can not delete default
                          return false;
                        }
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("再确认"),
                              content: const Text("确认删除?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("删除")
                                ),
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("取消"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async{
                        Map<String, String> body = {"name": states[i].name};
                        final res =
                            await http.post("${_ip}led/remove_state/", body: body);
                        if (res.statusCode != 204) {
                          _showSnackBar("网络错误");
                        } else {
                          _showSnackBar("删除成功");
                        }
                      },
                      key: Key(states[i].name),
                      child: ProgressButton(
                        child: Text(states[i].name),
                        buttonState: buttonStates[i],
                        onPressed: () async {
                          setState(() {
                            buttonStates[i] = ButtonState.inProgress;
                          });
                          await _getStateLeds(states[i].name);
                          List<Widget> content = _buildLedMatrix(context);
                          setState(() {
                            buttonStates[i] = ButtonState.normal;
                            _rowWid = content;
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
      List<models.StateLed> fetched = models.parseStateLedList(res.body);
      setState(() {
        if (fetched.length > _stateLeds.length){
          _stateLeds = fetched;
        } else {
          _stateLeds = List<models.StateLed>.generate(_stateLeds.length, (i) {
            return models.StateLed((b) {
              b.state = '默认线路';
              b.led = i;
              b.r = 0;
              b.b = 0;
              b.g = 0;
            });
          });
          _stateLeds.setRange(0, fetched.length, fetched);
        }
        print("_stateLed" + _stateLeds.length.toString());
        _startCheck = true;
//        _stateLeds = models.parseStateLedList(res.body);
      });
    }
  }

  Future<Config> _getConfig() async {
    Config config;
    final res = await http.get("${_ip}led/get_config/0");
    if (res.statusCode != 200) {
      _showSnackBar("联网错误");
    } else {
      config = models.parseConfig(res.body);
      _row = config.rowCount;
      _col = config.colCount;
    }
    return config;
  }

  //TODO refactor: only redraw the colors
  List<Widget> _buildLedMatrix(BuildContext context) {
    List<Widget> rowWid = List<Widget>(_row + 1);
    double width = (60 * _col).toDouble();
    rowWid[0] = Container(
      height: 50,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(left:55.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(_col, (i){
            return SizedBox(
                width: 30,
                child: Center(child: Text((i + 1).toString()))
            );
          }),
        ),
      ),
    );
    for (var i = _row - 1; i >= 0; --i) {
      int r = _row - 1 - i;
      bool l2r = (r % 2 == 0);
      List<Widget> colWid = List<Widget>(_col + 1);
      colWid[0] = SizedBox(
          width:30,
          child: Text((r + 1).toString())
      );
      for (var c = 0; c < _col; ++c) {
        int no;
        if (l2r) {
          no = r * _col + c;
        } else {
          no = (r + 1) * _col - c - 1;
        }
        colWid[c + 1] = _buildLed(
            context,
            Color.fromARGB(
                255, _stateLeds[no].r, _stateLeds[no].g, _stateLeds[no].b),
            no);
      }
      rowWid[i + 1] = Container(
        height: 50,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: colWid,
        ),
      );
    }
    return rowWid;
  }

  @override
  Widget build(BuildContext context) {
    if (!_startCheck) {
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
    _rowWid = _buildLedMatrix(context);
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
                value: _curColor.red.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double newValue) {
                  setState(() {
                    _curColor = _curColor.withRed(newValue.round());
                  });
                },
              )
            ],
          )),
          Center(
              child: Column(
            children: <Widget>[
              Slider(
                value: _curColor.green.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.green,
                onChanged: (double newValue) {
                  setState(() {
                    _curColor = _curColor.withGreen(newValue.round());
                  });
                },
              )
            ],
          )),
          Center(
              child: Column(
            children: <Widget>[
              Slider(
                value: _curColor.blue.toDouble(),
                min: 0.0,
                max: 255.0,
                inactiveColor: Colors.white,
                activeColor: Colors.blue,
                onChanged: (double newValue) {
                  setState(() {
                    _curColor = _curColor.withBlue(newValue.round());
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
              _colorPrefab(context, Colors.greenAccent),
              _colorPrefab(context, Colors.redAccent),
              _colorPrefab(context, Colors.blueAccent),
              _colorPrefab(context, Colors.white),
              _colorPrefab(context, Colors.black),
              _colorPrefab(context, Colors.yellowAccent),
              _colorPrefab(context, Colors.orangeAccent),
              _colorPrefab(context, Colors.cyanAccent),
              _colorPrefab(context, Colors.purpleAccent),
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
                    b.r = _curColor.red;
                    b.g = _curColor.green;
                    b.b = _curColor.blue;
                    b.led = _curLed;
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
                        b.r = _curColor.red;
                        b.g = _curColor.green;
                        b.b = _curColor.blue;
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
//      body: Container(
//        child: BidirectionalScrollViewPlugin(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: _rowWid,
//          ),
//        ),
//      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _col * 62.00,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _rowWid,
            )],
          ),
        ),
      ),
      //TODO replace with progress button
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                minWidth: 70,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (context, setState) {
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
                                        controller: _rowCon,
                                        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "行数",
                                        ),
                                      ),
                                      TextField(
                                        textAlign: TextAlign.center,
                                        controller: _colCon,
                                        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "列数",
                                        ),
                                      ),
                                      ProgressButton(
                                        child: _submitNewInfo,
                                        buttonState: _submiNewState,
                                        onPressed: () async {
                                          setState(() {
                                            _submiNewState = ButtonState.inProgress;
                                            _submitNewInfo = Text(
                                              "稍后",
                                              style: TextStyle(color: Colors.white),
                                            );
                                          });
                                          Map<String, String> body = {
                                            "rowCount": _rowCon.text,
                                            "colCount": _colCon.text
                                          };
                                          final res = await http.post(
                                              "${_ip}led/set_config/",
                                              body: body);
                                          if (res.statusCode != 202) {
                                            _showSnackBar("网络错误");
                                            setState(() {
                                              _submiNewState = ButtonState.error;
                                            });
                                            await Future.delayed(const Duration(seconds: 1), (){});
                                          } else {
                                            _showSnackBar("保存成功");
                                            setState(() {
                                              _curState = _newState.text;
                                              _row = int.parse(_rowCon.text);
                                              _col = int.parse(_colCon.text);
                                            });
                                            if (_row * _col >
                                                _stateLeds.length) {
                                              _stateLeds.insertAll(
                                                  _stateLeds.length,
                                                  List<
                                                      models.StateLed>.generate(
                                                      _row * _col -
                                                          _stateLeds.length, (
                                                      i) {
                                                    return models.StateLed((b) {
                                                      b.state = '默认线路';
                                                      b.led = i;
                                                      b.r = 0;
                                                      b.b = 0;
                                                      b.g = 0;
                                                    });
                                                  }));
                                            }
                                            List<Widget> content = _buildLedMatrix(context);
                                            setState(() {
                                              _submitNewInfo = Text(
                                                "提交",
                                                style: TextStyle(color: Colors.white),
                                              );
                                              _rowWid = content;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      });
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("更改长宽"),
              ),
              MaterialButton(
                minWidth: 70,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (context, setState) {
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
                                        child: _submitNewInfo,
                                        buttonState: _submiNewState,
                                        onPressed: () async {
                                          setState(() {
                                            _submiNewState = ButtonState.inProgress;
                                            _submitNewInfo = Text(
                                              "稍后",
                                              style: TextStyle(color: Colors.white),
                                            );
                                          });
                                          Map<String, String> body = {
                                            "name": _newState.text
                                          };
                                          final res = await http.post(
                                              "${_ip}led/save_state/",
                                              body: body);
                                          if (res.statusCode != 202) {
                                            _showSnackBar("网络错误");
                                            setState(() {
                                              _submiNewState = ButtonState.error;
                                            });
                                            await Future.delayed(const Duration(seconds: 1), (){});
                                          } else {
                                            _showSnackBar("保存成功");
                                            setState(() {
                                              _curState = _newState.text;
                                              _submitNewInfo = Text(
                                                "提交",
                                                style: TextStyle(color: Colors.white),
                                              );
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      });
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("另存为"),
              ),
              RaisedButton(
                onPressed: () async {
                  bool overRide = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("再确认"),
                        content: const Text("确认覆盖?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("覆盖")
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("取消"),
                          ),
                        ],
                      );
                    },
                  );
                  if (overRide){
                    Map<String, String> body = {"name": _curState};
                    final res =
                    await http.post("${_ip}led/save_state/", body: body);
                    if (res.statusCode != 202) {
                      _showSnackBar("网络错误");
                    } else {
                      _showSnackBar("保存成功");
                    }
                  }
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("覆盖此线路"),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () async {
                  Map<String, String> body = {"r": "0", "g":"0", "b":"0"};
                  final res =
                      await http.post("${_ip}led/set_all/", body: body);
                  if (res.statusCode != 202) {
                    _showSnackBar("网络错误");
                  } else {
                    for (var i = 0; i < _stateLeds.length; i ++) {
                      setState(() {
                        _stateLeds[i] = _stateLeds[i].rebuild((b) {
                          b.r = 0;
                          b.g = 0;
                          b.b = 0;
                        });
                      });
                    }
                  }
                },
                color: Colors.black,
                textColor: Colors.white,
                child: Text("全灭"),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () async {
                  final body =
                  models.serialStateLed(_stateLeds[_stateLeds.length - 1].rebuild((b) {
                    b.r = 255;
                    b.g = 255;
                    b.b = 255;
                    b.led = b.led;
                  }));
                  var res = await http.post("${_ip}led/light/", body: body);
                  if (res.statusCode != 202) {
                    setState(() {
                      _submitLebButton = ButtonState.error;
                    });
                    _showSnackBar("网络错误");
                  }
                  Map<String, String> colBody = {"r": "255", "g":"255", "b":"255"};
                  res =
                      await http.post("${_ip}led/set_all/", body: colBody);
                  if (res.statusCode != 202) {
                    _showSnackBar("网络错误");
                  } else {
                    for (var i = 0; i < _stateLeds.length; i ++) {
                      setState(() {
                        _stateLeds[i] = _stateLeds[i].rebuild((b) {
                          b.r = 255;
                          b.g = 255;
                          b.b = 255;
                        });
                      });
                    }
                  }
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Text("全亮"),
              ),
//              RaisedButton(
//                onPressed: () async {
//                  if (_curState == _default) {
//                    _showSnackBar("无法删除默认");
//                    return;
//                  }
//                  Map<String, String> body = {"name": _curState};
//                  final res =
//                      await http.post("${_ip}led/remove_state/", body: body);
//                  if (res.statusCode != 204) {
//                    _showSnackBar("网络错误");
//                  } else {
//                    _showSnackBar("删除成功");
//                    _showStates(canDismiss: false);
//                  }
//                },
//                color: Colors.red,
//                textColor: Colors.white,
//                child: Text("删除此线路"),
//              ),
            ],
          ),
        ),
      ),
      //TODO progress button?
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _showStates();
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
            _curColor = Color.fromARGB(255, _stateLeds[key].r, _stateLeds[key].g, _stateLeds[key].b);
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
