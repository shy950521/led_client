import "dart:convert";
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import '../serializers.dart';

part 'config.g.dart';

abstract class Config implements Built<Config, ConfigBuilder> {
  static Serializer<Config> get serializer => _$configSerializer;
  int get rowCount;
  int get colCount;
  Config._();
  factory Config([void Function(ConfigBuilder) updates]) = _$Config;
}