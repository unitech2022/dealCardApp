class ScanResponse {
  Scann? scann;
  Market? market;

  ScanResponse({this.scann, this.market});

  ScanResponse.fromJson(Map<String, dynamic> json) {
    scann = json['scann'] != null ? new Scann.fromJson(json['scann']) : null;
    market =
    json['market'] != null ? new Market.fromJson(json['market']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scann != null) {
      data['scann'] = this.scann!.toJson();
    }
    if (this.market != null) {
      data['market'] = this.market!.toJson();
    }
    return data;
  }
}

class Scann {
  int? id;
  String? userId;
  int? marketId;
  int? cardId;
  int? status;
  String? createdAt;

  Scann(
      {this.id,
        this.userId,
        this.marketId,
        this.cardId,
        this.status,
        this.createdAt});

  Scann.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    marketId = json['marketId'];
    cardId = json['cardId'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['marketId'] = this.marketId;
    data['cardId'] = this.cardId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Market {
  int? id;
  int? fieldId;
  int? categoryId;
  String? nameAr;
  String? nameEng;
  String? email;
  String? phone;
  String? aboutAr;
  String? aboutEng;
  String? logoImage;
  String? images;
  int? order;
  String? link;
  String? cardIds;
  int? cityId;
  double? rate;
  int? status;
  double? discount;
  String? createdAt;

  Market(
      {this.id,
        this.fieldId,
        this.categoryId,
        this.nameAr,
        this.nameEng,
        this.email,
        this.phone,
        this.aboutAr,
        this.aboutEng,
        this.logoImage,
        this.images,
        this.order,
        this.link,
        this.cardIds,
        this.cityId,
        this.rate,
        this.status,
        this.discount,
        this.createdAt});

  Market.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldId = json['fieldId'];
    categoryId = json['categoryId'];
    nameAr = json['nameAr'];
    nameEng = json['nameEng'];
    email = json['email'];
    phone = json['phone'];
    aboutAr = json['aboutAr'];
    aboutEng = json['aboutEng'];
    logoImage = json['logoImage'];
    images = json['images'];
    order = json['order'];
    link = json['link'];
    cardIds = json['cardIds'];
    cityId = json['cityId'];
    rate = json['rate'].toDouble();
    status = json['status'];
    discount = json['discount'].toDouble();;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fieldId'] = this.fieldId;
    data['categoryId'] = this.categoryId;
    data['nameAr'] = this.nameAr;
    data['nameEng'] = this.nameEng;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['aboutAr'] = this.aboutAr;
    data['aboutEng'] = this.aboutEng;
    data['logoImage'] = this.logoImage;
    data['images'] = this.images;
    data['order'] = this.order;
    data['link'] = this.link;
    data['cardIds'] = this.cardIds;
    data['cityId'] = this.cityId;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
