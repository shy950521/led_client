import "dart:convert";
import 'model/state_led.dart';
import 'model/state.dart';
import 'serializers.dart';
import 'model/config.dart';

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

Config parseConfig(String json){
  final parsed = jsonDecode(json);
  Config config = standardSerializers.deserializeWith(Config.serializer, parsed);
  return config;
}

Map<String, String> serialConfig(Config config){
  final Map<String, dynamic> map = standardSerializers.serializeWith(Config.serializer, config);
  Map<String,String> body = {};
  map.forEach((k,v){
    body[k] = v.toString();
  });
  return body;
}

Map<String, String> serialStateLed(StateLed stateled){
  final Map<String, dynamic> map = standardSerializers.serializeWith(StateLed.serializer, stateled);
  Map<String,String> body = {};
  map.forEach((k,v){
    body[k] = v.toString();
  });
  return body;
}