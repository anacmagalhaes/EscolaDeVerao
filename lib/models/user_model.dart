class User {
  final String id;
  final String name;
  final String? sobrenome;
  final String? email;
  final String? cpf;
  final String? telefone;
  final String? github;
  final String? linkedin;
  final String? lattes;

  User({
    required this.id,
    required this.name,
    this.sobrenome,
    this.email,
    this.cpf,
    this.telefone,
    this.github,
    this.linkedin,
    this.lattes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      sobrenome: json['sobrenome'],
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      telefone: json['telefone'],
      github: json['github'],
      linkedin: json['linkedin'],
      lattes: json['lattes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sobrenome': sobrenome,
      'email': email,
      'cpf': cpf,
      'telefone': telefone,
      'github': github,
      'linkedin': linkedin,
      'lattes': lattes,
    };
  }
}
