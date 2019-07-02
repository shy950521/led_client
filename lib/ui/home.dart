import 'package:led_client/src/json_parse.dart' as models;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_button/progress_button.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();
  static final int _row = 5;
  static final int _col = 5;
  static final ip = 'http://192.168.0.175:8000/';
  String _curState = 'default';
  int _curLed = 0;
  int _red = 0;
  int _green = 0;
  int _blue = 0;
  Color _curColor = Color.fromARGB(255, 0, 0, 0);
  Future<http.Response> _submitCurLed;
  TextEditingController _newState = TextEditingController();
  // default data
  List<models.StateLed> _stateLeds =
      List<models.StateLed>.generate(_row * _col, (i) {
    return models.StateLed((b) {
      b.state = 'default';
      b.led = -1;
      b.r = 0;
      b.g = 0;
      b.b = 0;
    });
  });

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

  //TODO: user futureBuilder and add progress indicator.
  Future<void> _showStates() async {
    final res = await http.get("${ip}led/state_list/");
    if (res.statusCode != 200) {
      _showSnackBar("联网错误");
    } else {
      List<models.State> states = models.parseStateList(res.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white.withOpacity(0.88),
              child: Container(
                width: 500,
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  shrinkWrap: true,
                  children: List<Widget>.generate(states.length, (i) {
                    return RaisedButton(
                      onPressed: () {},
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("${states[i].name}"),
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
        await http.get("${ip}led/stateLed_list/", headers: {'name': name});
    if (res.statusCode != 200) {
      _showSnackBar("联网错误");
    } else {
      setState(() {
        _stateLeds = models.parseStateLedList(res.body);
      });
    }
  }

  @override
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
            width: 100,
            alignment: Alignment.center,
            child: RaisedButton(
              //TODO futureBuild
              onPressed: () async {
                setState(() {
                  _stateLeds[_curLed] = _stateLeds[_curLed].rebuild((b) {
                    b.r = _red;
                    b.g = _green;
                    b.b = _blue;
                  });
                });
                final body = models.serialStateLed(_stateLeds[_curLed]);
                final res = await http.post("${ip}led/light/", body: body);
                if (res.statusCode != 202) {
                  _showSnackBar("网络错误");
                } else {
                  Navigator.pop(context);
                }
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("提交"),
            ),
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: FutureBuilder<http.Response>(
              future: _submitCurLed,
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return RaisedButton(
                      onPressed: () async {
                        final body = models
                            .serialStateLed(_stateLeds[_curLed].rebuild((b) {
                          b.r = _red;
                          b.g = _green;
                          b.b = _blue;
                        }));
                        setState(() {
                          _submitCurLed =
                              http.post("${ip}led/light/", body: body);
                          _stateLeds[_curLed] =
                              _stateLeds[_curLed].rebuild((b) {
                            b.r = _red;
                            b.g = _green;
                            b.b = _blue;
                          });
                        });
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("提交"),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return RaisedButton(
                      onPressed: null,
                      color: Colors.red,
                      textColor: Colors.white,
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.data == null ||
                        snapshot.data.statusCode != 202) {
                      return RaisedButton(
                        onPressed: () async {
                          final body = models
                              .serialStateLed(_stateLeds[_curLed].rebuild((b) {
                            b.r = _red;
                            b.g = _green;
                            b.b = _blue;
                          }));
                          setState(() {
                            _submitCurLed =
                                http.post("${ip}led/light/", body: body);
                            _stateLeds[_curLed] =
                                _stateLeds[_curLed].rebuild((b) {
                              b.r = _red;
                              b.g = _green;
                              b.b = _blue;
                            });
                          });
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Icon(Icons.error),
                      );
                    } else {
                      _submitCurLed = null;
                      return RaisedButton(
                        onPressed: () async {
                          final body = models
                              .serialStateLed(_stateLeds[_curLed].rebuild((b) {
                            b.r = _red;
                            b.g = _green;
                            b.b = _blue;
                          }));
                          setState(() {
                            _submitCurLed =
                                http.post("${ip}led/light/", body: body);
                            _stateLeds[_curLed] =
                                _stateLeds[_curLed].rebuild((b) {
                              b.r = _red;
                              b.g = _green;
                              b.b = _blue;
                            });
                          });
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("提交"),
                      );
                    }
                }
              },
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
        children: rowWid,
      ),
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
                      await http.post("${ip}led/save_state/", body: body);
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
                onPressed: () {},
                color: Colors.red,
                textColor: Colors.white,
                child: Text("删除当前"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _showStates();
          setState(() {});
//          _homeKey.currentState.openDrawer();
        },
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  FutureBuilder _submitChild(
      Future<http.Response> futureR, int stateCode, Function() f) {
    return FutureBuilder(
      future: futureR,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("提交");
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.data.statusCode != stateCode) {
              _showSnackBar("网络错误");
              return Icon(Icons.error);
            } else {
              f();
              return Icon(Icons.send);
            }
        }
      },
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
