//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_mobile_exchange_request.g.dart';

/// GoogleMobileExchangeRequest
///
/// Properties:
/// * [exchangeCode] 
/// * [deviceId] 
@BuiltValue()
abstract class GoogleMobileExchangeRequest implements Built<GoogleMobileExchangeRequest, GoogleMobileExchangeRequestBuilder> {
  @BuiltValueField(wireName: r'exchange_code')
  String get exchangeCode;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  GoogleMobileExchangeRequest._();

  factory GoogleMobileExchangeRequest([void updates(GoogleMobileExchangeRequestBuilder b)]) = _$GoogleMobileExchangeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleMobileExchangeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleMobileExchangeRequest> get serializer => _$GoogleMobileExchangeRequestSerializer();
}

class _$GoogleMobileExchangeRequestSerializer implements PrimitiveSerializer<GoogleMobileExchangeRequest> {
  @override
  final Iterable<Type> types = const [GoogleMobileExchangeRequest, _$GoogleMobileExchangeRequest];

  @override
  final String wireName = r'GoogleMobileExchangeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleMobileExchangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'exchange_code';
    yield serializers.serialize(
      object.exchangeCode,
      specifiedType: const FullType(String),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleMobileExchangeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleMobileExchangeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'exchange_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.exchangeCode = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleMobileExchangeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleMobileExchangeRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


