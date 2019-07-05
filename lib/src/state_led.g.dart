// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_led.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StateLed> _$stateLedSerializer = new _$StateLedSerializer();

class _$StateLedSerializer implements StructuredSerializer<StateLed> {
  @override
  final Iterable<Type> types = const [StateLed, _$StateLed];
  @override
  final String wireName = 'StateLed';

  @override
  Iterable serialize(Serializers serializers, StateLed object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'state',
      serializers.serialize(object.state,
          specifiedType: const FullType(String)),
      'led',
      serializers.serialize(object.led, specifiedType: const FullType(int)),
      'r',
      serializers.serialize(object.r, specifiedType: const FullType(int)),
      'g',
      serializers.serialize(object.g, specifiedType: const FullType(int)),
      'b',
      serializers.serialize(object.b, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  StateLed deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StateLedBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'state':
          result.state = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'led':
          result.led = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'r':
          result.r = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'g':
          result.g = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'b':
          result.b = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$StateLed extends StateLed {
  @override
  final String state;
  @override
  final int led;
  @override
  final int r;
  @override
  final int g;
  @override
  final int b;

  factory _$StateLed([void Function(StateLedBuilder) updates]) =>
      (new StateLedBuilder()..update(updates)).build();

  _$StateLed._({this.state, this.led, this.r, this.g, this.b}) : super._() {
    if (state == null) {
      throw new BuiltValueNullFieldError('StateLed', 'state');
    }
    if (led == null) {
      throw new BuiltValueNullFieldError('StateLed', 'led');
    }
    if (r == null) {
      throw new BuiltValueNullFieldError('StateLed', 'r');
    }
    if (g == null) {
      throw new BuiltValueNullFieldError('StateLed', 'g');
    }
    if (b == null) {
      throw new BuiltValueNullFieldError('StateLed', 'b');
    }
  }

  @override
  StateLed rebuild(void Function(StateLedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StateLedBuilder toBuilder() => new StateLedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StateLed &&
        state == other.state &&
        led == other.led &&
        r == other.r &&
        g == other.g &&
        b == other.b;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, state.hashCode), led.hashCode), r.hashCode),
            g.hashCode),
        b.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StateLed')
          ..add('state', state)
          ..add('led', led)
          ..add('r', r)
          ..add('g', g)
          ..add('b', b))
        .toString();
  }
}

class StateLedBuilder implements Builder<StateLed, StateLedBuilder> {
  _$StateLed _$v;

  String _state;
  String get state => _$this._state;
  set state(String state) => _$this._state = state;

  int _led;
  int get led => _$this._led;
  set led(int led) => _$this._led = led;

  int _r;
  int get r => _$this._r;
  set r(int r) => _$this._r = r;

  int _g;
  int get g => _$this._g;
  set g(int g) => _$this._g = g;

  int _b;
  int get b => _$this._b;
  set b(int b) => _$this._b = b;

  StateLedBuilder();

  StateLedBuilder get _$this {
    if (_$v != null) {
      _state = _$v.state;
      _led = _$v.led;
      _r = _$v.r;
      _g = _$v.g;
      _b = _$v.b;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StateLed other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StateLed;
  }

  @override
  void update(void Function(StateLedBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StateLed build() {
    final _$result =
        _$v ?? new _$StateLed._(state: state, led: led, r: r, g: g, b: b);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
