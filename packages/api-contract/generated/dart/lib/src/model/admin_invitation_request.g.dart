// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_invitation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminInvitationRequestTermsAcceptedEnum
    _$adminInvitationRequestTermsAcceptedEnum_true_ =
    const AdminInvitationRequestTermsAcceptedEnum._('true_');

AdminInvitationRequestTermsAcceptedEnum
    _$adminInvitationRequestTermsAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminInvitationRequestTermsAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminInvitationRequestTermsAcceptedEnum>
    _$adminInvitationRequestTermsAcceptedEnumValues = BuiltSet<
        AdminInvitationRequestTermsAcceptedEnum>(const <AdminInvitationRequestTermsAcceptedEnum>[
  _$adminInvitationRequestTermsAcceptedEnum_true_,
]);

const AdminInvitationRequestPrivacyAcceptedEnum
    _$adminInvitationRequestPrivacyAcceptedEnum_true_ =
    const AdminInvitationRequestPrivacyAcceptedEnum._('true_');

AdminInvitationRequestPrivacyAcceptedEnum
    _$adminInvitationRequestPrivacyAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminInvitationRequestPrivacyAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminInvitationRequestPrivacyAcceptedEnum>
    _$adminInvitationRequestPrivacyAcceptedEnumValues = BuiltSet<
        AdminInvitationRequestPrivacyAcceptedEnum>(const <AdminInvitationRequestPrivacyAcceptedEnum>[
  _$adminInvitationRequestPrivacyAcceptedEnum_true_,
]);

Serializer<AdminInvitationRequestTermsAcceptedEnum>
    _$adminInvitationRequestTermsAcceptedEnumSerializer =
    _$AdminInvitationRequestTermsAcceptedEnumSerializer();
Serializer<AdminInvitationRequestPrivacyAcceptedEnum>
    _$adminInvitationRequestPrivacyAcceptedEnumSerializer =
    _$AdminInvitationRequestPrivacyAcceptedEnumSerializer();

class _$AdminInvitationRequestTermsAcceptedEnumSerializer
    implements PrimitiveSerializer<AdminInvitationRequestTermsAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminInvitationRequestTermsAcceptedEnum
  ];
  @override
  final String wireName = 'AdminInvitationRequestTermsAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          AdminInvitationRequestTermsAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminInvitationRequestTermsAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminInvitationRequestTermsAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminInvitationRequestPrivacyAcceptedEnumSerializer
    implements PrimitiveSerializer<AdminInvitationRequestPrivacyAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminInvitationRequestPrivacyAcceptedEnum
  ];
  @override
  final String wireName = 'AdminInvitationRequestPrivacyAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          AdminInvitationRequestPrivacyAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminInvitationRequestPrivacyAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminInvitationRequestPrivacyAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminInvitationRequest extends AdminInvitationRequest {
  @override
  final String token;
  @override
  final String fullName;
  @override
  final String password;
  @override
  final String passwordConfirmation;
  @override
  final AdminInvitationRequestTermsAcceptedEnum termsAccepted;
  @override
  final AdminInvitationRequestPrivacyAcceptedEnum privacyAccepted;

  factory _$AdminInvitationRequest(
          [void Function(AdminInvitationRequestBuilder)? updates]) =>
      (AdminInvitationRequestBuilder()..update(updates))._build();

  _$AdminInvitationRequest._(
      {required this.token,
      required this.fullName,
      required this.password,
      required this.passwordConfirmation,
      required this.termsAccepted,
      required this.privacyAccepted})
      : super._();
  @override
  AdminInvitationRequest rebuild(
          void Function(AdminInvitationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminInvitationRequestBuilder toBuilder() =>
      AdminInvitationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminInvitationRequest &&
        token == other.token &&
        fullName == other.fullName &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation &&
        termsAccepted == other.termsAccepted &&
        privacyAccepted == other.privacyAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminInvitationRequest')
          ..add('token', token)
          ..add('fullName', fullName)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation)
          ..add('termsAccepted', termsAccepted)
          ..add('privacyAccepted', privacyAccepted))
        .toString();
  }
}

class AdminInvitationRequestBuilder
    implements Builder<AdminInvitationRequest, AdminInvitationRequestBuilder> {
  _$AdminInvitationRequest? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  AdminInvitationRequestTermsAcceptedEnum? _termsAccepted;
  AdminInvitationRequestTermsAcceptedEnum? get termsAccepted =>
      _$this._termsAccepted;
  set termsAccepted(AdminInvitationRequestTermsAcceptedEnum? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  AdminInvitationRequestPrivacyAcceptedEnum? _privacyAccepted;
  AdminInvitationRequestPrivacyAcceptedEnum? get privacyAccepted =>
      _$this._privacyAccepted;
  set privacyAccepted(
          AdminInvitationRequestPrivacyAcceptedEnum? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  AdminInvitationRequestBuilder() {
    AdminInvitationRequest._defaults(this);
  }

  AdminInvitationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _fullName = $v.fullName;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _termsAccepted = $v.termsAccepted;
      _privacyAccepted = $v.privacyAccepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminInvitationRequest other) {
    _$v = other as _$AdminInvitationRequest;
  }

  @override
  void update(void Function(AdminInvitationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminInvitationRequest build() => _build();

  _$AdminInvitationRequest _build() {
    final _$result = _$v ??
        _$AdminInvitationRequest._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'AdminInvitationRequest', 'token'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'AdminInvitationRequest', 'fullName'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'AdminInvitationRequest', 'password'),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
              passwordConfirmation,
              r'AdminInvitationRequest',
              'passwordConfirmation'),
          termsAccepted: BuiltValueNullFieldError.checkNotNull(
              termsAccepted, r'AdminInvitationRequest', 'termsAccepted'),
          privacyAccepted: BuiltValueNullFieldError.checkNotNull(
              privacyAccepted, r'AdminInvitationRequest', 'privacyAccepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
