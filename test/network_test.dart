import "package:test/test.dart";
import 'package:led_client/src/json_parse.dart';
import 'package:http/http.dart' as http;


void main() {
  test("pharse Top stories", () async{
    final ip = 'http://127.0.0.1:8000/';
    final res = await http.get("${ip}led/stateLed_list/", headers: {'name':'default'});
    final ans = parseStateLedList(res.body);
    expect(ans.length, 25);
  });
}