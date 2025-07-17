class CreateUserModel {
  final String name;
  final String username;
  final String password;

  CreateUserModel({
    required this.name,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
    };
  }
}
  