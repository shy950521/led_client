import "package:test/test.dart";
import 'package:led_client/src/json_parse.dart';
import 'package:led_client/src/serializers.dart';
import 'package:built_value/serializer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  test("pharse Top stories", () async{
    final ip = 'http://127.0.0.1:8000/';
    final res = await http.get("${ip}led/stateLed_list/", headers: {'name':'default'});
    final ans = parseStateLedList(res.body);
    expect(ans.length, 25);
  });
  test("222", () async{
    final val = StateLed((b){
      b.led = 0;
      b.r = 200;
      b.g = 200;
      b.b = 200;
      b.state = "default";
    });
    Map<String,String> body = {};
    final Map<String,dynamic> ans  = standardSerializers.serializeWith(StateLed.serializer, val);
    ans.forEach((k,v){
      body[k] = v.toString();
    });
    final res = await http.post("http://192.168.0.175:8000/led/light/", body: body);
    expect(res.statusCode, 202);
  });
  test("333", () {
    final val = State((b){
      b.name = "default";
    });
    final json = standardSerializers.serialize(val);
    expect(json, isNotNull);
  });

}
