// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountType _$BUYER = const AccountType._('BUYER');
const AccountType _$VENDOR = const AccountType._('VENDOR');
const AccountType _$ADMIN = const AccountType._('ADMIN');

AccountType _$valueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$BUYER;
    case 'VENDOR':
      return _$VENDOR;
    case 'ADMIN':
      return _$ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountType> _$values =
    BuiltSet<AccountType>(const <AccountType>[
  _$BUYER,
  _$VENDOR,
  _$ADMIN,
]);

class _$AccountTypeMeta {
  const _$AccountTypeMeta();
  AccountType get BUYER => _$BUYER;
  AccountType get VENDOR => _$VENDOR;
  AccountType get ADMIN => _$ADMIN;
  AccountType valueOf(String name) => _$valueOf(name);
  BuiltSet<AccountType> get values => _$values;
}

abstract class _$AccountTypeMixin {
  // ignore: non_constant_identifier_names
  _$AccountTypeMeta get AccountType => const _$AccountTypeMeta();
}

Serializer<AccountType> _$accountTypeSerializer = _$AccountTypeSerializer();

class _$AccountTypeSerializer implements PrimitiveSerializer<AccountType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountType];
  @override
  final String wireName = 'AccountType';

  @override
  Object serialize(Serializers serializers, AccountType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
