// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Agreement extends Agreement {
  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String audience;
  @override
  final int version;
  @override
  final String contentUri;
  @override
  final DateTime effectiveAt;

  factory _$Agreement([void Function(AgreementBuilder)? updates]) =>
      (AgreementBuilder()..update(updates))._build();

  _$Agreement._(
      {required this.id,
      required this.code,
      required this.title,
      required this.audience,
      required this.version,
      required this.contentUri,
      required this.effectiveAt})
      : super._();
  @override
  Agreement rebuild(void Function(AgreementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgreementBuilder toBuilder() => AgreementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Agreement &&
        id == other.id &&
        code == other.code &&
        title == other.title &&
        audience == other.audience &&
        version == other.version &&
        contentUri == other.contentUri &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, contentUri.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Agreement')
          ..add('id', id)
          ..add('code', code)
          ..add('title', title)
          ..add('audience', audience)
          ..add('version', version)
          ..add('contentUri', contentUri)
          ..add('effectiveAt', effectiveAt))
        .toString();
  }
}

class AgreementBuilder implements Builder<Agreement, AgreementBuilder> {
  _$Agreement? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _audience;
  String? get audience => _$this._audience;
  set audience(String? audience) => _$this._audience = audience;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _contentUri;
  String? get contentUri => _$this._contentUri;
  set contentUri(String? contentUri) => _$this._contentUri = contentUri;

  DateTime? _effectiveAt;
  DateTime? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(DateTime? effectiveAt) => _$this._effectiveAt = effectiveAt;

  AgreementBuilder() {
    Agreement._defaults(this);
  }

  AgreementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _title = $v.title;
      _audience = $v.audience;
      _version = $v.version;
      _contentUri = $v.contentUri;
      _effectiveAt = $v.effectiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Agreement other) {
    _$v = other as _$Agreement;
  }

  @override
  void update(void Function(AgreementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Agreement build() => _build();

  _$Agreement _build() {
    final _$result = _$v ??
        _$Agreement._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Agreement', 'id'),
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'Agreement', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'Agreement', 'title'),
          audience: BuiltValueNullFieldError.checkNotNull(
              audience, r'Agreement', 'audience'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'Agreement', 'version'),
          contentUri: BuiltValueNullFieldError.checkNotNull(
              contentUri, r'Agreement', 'contentUri'),
          effectiveAt: BuiltValueNullFieldError.checkNotNull(
              effectiveAt, r'Agreement', 'effectiveAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
