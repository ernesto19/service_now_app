class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String token;

  User({
    this.id,
    this.firstName,
    this.email,
    this.token
  });

  User.fromJson(dynamic json) {
    id        = json['id'];
    firstName = json['first_name'];
    lastName  = json['last_name'];
    email     = json['email'];
    token     = json['token'];
  }
}

class LoginResponse {
  int error;
  String message;
  User data;

  LoginResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = new User.fromJson(json['data']);
    }
  }
}

/*
{
    "id": 1,
    "name": null,
    "email": "ernestochirat@gmail.com"
}
 */