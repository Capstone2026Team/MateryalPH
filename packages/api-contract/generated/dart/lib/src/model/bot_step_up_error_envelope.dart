//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/bot_step_up_error_envelope_all_of_errors.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bot_step_up_error_envelope.g.dart';

/// BotStepUpErrorEnvelope
///
/// Properties:
/// * [data] 
/// * [meta] 
/// * [errors] 
@BuiltValue()
abstract class BotStepUpErrorEnvelope implements Built<BotStepUpErrorEnvelope, BotStepUpErrorEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  JsonObject? get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BotStepUpErrorEnvelopeAllOfErrors> get errors;

  BotStepUpErrorEnvelope._();

  factory BotStepUpErrorEnvelope([void updates(BotStepUpErrorEnvelopeBuilder b)]) = _$BotStepUpErrorEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BotStepUpErrorEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BotStepUpErrorEnvelope> get serializer => _$BotStepUpErrorEnvelopeSerializer();
}

class _$BotStepUpErrorEnvelopeSerializer implements PrimitiveSerializer<BotStepUpErrorEnvelope> {
  @override
  final Iterable<Type> types = const [BotStepUpErrorEnvelope, _$BotStepUpErrorEnvelope];

  @override
  final String wireName = r'BotStepUpErrorEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BotStepUpErrorEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield object.data == null ? null : serializers.serialize(
      object.data,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BotStepUpErrorEnvelopeAllOfErrors)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BotStepUpErrorEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BotStepUpErrorEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.data = valueDes;
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BotStepUpErrorEnvelopeAllOfErrors)]),
          ) as BuiltList<BotStepUpErrorEnvelopeAllOfErrors>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BotStepUpErrorEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BotStepUpErrorEnvelopeBuilder();
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


