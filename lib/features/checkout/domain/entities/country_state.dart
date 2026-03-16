import 'package:equatable/equatable.dart';

class CountryState extends Equatable {
  final int id;
  final String name;
  final String code;
  final int countryId;
  final String? countryName;

  const CountryState({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
    this.countryName,
  });

  @override
  List<Object?> get props => [id, name, code, countryId, countryName];
}