class SettingModel {
  final int id;
  final String name;

  final String valueAr;
  final String valueEng;

  const SettingModel(
      {required this.id,
      required this.name,
      required this.valueAr,
      required this.valueEng});

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        id: json["id"],
        name: json["name"],
        valueAr: json["valueAr"],
        valueEng: json["valueEng"],
      );

  @override
  List<Object?> get props => [id, name, valueAr, valueEng];
}
