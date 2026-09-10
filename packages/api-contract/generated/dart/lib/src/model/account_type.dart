//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_type.g.dart';

class AccountType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const AccountType BUYER = _$BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const AccountType VENDOR = _$VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const AccountType ADMIN = _$ADMIN;

  static Serializer<AccountType> get serializer => _$accountTypeSerializer;

  const AccountType._(String name): super(name);

  static BuiltSet<AccountType> get values => _$values;
  static AccountType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AccountTypeMixin = Object with _$AccountTypeMixin;

