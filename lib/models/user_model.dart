class User {
  final String name;
  final String? sobrenome;
  final String id;
  final String? email;
  final String? phone;
  final String? github;
  final String? linkedin;
  final String? lattes;

  User(
      {required this.name,
      this.sobrenome,
      required this.id,
      this.email,
      this.github,
      this.linkedin,
      this.phone,
      this.lattes});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      sobrenome: json['sobrenome'] ?? '',
      email: json['email'] ?? '',
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      github: json['github'] ?? '',
      linkedin: json['linkedin'] ?? '',
      lattes: json['lattes'] ?? '',
    );
  }
}
