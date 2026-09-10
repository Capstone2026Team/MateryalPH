//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'csrf_envelope_all_of_data.g.dart';

/// CsrfEnvelopeAllOfData
///
/// Properties:
/// * [csrfToken] 
@BuiltValue()
abstract class CsrfEnvelopeAllOfData implements Built<CsrfEnvelopeAllOfData, CsrfEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'csrf_token')
  String get csrfToken;

  CsrfEnvelopeAllOfData._();

  factory CsrfEnvelopeAllOfData([void updates(CsrfEnvelopeAllOfDataBuilder b)]) = _$CsrfEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CsrfEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CsrfEnvelopeAllOfData> get serializer => _$CsrfEnvelopeAllOfDataSerializer();
}

class _$CsrfEnvelopeAllOfDataSerializer implements PrimitiveSerializer<CsrfEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [CsrfEnvelopeAllOfData, _$CsrfEnvelopeAllOfData];

  @override
  final String wireName = r'CsrfEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CsrfEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'csrf_token';
    yield serializers.serialize(
      object.csrfToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CsrfEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CsrfEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'csrf_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.csrfToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CsrfEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CsrfEnvelopeAllOfDataBuilder();
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


