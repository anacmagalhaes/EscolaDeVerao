import 'dart:convert';
import 'dart:io';

import 'package:escoladeverao/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://21a8-177-130-172-153.ngrok-free.app';
  late final http.Client _client;
  User? currentUser; // Inicializado como null

  ApiService() {
    // Configurar um cliente HTTP personalizado que aceita certificados inválidos
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    _client = IOClient(httpClient);
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    print('Tentando login na URL: $url');

    try {
      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      print('Dados enviados: $body');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
        body: jsonEncode(body),
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print('Resposta decodificada: $decodedResponse');

        final userData = decodedResponse['data']['user'];
        final token = decodedResponse['data']['token'];

        if (token != null && userData != null) {
          return {
            'success': true,
            'data': {
              'user': userData,
              'token': token, // Simplificado, sem o nível adicional de "data"
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Token ou dados do usuário não encontrados na resposta.',
          };
        }
      } else {
        print(
            'Erro no login. Status: ${response.statusCode}, Body: ${response.body}');
        return {
          'success': false,
          'message': 'Erro no login: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e, stackTrace) {
      print('Exceção durante o login: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Erro ao conectar com a API: $e',
      };
    }
  }

  //método de cadastro
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/register');
    print('Tentando cadastro na URL: $url');

    try {
      print('Dados enviados: $userData');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
        body: jsonEncode(userData),
      );
      print('Status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        print('Resposta decodificada: $decodedResponse');
        return {
          'success': true,
          'data': decodedResponse,
        };
      } else {
        print(
            'Erro no cadastro. Status: ${response.statusCode}, Body: ${response.body}');
        return {
          'success': false,
          'message':
              'Erro no cadastro: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e, stackTrace) {
      print('Exceção durante o cadastro: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Erro ao conectar com a API: $e',
      };
    }
  }

  //método de recuperação de senha
  Future<Map<String, dynamic>> resetPasswordWithCpfEmail(
      String cpf, String email) async {
    final url = Uri.parse('$baseUrl/api/user/forgot_password');
    print('Enviando pedido de recuperação de senha para URL: $url');

    try {
      final Map<String, dynamic> body = {
        'cpf': cpf,
        'email': email,
      };

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return {
          'success': true,
          'message': decodedResponse['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao redefinir senha: ${response.body}',
        };
      }
    } catch (e, stackTrace) {
      print('Exceção ao redefinir senha: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Erro ao conectar com a API: $e',
      };
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<User> fetchUserById(String userId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await _client.get(
        Uri.parse('$baseUrl/api/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Verificar se os dados estão dentro de uma chave 'data' ou 'user'
        final userData = data['data'] ?? data['user'] ?? data;
        return User.fromJson(userData);
      } else {
        throw Exception('Falha ao carregar usuário: ${response.body}');
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      throw Exception('Falha na conexão com o servidor: $e');
    }
  }

  // Não esqueça de fechar o cliente quando não for mais necessário
  void dispose() {
    _client.close();
  }
}
