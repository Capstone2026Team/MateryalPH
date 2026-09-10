// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthEnvelopeAllOfData extends AuthEnvelopeAllOfData {
  @override
  final UserIdentity? user;
  @override
  final String? sessionId;
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final int? accessExpiresIn;
  @override
  final int? refreshExpiresIn;
  @override
  final bool? mfaSetupRequired;
  @override
  final bool? mfaRequired;
  @override
  final bool? mfaEnrollmentRequired;
  @override
  final int? challengeExpiresIn;
  @override
  final BuiltList<String>? recoveryCodes;

  factory _$AuthEnvelopeAllOfData(
          [void Function(AuthEnvelopeAllOfDataBuilder)? updates]) =>
      (AuthEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$AuthEnvelopeAllOfData._(
      {this.user,
      this.sessionId,
      this.accessToken,
      this.refreshToken,
      this.accessExpiresIn,
      this.refreshExpiresIn,
      this.mfaSetupRequired,
      this.mfaRequired,
      this.mfaEnrollmentRequired,
      this.challengeExpiresIn,
      this.recoveryCodes})
      : super._();
  @override
  AuthEnvelopeAllOfData rebuild(
          void Function(AuthEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthEnvelopeAllOfDataBuilder toBuilder() =>
      AuthEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthEnvelopeAllOfData &&
        user == other.user &&
        sessionId == other.sessionId &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        accessExpiresIn == other.accessExpiresIn &&
        refreshExpiresIn == other.refreshExpiresIn &&
        mfaSetupRequired == other.mfaSetupRequired &&
        mfaRequired == other.mfaRequired &&
        mfaEnrollmentRequired == other.mfaEnrollmentRequired &&
        challengeExpiresIn == other.challengeExpiresIn &&
        recoveryCodes == other.recoveryCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, accessExpiresIn.hashCode);
    _$hash = $jc(_$hash, refreshExpiresIn.hashCode);
    _$hash = $jc(_$hash, mfaSetupRequired.hashCode);
    _$hash = $jc(_$hash, mfaRequired.hashCode);
    _$hash = $jc(_$hash, mfaEnrollmentRequired.hashCode);
    _$hash = $jc(_$hash, challengeExpiresIn.hashCode);
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthEnvelopeAllOfData')
          ..add('user', user)
          ..add('sessionId', sessionId)
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('accessExpiresIn', accessExpiresIn)
          ..add('refreshExpiresIn', refreshExpiresIn)
          ..add('mfaSetupRequired', mfaSetupRequired)
          ..add('mfaRequired', mfaRequired)
          ..add('mfaEnrollmentRequired', mfaEnrollmentRequired)
          ..add('challengeExpiresIn', challengeExpiresIn)
          ..add('recoveryCodes', recoveryCodes))
        .toString();
  }
}

class AuthEnvelopeAllOfDataBuilder
    implements Builder<AuthEnvelopeAllOfData, AuthEnvelopeAllOfDataBuilder> {
  _$AuthEnvelopeAllOfData? _$v;

  UserIdentityBuilder? _user;
  UserIdentityBuilder get user => _$this._user ??= UserIdentityBuilder();
  set user(UserIdentityBuilder? user) => _$this._user = user;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  int? _accessExpiresIn;
  int? get accessExpiresIn => _$this._accessExpiresIn;
  set accessExpiresIn(int? accessExpiresIn) =>
      _$this._accessExpiresIn = accessExpiresIn;

  int? _refreshExpiresIn;
  int? get refreshExpiresIn => _$this._refreshExpiresIn;
  set refreshExpiresIn(int? refreshExpiresIn) =>
      _$this._refreshExpiresIn = refreshExpiresIn;

  bool? _mfaSetupRequired;
  bool? get mfaSetupRequired => _$this._mfaSetupRequired;
  set mfaSetupRequired(bool? mfaSetupRequired) =>
      _$this._mfaSetupRequired = mfaSetupRequired;

  bool? _mfaRequired;
  bool? get mfaRequired => _$this._mfaRequired;
  set mfaRequired(bool? mfaRequired) => _$this._mfaRequired = mfaRequired;

  bool? _mfaEnrollmentRequired;
  bool? get mfaEnrollmentRequired => _$this._mfaEnrollmentRequired;
  set mfaEnrollmentRequired(bool? mfaEnrollmentRequired) =>
      _$this._mfaEnrollmentRequired = mfaEnrollmentRequired;

  int? _challengeExpiresIn;
  int? get challengeExpiresIn => _$this._challengeExpiresIn;
  set challengeExpiresIn(int? challengeExpiresIn) =>
      _$this._challengeExpiresIn = challengeExpiresIn;

  ListBuilder<String>? _recoveryCodes;
  ListBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= ListBuilder<String>();
  set recoveryCodes(ListBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  AuthEnvelopeAllOfDataBuilder() {
    AuthEnvelopeAllOfData._defaults(this);
  }

  AuthEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user?.toBuilder();
      _sessionId = $v.sessionId;
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _accessExpiresIn = $v.accessExpiresIn;
      _refreshExpiresIn = $v.refreshExpiresIn;
      _mfaSetupRequired = $v.mfaSetupRequired;
      _mfaRequired = $v.mfaRequired;
      _mfaEnrollmentRequired = $v.mfaEnrollmentRequired;
      _challengeExpiresIn = $v.challengeExpiresIn;
      _recoveryCodes = $v.recoveryCodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthEnvelopeAllOfData other) {
    _$v = other as _$AuthEnvelopeAllOfData;
  }

  @override
  void update(void Function(AuthEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthEnvelopeAllOfData build() => _build();

  _$AuthEnvelopeAllOfData _build() {
    _$AuthEnvelopeAllOfData _$result;
    try {
      _$result = _$v ??
          _$AuthEnvelopeAllOfData._(
            user: _user?.build(),
            sessionId: sessionId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessExpiresIn: accessExpiresIn,
            refreshExpiresIn: refreshExpiresIn,
            mfaSetupRequired: mfaSetupRequired,
            mfaRequired: mfaRequired,
            mfaEnrollmentRequired: mfaEnrollmentRequired,
            challengeExpiresIn: challengeExpiresIn,
            recoveryCodes: _recoveryCodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();

        _$failedField = 'recoveryCodes';
        _recoveryCodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AuthEnvelopeAllOfData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
