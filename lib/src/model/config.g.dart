// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Config> _$configSerializer = new _$ConfigSerializer();

class _$ConfigSerializer implements StructuredSerializer<Config> {
  @override
  final Iterable<Type> types = const [Config, _$Config];
  @override
  final String wireName = 'Config';

  @override
  Iterable<Object> serialize(Serializers serializers, Config object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'rowCount',
      serializers.serialize(object.rowCount,
          specifiedType: const FullType(int)),
      'colCount',
      serializers.serialize(object.colCount,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Config deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'rowCount':
          result.rowCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'colCount':
          result.colCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Config extends Config {
  @override
  final int rowCount;
  @override
  final int colCount;

  factory _$Config([void Function(ConfigBuilder) updates]) =>
      (new ConfigBuilder()..update(updates)).build();

  _$Config._({this.rowCount, this.colCount}) : super._() {
    if (rowCount == null) {
      throw new BuiltValueNullFieldError('Config', 'rowCount');
    }
    if (colCount == null) {
      throw new BuiltValueNullFieldError('Config', 'colCount');
    }
  }

  @override
  Config rebuild(void Function(ConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConfigBuilder toBuilder() => new ConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Config &&
        rowCount == other.rowCount &&
        colCount == other.colCount;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, rowCount.hashCode), colCount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Config')
          ..add('rowCount', rowCount)
          ..add('colCount', colCount))
        .toString();
  }
}

class ConfigBuilder implements Builder<Config, ConfigBuilder> {
  _$Config _$v;

  int _rowCount;
  int get rowCount => _$this._rowCount;
  set rowCount(int rowCount) => _$this._rowCount = rowCount;

  int _colCount;
  int get colCount => _$this._colCount;
  set colCount(int colCount) => _$this._colCount = colCount;

  ConfigBuilder();

  ConfigBuilder get _$this {
    if (_$v != null) {
      _rowCount = _$v.rowCount;
      _colCount = _$v.colCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Config other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Config;
  }

  @override
  void update(void Function(ConfigBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Config build() {
    final _$result =
        _$v ?? new _$Config._(rowCount: rowCount, colCount: colCount);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
