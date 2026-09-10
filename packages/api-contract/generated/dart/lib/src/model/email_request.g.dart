// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailRequest extends EmailRequest {
  @override
  final String email;

  factory _$EmailRequest([void Function(EmailRequestBuilder)? updates]) =>
      (EmailRequestBuilder()..update(updates))._build();

  _$EmailRequest._({required this.email}) : super._();
  @override
  EmailRequest rebuild(void Function(EmailRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailRequestBuilder toBuilder() => EmailRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailRequest && email == other.email;
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
    return (newBuiltValueToStringHelper(r'EmailRequest')..add('email', email))
        .toString();
  }
}

class EmailRequestBuilder
    implements Builder<EmailRequest, EmailRequestBuilder> {
  _$EmailRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  EmailRequestBuilder() {
    EmailRequest._defaults(this);
  }

  EmailRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailRequest other) {
    _$v = other as _$EmailRequest;
  }

  @override
  void update(void Function(EmailRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailRequest build() => _build();

  _$EmailRequest _build() {
    final _$result = _$v ??
        _$EmailRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
