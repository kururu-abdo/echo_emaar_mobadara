import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final int id;
  final String name;
  final String code;
  final int phoneCode;

  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
  });

  // Useful for the phone prefix display
  String get fullPhonePrefix => '+$phoneCode';

  @override
  List<Object?> get props => [id, name, code, phoneCode];
}