import "dart:convert";
import 'state_led.dart';
import 'state.dart';
import 'serializers.dart';

List<State> parseStateList(String json){
  List parsed = jsonDecode(json);
  List<State> ans = List<State>.generate(parsed.length, (i){
    return standardSerializers.deserializeWith(State.serializer, parsed[i]);
  });
  return ans;
}

List<StateLed> parseStateLedList(String json){
  List parsed = jsonDecode(json);
  List<StateLed> ans = List<StateLed>.generate(parsed.length, (i){
    return standardSerializers.deserializeWith(StateLed.serializer, parsed[i]);
  });
  return ans;
}

StateLed parseStateLed(String json){
  final parsed = jsonDecode(json);
  StateLed stateLed = standardSerializers.deserializeWith(StateLed.serializer, parsed);
  return stateLed;
}

Map<String, String> serialStateLed(StateLed stateled){
  final Map<String, dynamic> map = standardSerializers.serializeWith(StateLed.serializer, stateled);
  Map<String,String> body = {};
  map.forEach((k,v){
    body[k] = v.toString();
  });
  return body;
}