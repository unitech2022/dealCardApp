import 'package:json_annotation/json_annotation.dart';
part 'business_owners_model.g.dart';
@JsonSerializable()
class  BusinessOwnersModel {

final int id ;
final String userId;
final String firstName;
final String lastName;
final String nameMarket;
final String phone;
final String numberInvoice;
final int  status;
final String createAt;

  BusinessOwnersModel({required this.id, required this.userId, required this.firstName, required this.lastName, required this.nameMarket, required this.phone, required this.numberInvoice, required this.status, required this.createAt});


factory BusinessOwnersModel.fromJson(Map<String, dynamic> json) =>
    _$BusinessOwnersModelFromJson(json);



Map<String, dynamic> toJson() => _$BusinessOwnersModelToJson(this);
}

