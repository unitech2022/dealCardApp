import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final int id;
  final String nameAr;

  final String nameEng;

  const CityModel({
    required this.id,
    required this.nameAr,
    required this.nameEng,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        nameAr: json["nameAr"],
        nameEng: json["nameEng"],
      );

  @override
  List<Object?> get props => [id, nameAr, nameEng];
}
