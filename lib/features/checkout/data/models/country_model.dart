import 'package:echoemaar_commerce/features/checkout/domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    required super.name,
    required super.code,
    required super.phoneCode,
  });

  // ── Manual JSON Deserialization ────────────────────────────────────
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      phoneCode: (json['phone_code'] as num?)?.toInt() ?? 0,
    );
  }

  // ── Manual JSON Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone_code': phoneCode,
    };
  }

  // ── CopyWith Method ────────────────────────────────────────────────
  CountryModel copyWith({
    int? id,
    String? name,
    String? code,
    int? phoneCode,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      phoneCode: phoneCode ?? this.phoneCode,
    );
  }
}