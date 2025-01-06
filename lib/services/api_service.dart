import 'dart:convert';
import 'dart:io';
import 'package:escoladeverao/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiService {
  final String baseUrl = 'https://dba1-177-36-196-227.ngrok-free.app';
  late final http.Client _client;
  User? currentUser;

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
      // Log dos dados sendo enviados
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
        return {
          'success': true,
          'data': decodedResponse,
        };
      } else {
        print(
            'Erro no login. Status: ${response.statusCode}, Body: ${response.body}');
        return {
          'success': false,
          'message': 'Erro no login: ${response.statusCode}',
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

  // Não esqueça de fechar o cliente quando não for mais necessário
  void dispose() {
    _client.close();
  }
}
