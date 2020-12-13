class Promotion {
  int id;
  int businessId;
  String name;
  String description;
  String amount;
  String type;
  int active;

  Promotion({
    this.id,
    this.businessId,
    this.name,
    this.description,
    this.amount,
    this.type,
    this.active
  });

  Promotion.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id            = json['id'];
    businessId    = json['business_id'] ?? 0;
    name          = json['name']        ?? '';
    description   = json['description'] ?? '';
    amount        = json['amount']      ?? '';
    type          = json['type']        ?? 0;
    active        = json['active']      ?? 0;
  }
}

class PromotionResponse {
  int error;
  String message;
  List<Promotion> data = List();

  PromotionResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final promotion = Promotion.fromJson(item);
        data.add(promotion);
      }
    }
  }
}