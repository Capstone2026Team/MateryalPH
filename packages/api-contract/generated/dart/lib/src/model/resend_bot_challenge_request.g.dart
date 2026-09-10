// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_bot_challenge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResendBotChallengeRequest extends ResendBotChallengeRequest {
  @override
  final String email;

  factory _$ResendBotChallengeRequest(
          [void Function(ResendBotChallengeRequestBuilder)? updates]) =>
      (ResendBotChallengeRequestBuilder()..update(updates))._build();

  _$ResendBotChallengeRequest._({required this.email}) : super._();
  @override
  ResendBotChallengeRequest rebuild(
          void Function(ResendBotChallengeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResendBotChallengeRequestBuilder toBuilder() =>
      ResendBotChallengeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResendBotChallengeRequest && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResendBotChallengeRequest')
          ..add('email', email))
        .toString();
  }
}

class ResendBotChallengeRequestBuilder
    implements
        Builder<ResendBotChallengeRequest, ResendBotChallengeRequestBuilder> {
  _$ResendBotChallengeRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ResendBotChallengeRequestBuilder() {
    ResendBotChallengeRequest._defaults(this);
  }

  ResendBotChallengeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResendBotChallengeRequest other) {
    _$v = other as _$ResendBotChallengeRequest;
  }

  @override
  void update(void Function(ResendBotChallengeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResendBotChallengeRequest build() => _build();

  _$ResendBotChallengeRequest _build() {
    final _$result = _$v ??
        _$ResendBotChallengeRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ResendBotChallengeRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
