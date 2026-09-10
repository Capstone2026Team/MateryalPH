//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/bot_step_up_error_envelope_all_of_errors_all_of_details.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bot_step_up_error_envelope_all_of_errors.g.dart';

/// BotStepUpErrorEnvelopeAllOfErrors
///
/// Properties:
/// * [code] 
/// * [message] 
/// * [details] 
@BuiltValue()
abstract class BotStepUpErrorEnvelopeAllOfErrors implements Built<BotStepUpErrorEnvelopeAllOfErrors, BotStepUpErrorEnvelopeAllOfErrorsBuilder> {
  @BuiltValueField(wireName: r'code')
  BotStepUpErrorEnvelopeAllOfErrorsCodeEnum get code;
  // enum codeEnum {  BOT_STEP_UP_REQUIRED,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'details')
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails get details;

  BotStepUpErrorEnvelopeAllOfErrors._();

  factory BotStepUpErrorEnvelopeAllOfErrors([void updates(BotStepUpErrorEnvelopeAllOfErrorsBuilder b)]) = _$BotStepUpErrorEnvelopeAllOfErrors;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BotStepUpErrorEnvelopeAllOfErrorsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BotStepUpErrorEnvelopeAllOfErrors> get serializer => _$BotStepUpErrorEnvelopeAllOfErrorsSerializer();
}

class _$BotStepUpErrorEnvelopeAllOfErrorsSerializer implements PrimitiveSerializer<BotStepUpErrorEnvelopeAllOfErrors> {
  @override
  final Iterable<Type> types = const [BotStepUpErrorEnvelopeAllOfErrors, _$BotStepUpErrorEnvelopeAllOfErrors];

  @override
  final String wireName = r'BotStepUpErrorEnvelopeAllOfErrors';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BotStepUpErrorEnvelopeAllOfErrors object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BotStepUpErrorEnvelopeAllOfErrors object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BotStepUpErrorEnvelopeAllOfErrorsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum),
          ) as BotStepUpErrorEnvelopeAllOfErrorsCodeEnum;
          result.code = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails),
          ) as BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails;
          result.details.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BotStepUpErrorEnvelopeAllOfErrors deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BotStepUpErrorEnvelopeAllOfErrorsBuilder();
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


class BotStepUpErrorEnvelopeAllOfErrorsCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOT_STEP_UP_REQUIRED')
  static const BotStepUpErrorEnvelopeAllOfErrorsCodeEnum BOT_STEP_UP_REQUIRED = _$botStepUpErrorEnvelopeAllOfErrorsCodeEnum_BOT_STEP_UP_REQUIRED;

  static Serializer<BotStepUpErrorEnvelopeAllOfErrorsCodeEnum> get serializer => _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumSerializer;

  const BotStepUpErrorEnvelopeAllOfErrorsCodeEnum._(String name): super(name);

  static BuiltSet<BotStepUpErrorEnvelopeAllOfErrorsCodeEnum> get values => _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumValues;
  static BotStepUpErrorEnvelopeAllOfErrorsCodeEnum valueOf(String name) => _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumValueOf(name);
}

