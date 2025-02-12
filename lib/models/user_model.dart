import 'package:escoladeverao/models/role_model.dart';

class User {
  final String id;
  final String name;
  final String? sobrenome;
  final String? email;
  final String? cpf;
  final String? telefone;
  final String? imagemUrl;
  final String? github;
  final String? linkedin;
  final String? lattes;
  final String? cargo;
  final List<Role> roles;
  bool? _overrideAdminStatus;

  User(
      {required this.id,
      required this.name,
      this.sobrenome,
      this.email,
      this.cpf,
      this.telefone,
      this.imagemUrl,
      this.github,
      this.linkedin,
      this.lattes,
      this.cargo,
      required this.roles,
      bool? overrideAdminStatus})
      : _overrideAdminStatus = overrideAdminStatus;

  factory User.fromJson(Map<String, dynamic> json,
      {bool? overrideAdminStatus}) {
    return User(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        sobrenome: json['sobrenome'],
        email: json['email'] ?? '',
        cpf: json['cpf'] ?? '',
        telefone: json['phone'],
        imagemUrl: json['imagem'],
        github: json['github'],
        linkedin: json['linkedin'],
        lattes: json['lattes'],
        cargo: json['cargo'],
        roles: json['roles'] != null
            ? (json['roles'] as List)
                .map((role) => Role.fromJson(role))
                .toList()
            : [],
        overrideAdminStatus: overrideAdminStatus);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sobrenome': sobrenome,
      'email': email,
      'cpf': cpf,
      'phone': telefone,
      'github': github,
      'linkedin': linkedin,
      'lattes': lattes,
      'cargo': cargo,
    };
  }

  bool get isAdmin {
    if (_overrideAdminStatus != null) return _overrideAdminStatus!;
    return roles.any((role) => role.name == 'admin');
  }

  void setAdminOverride(bool status) {
    _overrideAdminStatus = status;
  }
}
