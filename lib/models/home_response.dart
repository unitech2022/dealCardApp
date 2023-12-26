import 'package:deal_card/models/city_model.dart';
import 'package:deal_card/models/field.dart';
import 'package:deal_card/models/offer.dart';
import 'package:deal_card/models/setting_model.dart';
import 'package:deal_card/models/setting_model.dart';
import 'package:deal_card/models/setting_model.dart';
import 'package:equatable/equatable.dart';

class HomeResponse extends Equatable {
  final List<OfferModel> offers;
  final List<FieldModel> fields;
  final List<CityModel> cities;
  final SettingModel codeMarkets;
  final SettingModel callUsNumber;
  final SettingModel cardDetails;
  final SettingModel pravicy;
  final int countAlerts;

  const HomeResponse(
      {required this.countAlerts,
      this.offers = const [],
      required this.codeMarkets,
      this.fields = const [],
      this.cities = const [],
      required this.callUsNumber,
      required this.cardDetails,
      required this.pravicy});

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
      offers: List<OfferModel>.from(
          (json["offers"] as List).map((e) => OfferModel.fromJson(e))),
      fields: List<FieldModel>.from(
          (json["fields"] as List).map((e) => FieldModel.fromJson(e))),
      cities: List<CityModel>.from(
          (json["cities"] as List).map((e) => CityModel.fromJson(e))),
      codeMarkets: SettingModel.fromJson(json["codeMarkets"]),
      callUsNumber: SettingModel.fromJson(json["callUsNumber"]),
      cardDetails: SettingModel.fromJson(json["cardDetails"]),
      pravicy: SettingModel.fromJson(json["pravicy"]),
      countAlerts: json["countAlerts"]);

  @override
  List<Object?> get props =>
      [offers, fields, codeMarkets, callUsNumber, countAlerts, pravicy];
}
