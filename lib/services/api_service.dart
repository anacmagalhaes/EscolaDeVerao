import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/cached_manager_service.dart';
import 'package:escoladeverao/services/image_cache_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ApiService {
  final String baseUrl = 'https://6607-177-130-172-11.ngrok-free.app';
  late final http.Client _client;
  late Dio _dio;

  ApiService() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    _client = IOClient(httpClient);

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  // Método de Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final userData = decodedResponse['data']['user'];
        final token = decodedResponse['data']['token'];

        if (userData != null && token != null) {
          // Pré-carregar a imagem do usuário
          if (userData['link_completo'] != null) {
            await CachedImageManager()
                .cacheUserImage(userData['link_completo']);
          }

          return {
            'success': true,
            'data': {
              'user': userData,
              'token': token,
            },
          };
        }
      }

      return {
        'success': false,
        'message': 'Login failed',
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': e.toString(),
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
          'message': jsonDecode(response.body)['message'],
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

  Future<String?> getToken() async {
    return await _getToken();
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userData = data['data'] ?? data['user'] ?? data;

        // Construa a URL completa da imagem
        String? imagemUrl = userData['imagem'];
        if (imagemUrl != null && !imagemUrl.startsWith('http')) {
          imagemUrl = '$baseUrl/storage/$imagemUrl';
        }

        return User.fromJson({
          ...userData,
          'imagem': imagemUrl,
        });
      } else {
        throw Exception('Falha ao carregar usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha na conexão com o servidor: $e');
    }
  }

  String getFullImageUrlNew(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If the image path is a file path (e.g., file://), ignore it.
    if (imagePath.startsWith('file://')) {
      return ''; // Or handle it differently depending on your app logic.
    }

    // If it starts with a slash, remove it to prevent double slashes in the URL
    final cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

    // Returns the complete URL with the base URL
    return '$baseUrl/$cleanPath';
  }

  // In your ApiService class, update the updateProfile method to include image handling
  Future<Map<String, dynamic>> updateProfile(
      String userId, Map<String, dynamic> updateData,
      {File? imageFile}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Sessão expirada. Faça login novamente.'
        };
      }

      final url = '$baseUrl/api/user/$userId';

      FormData formData = FormData.fromMap(updateData);

      if (imageFile != null) {
        formData.files.add(MapEntry(
          'imagem', // Make sure this field name matches your API expectation
          await MultipartFile.fromFile(imageFile.path, filename: 'profile.jpg'),
        ));
      }

      final response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        }),
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
          'message': 'Perfil atualizado com sucesso'
        };
      } else {
        return {'success': false, 'message': 'Erro ao atualizar perfil'};
      }
    } catch (e) {
      print('Erro: $e');
      return {'success': false, 'message': 'Erro de conexão. Tente novamente.'};
    }
  }

  // Método para salvar conexão com autenticação JWT
  Future<Map<String, dynamic>> saveConnection(
      String userId, String scannedUserId) async {
    try {
      final token = await _getToken();
      print('Token atual: $token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Sessão expirada. Por favor, faça login novamente.',
        };
      }

      final url = Uri.parse('$baseUrl/api/user/$scannedUserId');
      print('Salvando conexão na URL: $url');
      print('Token: $token'); // Para debug - remover em produção

      final Map<String, dynamic> connectionData = {
        'user_id': userId,
        'connected_user_id': scannedUserId,
      };

      print('Dados enviados: $connectionData');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Garantindo que o token está no formato correto
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'X-Requested-With':
              'XMLHttpRequest', // Adiciona header para APIs Laravel
        },
        // body: jsonEncode(connectionData),
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');
      print(
          'Headers enviados: ${response.request?.headers}'); // Para debug - remover em produção

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return {
          'success': true,
          'data': decodedResponse['data'] ?? decodedResponse,
          'message': 'Conexão salva com sucesso',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sessão expirada. Por favor, faça login novamente.',
          'needsReauth': true
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message':
              'Você não tem permissão para realizar esta ação. Verifique se você está logado corretamente.',
        };
      } else {
        String errorMessage = 'Erro ao salvar conexão';
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (_) {}

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Erro ao salvar conexão: $e');
      return {
        'success': false,
        'message': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

// Método para buscar conexões com autenticação JWT
  Future<List<User>> fetchUserConnections(String userId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception(
            'Token não encontrado. Por favor, faça login novamente.');
      }

      final response = await _client.get(
        Uri.parse('$baseUrl/api/conexao'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token JWT no header
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> connectionsData = decodedResponse['data'] ?? [];
        return connectionsData
            .map((userData) => User.fromJson(userData))
            .toList();
      } else if (response.statusCode == 400) {
        if (decodedResponse['message'] == "Não existem conexões feitas!") {
          print('Nenhuma conexão encontrada.');
          return []; // Retorna lista vazia sem erro
        }
        throw Exception(decodedResponse['message'] ??
            'Erro desconhecido ao buscar conexões.');
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else if (response.statusCode == 403) {
        throw Exception('Email não verificado! Verifique seu email.');
      } else {
        throw Exception(
            'Falha ao carregar conexões: ${decodedResponse['message'] ?? response.body}');
      }
    } catch (e) {
      print('Erro ao buscar conexões: $e');
      throw Exception('Falha na conexão com o servidor: $e');
    }
  }

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If the image path is a file path (e.g., file://), ignore it.
    if (imagePath.startsWith('file://')) {
      return ''; // Or handle it differently depending on your app logic.
    }

    // If it starts with a slash, remove it to prevent double slashes in the URL
    final cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

    // Returns the complete URL with the base URL
    return '$baseUrl/$cleanPath';
  }

  Future<Map<String, dynamic>> createPost({
    required String content,
    required String token,
    required String userId,
    File? imageFile,
  }) async {
    try {
      // Prepare form data
      final formData = FormData();

      // Adiciona os campos de texto
      formData.fields.addAll([
        MapEntry('texto', content),
        MapEntry('user_id', userId),
      ]);

      // Adiciona a imagem se existir
      if (imageFile != null) {
        final fileName = path.basename(imageFile.path);
        final extension = path.extension(fileName).toLowerCase();

        // Cria o MultipartFile com o tipo de conteúdo correto
        final file = await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', extension.replaceAll('.', '')),
        );

        // Adiciona a imagem com a chave correta que o backend espera
        formData.files.add(MapEntry('imagem', file));
      }

      // Configura os headers corretamente
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        // Não definimos Content-Type aqui, o Dio vai configurar automaticamente para multipart/form-data
      };

      // Faz a requisição com logging detalhado
      print('Enviando requisição...');
      print('Headers: $headers');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files}');

      final response = await _dio.post(
        '/api/post',
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
        onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = (sent / total * 100).toStringAsFixed(2);
            print('Progress: $progress%');
          }
        },
      );

      print('Resposta recebida:');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        String? imageUrl;

        // Processa a URL da imagem
        if (responseData['data'] != null) {
          String? imagePath;
          if (responseData['data']['link_direto'] != null) {
            imagePath = responseData['data']['link_direto'];
          } else if (responseData['data']['imagem'] != null) {
            imagePath = responseData['data']['imagem'];
          }

          // Converte o caminho relativo em URL completa
          if (imagePath != null) {
            imageUrl = getFullImageUrl(imagePath);
          }
        }

        return {
          'success': true,
          'message': responseData['message'] ?? 'Post criado com sucesso',
          'image': imageUrl,
          'data': responseData['data'],
        };
      } else {
        print('Erro na resposta: ${response.data}');
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erro ao criar post',
        };
      }
    } on DioException catch (e) {
      print('DioException durante upload:');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Request: ${e.requestOptions.data}');
      print('Headers: ${e.requestOptions.headers}');
      return {'success': false, 'message': 'Erro na requisição: ${e.message}'};
    } catch (e) {
      print('Erro inesperado durante upload: $e');
      return {'success': false, 'message': 'Erro ao criar post'};
    }
  }

  Future<Map<String, dynamic>> changePassword(
      String password, String confirmPassword) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Sessão expirada. Por favor, faça login novamente.',
        };
      }

      final url = Uri.parse('$baseUrl/api/user/update_password');
      print('Enviando solicitação de alteração de senha para URL: $url');

      final Map<String, dynamic> body = {
        'password': password,
        'password_confirmation': confirmPassword,
      };

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Senha alterada com sucesso!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorResponse['message'] ?? 'Erro ao alterar senha.',
        };
      }
    } catch (e) {
      print('Erro ao alterar senha: $e');
      return {
        'success': false,
        'message': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

  Future<Map<String, dynamic>> fetchPosts({int page = 1}) async {
    try {
      final token = await _getToken();
      final response = await _client.get(
        Uri.parse('$baseUrl/api/post?page=$page&include=user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Verifica e formata os dados retornados
        if (decodedResponse['data'] != null &&
            decodedResponse['data']['data'] != null) {
          var posts = decodedResponse['data']['data'] as List;
          for (var post in posts) {
            if (post['link_completo'] != null) {
              post['imagem'] = post['link_completo'];
            }

            // Converte a data para um formato legível
            if (post['created_at'] != null) {
              try {
                DateTime dataOriginal =
                    DateTime.parse(post['created_at']).toLocal();
                post['data_formatada'] =
                    DateFormat('dd/MM/yyyy').format(dataOriginal);
              } catch (e) {
                print("Erro ao converter data: $e");
                post['data_formatada'] = 'Data inválida';
              }
            } else {
              post['data_formatada'] = 'Data desconhecida';
            }
          }
        }

        return decodedResponse;
      } else {
        print('Error response: ${response.body}');
        return {
          'success': false,
          'message': 'Erro ao buscar posts.',
        };
      }
    } catch (e) {
      print('Exception in fetchPosts: $e');
      return {
        'success': false,
        'message': 'Erro de conexão',
      };
    }
  }

  Future<Map<String, dynamic>> fetchEvents() async {
    try {
      final token = await _getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Sessão expirada. Por favor, faça login novamente.',
        };
      }

      final response = await _client.get(
        Uri.parse('$baseUrl/api/eventos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return {
          'success': true,
          'message': decodedResponse['message'],
          'data': decodedResponse['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao buscar eventos: ${response.body}',
        };
      }
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      return {
        'success': false,
        'message': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

  // Não esqueça de fechar o cliente quando não for mais necessário
  void dispose() {
    _client.close();
  }
}
