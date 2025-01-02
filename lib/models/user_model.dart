class User {
  final String name;
  final String? sobrenome;
  final String id;

  User({
    required this.name,
    this.sobrenome,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      sobrenome: json['sobrenome'] ?? '',
      id: json['id']?.toString() ?? '',
    );
  }
}