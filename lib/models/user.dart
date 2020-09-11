class User {
  String name;
  String email;

  User({
    this.name,
    this.email
  });

  User.fromJsonMap(dynamic json) {
    name  = json['name'];
    email = json['email'];
  }
}