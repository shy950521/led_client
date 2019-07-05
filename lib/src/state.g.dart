// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<State> _$stateSerializer = new _$StateSerializer();

class _$StateSerializer implements StructuredSerializer<State> {
  @override
  final Iterable<Type> types = const [State, _$State];
  @override
  final String wireName = 'State';

  @override
  Iterable serialize(Serializers serializers, State object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  State deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$State extends State {
  @override
  final String name;

  factory _$State([void Function(StateBuilder) updates]) =>
      (new StateBuilder()..update(updates)).build();

  _$State._({this.name}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('State', 'name');
    }
  }

  @override
  State rebuild(void Function(StateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StateBuilder toBuilder() => new StateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is State && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('State')..add('name', name)).toString();
  }
}

class StateBuilder implements Builder<State, StateBuilder> {
  _$State _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  StateBuilder();

  StateBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(State other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$State;
  }

  @override
  void update(void Function(StateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$State build() {
    final _$result = _$v ?? new _$State._(name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
