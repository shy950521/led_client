import "dart:convert";
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'serializers.dart';

part 'state.g.dart';

abstract class State implements Built<State, StateBuilder> {
  static Serializer<State> get serializer => _$stateSerializer;
  String get name;
  State._();
  factory State([void Function(StateBuilder) updates]) = _$State;
}