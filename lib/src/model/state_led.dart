import "dart:convert";
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import '../serializers.dart';

part 'state_led.g.dart';

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
