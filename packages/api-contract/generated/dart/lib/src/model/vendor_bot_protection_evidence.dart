//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_bot_protection_evidence.g.dart';

/// Vendor web only. Supply a checkbox token or explicitly request the accessible email fallback. After successful email risk verification, an empty object is permitted because the one-time proof is carried in the HttpOnly mp_bot_proof cookie.
///
/// Properties:
/// * [recaptchaToken] 
/// * [requestEmailStepUp] - Must be true when the accessible email step-up method is selected.
@BuiltValue()
abstract class VendorBotProtectionEvidence implements Built<VendorBotProtectionEvidence, VendorBotProtectionEvidenceBuilder> {
  @BuiltValueField(wireName: r'recaptcha_token')
  String? get recaptchaToken;

  /// Must be true when the accessible email step-up method is selected.
  @BuiltValueField(wireName: r'request_email_step_up')
  bool? get requestEmailStepUp;

  VendorBotProtectionEvidence._();

  factory VendorBotProtectionEvidence([void updates(VendorBotProtectionEvidenceBuilder b)]) = _$VendorBotProtectionEvidence;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBotProtectionEvidenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBotProtectionEvidence> get serializer => _$VendorBotProtectionEvidenceSerializer();
}

class _$VendorBotProtectionEvidenceSerializer implements PrimitiveSerializer<VendorBotProtectionEvidence> {
  @override
  final Iterable<Type> types = const [VendorBotProtectionEvidence, _$VendorBotProtectionEvidence];

  @override
  final String wireName = r'VendorBotProtectionEvidence';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBotProtectionEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.recaptchaToken != null) {
      yield r'recaptcha_token';
      yield serializers.serialize(
        object.recaptchaToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.requestEmailStepUp != null) {
      yield r'request_email_step_up';
      yield serializers.serialize(
        object.requestEmailStepUp,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBotProtectionEvidence object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBotProtectionEvidenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recaptcha_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recaptchaToken = valueDes;
          break;
        case r'request_email_step_up':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.requestEmailStepUp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBotProtectionEvidence deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBotProtectionEvidenceBuilder();
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


