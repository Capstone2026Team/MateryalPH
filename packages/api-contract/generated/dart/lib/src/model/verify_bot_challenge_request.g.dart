// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_bot_challenge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerifyBotChallengeRequest extends VerifyBotChallengeRequest {
  @override
  final String email;
  @override
  final String code;

  factory _$VerifyBotChallengeRequest(
          [void Function(VerifyBotChallengeRequestBuilder)? updates]) =>
      (VerifyBotChallengeRequestBuilder()..update(updates))._build();

  _$VerifyBotChallengeRequest._({required this.email, required this.code})
      : super._();
  @override
  VerifyBotChallengeRequest rebuild(
          void Function(VerifyBotChallengeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerifyBotChallengeRequestBuilder toBuilder() =>
      VerifyBotChallengeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerifyBotChallengeRequest &&
        email == other.email &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerifyBotChallengeRequest')
          ..add('email', email)
          ..add('code', code))
        .toString();
  }
}

class VerifyBotChallengeRequestBuilder
    implements
        Builder<VerifyBotChallengeRequest, VerifyBotChallengeRequestBuilder> {
  _$VerifyBotChallengeRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  VerifyBotChallengeRequestBuilder() {
    VerifyBotChallengeRequest._defaults(this);
  }

  VerifyBotChallengeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerifyBotChallengeRequest other) {
    _$v = other as _$VerifyBotChallengeRequest;
  }

  @override
  void update(void Function(VerifyBotChallengeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerifyBotChallengeRequest build() => _build();

  _$VerifyBotChallengeRequest _build() {
    final _$result = _$v ??
        _$VerifyBotChallengeRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VerifyBotChallengeRequest', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'VerifyBotChallengeRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
