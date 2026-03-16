import 'package:echoemaar_commerce/features/checkout/domain/entities/country_state.dart';

class CountryStateModel extends CountryState {
  const CountryStateModel({
    required super.id,
    required super.name,
    required super.code,
    required super.countryId,
    super.countryName,
  });

  // ── Manual JSON Deserialization ────────────────────────────────────
  factory CountryStateModel.fromJson(Map<String, dynamic> json) {
    return CountryStateModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      countryId: json['country_id'] as int? ?? 0,
      countryName: json['country_name'] as String?,
    );
  }

  // ── Manual JSON Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'country_id': countryId,
      'country_name': countryName,
    };
  }

  // ── CopyWith Method ────────────────────────────────────────────────
  CountryStateModel copyWith({
    int? id,
    String? name,
    String? code,
    int? countryId,
    String? countryName,
  }) {
    return CountryStateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
    );
  }
}