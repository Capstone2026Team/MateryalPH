//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:materyalph_api_client/src/date_serializer.dart';
import 'package:materyalph_api_client/src/model/date.dart';

import 'package:materyalph_api_client/src/model/account_type.dart';
import 'package:materyalph_api_client/src/model/admin_invitation_request.dart';
import 'package:materyalph_api_client/src/model/agreement.dart';
import 'package:materyalph_api_client/src/model/agreement_list_envelope.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/auth_envelope.dart';
import 'package:materyalph_api_client/src/model/auth_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/bot_proof_envelope.dart';
import 'package:materyalph_api_client/src/model/bot_proof_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/bot_step_up_error_envelope.dart';
import 'package:materyalph_api_client/src/model/bot_step_up_error_envelope_all_of_errors.dart';
import 'package:materyalph_api_client/src/model/bot_step_up_error_envelope_all_of_errors_all_of_details.dart';
import 'package:materyalph_api_client/src/model/buyer_mobile_google_oidc_start_request.dart';
import 'package:materyalph_api_client/src/model/buyer_mobile_login_request.dart';
import 'package:materyalph_api_client/src/model/buyer_mobile_password_recovery_request.dart';
import 'package:materyalph_api_client/src/model/buyer_mobile_refresh_request.dart';
import 'package:materyalph_api_client/src/model/buyer_mobile_register_request.dart';
import 'package:materyalph_api_client/src/model/csrf_envelope.dart';
import 'package:materyalph_api_client/src/model/csrf_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/email_request.dart';
import 'package:materyalph_api_client/src/model/error_envelope.dart';
import 'package:materyalph_api_client/src/model/fee_assessment.dart';
import 'package:materyalph_api_client/src/model/financial_snapshot.dart';
import 'package:materyalph_api_client/src/model/google_mobile_exchange_request.dart';
import 'package:materyalph_api_client/src/model/google_oidc_start_request.dart';
import 'package:materyalph_api_client/src/model/health_envelope.dart';
import 'package:materyalph_api_client/src/model/health_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/login_request.dart';
import 'package:materyalph_api_client/src/model/material_price_observation.dart';
import 'package:materyalph_api_client/src/model/mfa_code_request.dart';
import 'package:materyalph_api_client/src/model/mfa_enrollment_envelope.dart';
import 'package:materyalph_api_client/src/model/mfa_enrollment_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/mfa_recovery_request.dart';
import 'package:materyalph_api_client/src/model/mfa_status_envelope.dart';
import 'package:materyalph_api_client/src/model/mfa_status_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/password_recovery_request.dart';
import 'package:materyalph_api_client/src/model/password_reset_request.dart';
import 'package:materyalph_api_client/src/model/register_request.dart';
import 'package:materyalph_api_client/src/model/registration_envelope.dart';
import 'package:materyalph_api_client/src/model/registration_envelope_all_of_data.dart';
import 'package:materyalph_api_client/src/model/resend_bot_challenge_request.dart';
import 'package:materyalph_api_client/src/model/success_envelope.dart';
import 'package:materyalph_api_client/src/model/user_identity.dart';
import 'package:materyalph_api_client/src/model/vendor_bot_protection_evidence.dart';
import 'package:materyalph_api_client/src/model/verify_bot_challenge_request.dart';
import 'package:materyalph_api_client/src/model/verify_email_request.dart';

part 'serializers.g.dart';

@SerializersFor([
  AccountType,
  AdminInvitationRequest,
  Agreement,
  AgreementListEnvelope,
  ApiError,
  AuthEnvelope,
  AuthEnvelopeAllOfData,
  BotProofEnvelope,
  BotProofEnvelopeAllOfData,
  BotStepUpErrorEnvelope,
  BotStepUpErrorEnvelopeAllOfErrors,
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails,
  BuyerMobileGoogleOidcStartRequest,
  BuyerMobileLoginRequest,
  BuyerMobilePasswordRecoveryRequest,
  BuyerMobileRefreshRequest,
  BuyerMobileRegisterRequest,
  CsrfEnvelope,
  CsrfEnvelopeAllOfData,
  EmailRequest,
  ErrorEnvelope,
  FeeAssessment,
  FinancialSnapshot,
  GoogleMobileExchangeRequest,
  GoogleOidcStartRequest,
  HealthEnvelope,
  HealthEnvelopeAllOfData,
  LoginRequest,
  MaterialPriceObservation,
  MfaCodeRequest,
  MfaEnrollmentEnvelope,
  MfaEnrollmentEnvelopeAllOfData,
  MfaRecoveryRequest,
  MfaStatusEnvelope,
  MfaStatusEnvelopeAllOfData,
  PasswordRecoveryRequest,
  PasswordResetRequest,
  RegisterRequest,
  RegistrationEnvelope,
  RegistrationEnvelopeAllOfData,
  ResendBotChallengeRequest,
  SuccessEnvelope,$SuccessEnvelope,
  UserIdentity,
  VendorBotProtectionEvidence,
  VerifyBotChallengeRequest,
  VerifyEmailRequest,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ApiError)]),
        () => ListBuilder<ApiError>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(BotStepUpErrorEnvelopeAllOfErrors)]),
        () => ListBuilder<BotStepUpErrorEnvelopeAllOfErrors>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
        () => MapBuilder<String, JsonObject?>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Agreement)]),
        () => ListBuilder<Agreement>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType.nullable(JsonObject)]),
        () => ListBuilder<JsonObject>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(String)]),
        () => ListBuilder<String>(),
      )
      ..add(SuccessEnvelope.serializer)
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
