// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_step_up_error_envelope_all_of_errors_all_of_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails
    extends BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails {
  @override
  final String challengeId;
  @override
  final DateTime expiresAt;
  @override
  final int resendAfterSeconds;

  factory _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails(
          [void Function(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder)?
              updates]) =>
      (BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder()..update(updates))
          ._build();

  _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails._(
      {required this.challengeId,
      required this.expiresAt,
      required this.resendAfterSeconds})
      : super._();
  @override
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails rebuild(
          void Function(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder toBuilder() =>
      BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails &&
        challengeId == other.challengeId &&
        expiresAt == other.expiresAt &&
        resendAfterSeconds == other.resendAfterSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, resendAfterSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails')
          ..add('challengeId', challengeId)
          ..add('expiresAt', expiresAt)
          ..add('resendAfterSeconds', resendAfterSeconds))
        .toString();
  }
}

class BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder
    implements
        Builder<BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails,
            BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder> {
  _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails? _$v;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  int? _resendAfterSeconds;
  int? get resendAfterSeconds => _$this._resendAfterSeconds;
  set resendAfterSeconds(int? resendAfterSeconds) =>
      _$this._resendAfterSeconds = resendAfterSeconds;

  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder() {
    BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails._defaults(this);
  }

  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeId = $v.challengeId;
      _expiresAt = $v.expiresAt;
      _resendAfterSeconds = $v.resendAfterSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails other) {
    _$v = other as _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails;
  }

  @override
  void update(
      void Function(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails build() => _build();

  _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails _build() {
    final _$result = _$v ??
        _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails._(
          challengeId: BuiltValueNullFieldError.checkNotNull(challengeId,
              r'BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails', 'challengeId'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(expiresAt,
              r'BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails', 'expiresAt'),
          resendAfterSeconds: BuiltValueNullFieldError.checkNotNull(
              resendAfterSeconds,
              r'BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails',
              'resendAfterSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
