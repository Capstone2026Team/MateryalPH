// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrationEnvelopeAllOfData extends RegistrationEnvelopeAllOfData {
  @override
  final String? userId;
  @override
  final bool? verificationRequired;
  @override
  final String? next;

  factory _$RegistrationEnvelopeAllOfData(
          [void Function(RegistrationEnvelopeAllOfDataBuilder)? updates]) =>
      (RegistrationEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$RegistrationEnvelopeAllOfData._(
      {this.userId, this.verificationRequired, this.next})
      : super._();
  @override
  RegistrationEnvelopeAllOfData rebuild(
          void Function(RegistrationEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrationEnvelopeAllOfDataBuilder toBuilder() =>
      RegistrationEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrationEnvelopeAllOfData &&
        userId == other.userId &&
        verificationRequired == other.verificationRequired &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, verificationRequired.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrationEnvelopeAllOfData')
          ..add('userId', userId)
          ..add('verificationRequired', verificationRequired)
          ..add('next', next))
        .toString();
  }
}

class RegistrationEnvelopeAllOfDataBuilder
    implements
        Builder<RegistrationEnvelopeAllOfData,
            RegistrationEnvelopeAllOfDataBuilder> {
  _$RegistrationEnvelopeAllOfData? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  bool? _verificationRequired;
  bool? get verificationRequired => _$this._verificationRequired;
  set verificationRequired(bool? verificationRequired) =>
      _$this._verificationRequired = verificationRequired;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  RegistrationEnvelopeAllOfDataBuilder() {
    RegistrationEnvelopeAllOfData._defaults(this);
  }

  RegistrationEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _verificationRequired = $v.verificationRequired;
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrationEnvelopeAllOfData other) {
    _$v = other as _$RegistrationEnvelopeAllOfData;
  }

  @override
  void update(void Function(RegistrationEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrationEnvelopeAllOfData build() => _build();

  _$RegistrationEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$RegistrationEnvelopeAllOfData._(
          userId: userId,
          verificationRequired: verificationRequired,
          next: next,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
