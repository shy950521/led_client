import "dart:convert";
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'serializers.dart';

part 'json_parse.g.dart';

abstract class StateLed implements Built<StateLed, StateLedBuilder> {
  static Serializer<StateLed> get serializer => _$stateLedSerializer;
  String get state;
  int get led;
  int get r;
  int get g;
  int get b;
  StateLed._();
  factory StateLed([void Function(StateLedBuilder) updates]) = _$StateLed;
}

abstract class State implements Built<State, StateBuilder> {
  static Serializer<State> get serializer => _$stateSerializer;
  String get name;
  State._();
  factory State([void Function(StateBuilder) updates]) = _$State;
}

List<State> parseStateList(String json){
  throw UnimplementedError;
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