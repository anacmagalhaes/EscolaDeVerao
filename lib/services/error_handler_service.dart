import 'package:escoladeverao/modals/error_modal.dart';
import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:escoladeverao/widgets/custom_app_bar.dart';
import 'package:escoladeverao/widgets/custom_app_bar_error.dart';
import 'package:escoladeverao/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error,
      {VoidCallback? onRetry}) {
    if (error is Map) {
      _handleMapError(context, error, onRetry: onRetry);
    } else if (error is String) {
      _showErrorModal(context, error, onRetry: onRetry);
    } else {
      _showGenericErrorModal(context, onRetry: onRetry);
    }
  }

  static void _handleMapError(BuildContext context, Map error,
      {VoidCallback? onRetry}) {
    final errorMessage = error['message'] ?? 'Erro desconhecido';
    final errorType = _categorizeError(error);

    switch (errorType) {
      case ErrorType.authentication:
        _handleAuthenticationError(context, errorMessage);
        break;
      case ErrorType.validation:
        _showValidationErrorModal(context, errorMessage);
        break;
      case ErrorType.network:
        _showNetworkErrorModal(context, errorMessage);
        break;
      case ErrorType.permission:
        _showPermissionErrorModal(context, errorMessage);
        break;
      case ErrorType.profile:
        _showProfileErrorModal(context, errorMessage);
        break;

      default:
        _showErrorModal(context, errorMessage, onRetry: onRetry);
    }
  }

  static ErrorType _categorizeError(Map error) {
    final message = error['message']?.toString().toLowerCase() ?? '';

    if (message.contains('autenticação') || message.contains('token'))
      return ErrorType.authentication;
    if (message.contains('campo') || message.contains('validação'))
      return ErrorType.validation;
    if (message.contains('conexão') || message.contains('servidor'))
      return ErrorType.network;
    if (message.contains('permissão')) return ErrorType.permission;
    if (message.contains('perfil')) return ErrorType.profile;

    return ErrorType.generic;
  }

  static void _handleAuthenticationError(BuildContext context, String message) {
    if (Navigator.of(context).mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  static void _showValidationErrorModal(BuildContext context, String message) {
    ErrorModal(context, errorMessage: message, title: 'Erro de validação');
  }

  static void _showNetworkErrorModal(BuildContext context, String message) {
    ErrorModal(context, errorMessage: message, title: 'Erro de conexão');
  }

  static void _showPermissionErrorModal(BuildContext context, String message) {
    ErrorModal(context, errorMessage: message, title: 'Erro de Permissão');
  }

   static void _showProfileErrorModal(BuildContext context, String message) {
    ErrorModal(context, errorMessage: message, title: 'Erro de perfil');
  }

  static void _showErrorModal(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    ErrorModal(context, errorMessage: message, title: 'Erro desconhecido');
  }

  static void _showGenericErrorModal(BuildContext context,
      {VoidCallback? onRetry}) {
    ErrorModal(context,
        errorMessage: 'Erro inesperado. Tente novamente', title: 'Erro');
  }

  static void showFullScreenError(
      BuildContext context, String message, String imagePath,
      {VoidCallback? onRetry}) {
    if (Navigator.of(context).mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ErrorScreen(
            message: message,
            imagePath: imagePath,
            onRetry: onRetry,
          ),
        ),
      );
    }
  }
}

class ErrorScreen extends StatefulWidget {
  final String message;
  final String imagePath;
  final VoidCallback? onRetry;

  const ErrorScreen({
    Key? key,
    required this.message,
    required this.imagePath,
    this.onRetry,
  }) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  void _retry() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => ErrorScreen(
                message: widget.message,
                imagePath: widget.imagePath,
                onRetry: widget.onRetry,
              )),
    );

    if (widget.onRetry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onRetry!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBackPressed: () {
        Navigator.of(context).pop();
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.imagePath, width: 300, height: 300),
            SizedBox(height: 20),
            Text(
              'Sem conexões',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              text: 'Tentar novamente',
              height: 56.h,
              buttonFonts: const Fonts(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.background),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              buttonStyle: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.orangePrimary),
                  backgroundColor: AppColors.orangePrimary),
              onPressed: _retry,
            ),
          ],
        ),
      ),
    );
  }
}

enum ErrorType {
  authentication,
  validation,
  network,
  permission,
  generic,
  profile
}
