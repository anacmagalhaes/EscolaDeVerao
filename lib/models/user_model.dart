import 'package:escoladeverao/models/role_model.dart';

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
  final String? cargo;
  final List<Role> roles; // Removido o nullable (?)

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
    this.cargo,
    required this.roles, // Adicionado required
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
      cargo: json['cargo'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((role) => Role.fromJson(role)).toList()
          : [], // Retorna lista vazia se roles for null
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
      'cargo': cargo,
    };
  }

  bool get isAdmin => roles.any((role) => role.name == 'admin');
  bool get isUser => roles.any((role) => role.name == 'usuario');
}
