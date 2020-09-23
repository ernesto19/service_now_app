class Category {
  int id;
  String name;
  String poster;
  bool favorite;

  Category({
    this.id,
    this.name,
    this.poster,
    this.favorite
  });

  Category.fromJson(Map<String, dynamic> json) {
    id      = json['id'];
    name    = json['name'];
    poster  = json['logo'] ?? '';
    favorite = json['favorite'] == 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id'      : this.id,
      'name'    : this.name,
      'poster'  : this.poster
    };
  }
}

class CategoryResponse {
  int error;
  String message;
  List<Category> data = List();

  CategoryResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final request = Category.fromJson(item);
        data.add(request);
      }
    }
  }
}