// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_identity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserIdentity extends UserIdentity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final AccountType accountType;

  factory _$UserIdentity([void Function(UserIdentityBuilder)? updates]) =>
      (UserIdentityBuilder()..update(updates))._build();

  _$UserIdentity._(
      {required this.id,
      required this.name,
      required this.email,
      required this.accountType})
      : super._();
  @override
  UserIdentity rebuild(void Function(UserIdentityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserIdentityBuilder toBuilder() => UserIdentityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserIdentity &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        accountType == other.accountType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserIdentity')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('accountType', accountType))
        .toString();
  }
}

class UserIdentityBuilder
    implements Builder<UserIdentity, UserIdentityBuilder> {
  _$UserIdentity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AccountType? _accountType;
  AccountType? get accountType => _$this._accountType;
  set accountType(AccountType? accountType) =>
      _$this._accountType = accountType;

  UserIdentityBuilder() {
    UserIdentity._defaults(this);
  }

  UserIdentityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _accountType = $v.accountType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserIdentity other) {
    _$v = other as _$UserIdentity;
  }

  @override
  void update(void Function(UserIdentityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserIdentity build() => _build();

  _$UserIdentity _build() {
    final _$result = _$v ??
        _$UserIdentity._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserIdentity', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserIdentity', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'UserIdentity', 'email'),
          accountType: BuiltValueNullFieldError.checkNotNull(
              accountType, r'UserIdentity', 'accountType'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
