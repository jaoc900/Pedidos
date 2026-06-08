import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/register_screen.dart';
import 'package:pedidos/screens/home.dart';
import 'package:pedidos/screens/terms_conditions_screen.dart';
import 'package:pedidos/screens/privacy_policy_screen.dart';
import 'package:pedidos/screens/contact_screen.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/models/Response/login_response.dart';
import 'package:pedidos/services/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Variables para errores de los campos
  String? _emailError;
  String? _passwordError;

  // Variables para errores generales
  String? _generalError;

  // Clientes HTTP
  late ApiClient _apiClient;
  late UserPreferences _userPrefs;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // Inicializar UserPreferences
      final userPrefs = UserPreferences();
      await userPrefs.init();

      // Cargar credenciales guardadas
      await _loadSavedCredentials(userPrefs);

      // Inicializar API client
      final httpClient = HttpClient();
      _apiClient = ApiClient(httpClient);
      _userPrefs = userPrefs;

      print('✅ Inicialización completada');
    } catch (e) {
      print('Error en inicialización: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Limpiar errores cuando el usuario empieza a escribir
  void _clearEmailError() {
    if (_emailError != null) {
      setState(() {
        _emailError = null;
        _generalError = null;
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
        _generalError = null;
      });
    }
  }

  Future<void> _loadSavedCredentials(UserPreferences userPrefs) async {
    try {
      final rememberMe = userPrefs.getRememberMe();
      final savedEmail = userPrefs.getSavedEmail();

      if (rememberMe && savedEmail != null && savedEmail.isNotEmpty) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
        print('✅ Credenciales cargadas para: $savedEmail');
      }
    } catch (e) {
      print('Error al cargar credenciales: $e');
    }
  }

  Future<void> _login() async {
    if (_isLoading) return;

    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
      _isLoading = true;
    });

    // Validar email
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Por favor ingresa tu correo electrónico';
        _isLoading = false;
      });
      return;
    }

    // Validar contraseña
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Por favor ingresa tu contraseña';
        _isLoading = false;
      });
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );/*
    try {
      final response = await _apiClient.login(email, password);
      final loginResponse = LoginResponse.fromJson(response);

      if (!loginResponse.success || loginResponse.data == null) {
        throw Exception('Error en el login');
      }

      final userData = loginResponse.data!;

      // Guardar toda la información usando UserPreferences
      await _userPrefs.saveUserInfo(userData);
      await _userPrefs.saveRememberMe(_rememberMe, email: email);

      // Mostrar mensaje de bienvenida
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido ${userData.fullName}!'),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navegar al home
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      }
    } on NetworkExceptions catch (e) {
      _processBackendError(e);
    } catch (e) {
      setState(() {
        _generalError = 'Error al iniciar sesión. Intenta nuevamente.';
      });
      print('Error en login: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }*/
  }

  // Método para procesar errores del backend
  void _processBackendError(NetworkExceptions error) {
    final errorMessage = error.message.toLowerCase();

    // Error de credenciales inválidas
    if (errorMessage.contains('credenciales') ||
        errorMessage.contains('invalid') ||
        (errorMessage.contains('email') && errorMessage.contains('password'))) {
      setState(() {
        _generalError = 'Correo o contraseña incorrectos';
        _passwordError = 'Contraseña incorrecta';
      });
    }
    // Error de email no registrado
    else if (errorMessage.contains('email') &&
        (errorMessage.contains('not found') || errorMessage.contains('no existe'))) {
      setState(() {
        _emailError = 'Este correo no está registrado';
      });
    }
    // Error de cuenta inactiva
    else if (errorMessage.contains('inactiva') || errorMessage.contains('inactive')) {
      setState(() {
        _generalError = 'Tu cuenta está inactiva. Contacta a soporte.';
      });
    }
    // Error de usuario bloqueado
    else if (errorMessage.contains('bloqueado') || errorMessage.contains('blocked')) {
      setState(() {
        _generalError = 'Tu cuenta ha sido bloqueada. Contacta a soporte.';
      });
    }
    // Otros errores
    else {
      setState(() {
        _generalError = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 600 ? 480.0 : double.infinity;

          return Stack(
            children: [
              _buildBackgroundDecoration(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                        minWidth: maxWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildBranding(),
                          const SizedBox(height: 32),
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Stack(
      children: [
        Positioned(
          top: 40,
          right: 40,
          child: Opacity(
            opacity: 0.05,
            child: FaIcon(
              FontAwesomeIcons.fileInvoice,
              size: MediaQuery.of(context).size.width * 0.3,
              color: AppTheme.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 40,
          child: Opacity(
            opacity: 0.05,
            child: FaIcon(
              FontAwesomeIcons.truck,
              size: MediaQuery.of(context).size.width * 0.3,
              color: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranding() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.seedling,
          size: 48,
          color: AppTheme.primary,
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppTheme.primary,
              AppTheme.primaryContainer,
            ],
          ).createShader(bounds),
          child: Text(
            'App',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Bienvenido de nuevo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa tus credenciales para acceder a tu panel.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Error general (si existe)
        if (_generalError != null)
          Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingLg),
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.errorContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
              border: Border.all(color: AppTheme.error, width: 1),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  size: 18,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _generalError!,
                    style: const TextStyle(
                      color: AppTheme.error,
                      fontSize: AppTheme.fontSizeSmall,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _generalError = null;
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 14,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),

        // Campo de email
        CustomTextField(
          controller: _emailController,
          label: 'Correo electrónico',
          hint: 'nombre@empresa.com',
          icon: FontAwesomeIcons.envelope,
          borderRadius: AppTheme.borderRadiusXXl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: _emailError,
          onChanged: (value) => _clearEmailError(),
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Campo de contraseña
        CustomTextField(
          controller: _passwordController,
          label: 'Contraseña',
          hint: '••••••••',
          icon: FontAwesomeIcons.lock,
          borderRadius: AppTheme.borderRadiusXXl,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          errorText: _passwordError,
          onChanged: (value) => _clearPasswordError(),
          suffixIcon: IconButton(
            icon: FaIcon(
              _obscurePassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              size: 18,
              color: AppTheme.outline,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),

        // Olvidaste contraseña
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _showForgotPasswordDialog,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(vertical: 12),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),

        // Recordarme
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppTheme.primary,
              side: BorderSide(color: AppTheme.outline),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
              },
              child: Text(
                'Recordar este dispositivo',
                style: TextStyle(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingLg),

        // Botón de login con loading integrado
        _buildLoginButton(),

        const SizedBox(height: AppTheme.spacingXl),

        // Link de registro
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No tienes una cuenta? ',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Regístrate',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingXl),

        // Footer
        _buildFooter(),
      ],
    );
  }

  // Nuevo widget para el botón con loading
  Widget _buildLoginButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXXl),
          ),
          disabledBackgroundColor: AppTheme.primary.withOpacity(0.6),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Ingresar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade500,
            textStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Términos de servicio'),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade500,
            textStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Política de privacidad'),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade500,
            textStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Contacto'),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: const Text(
          'Por favor contacta a soporte para recuperar tu contraseña.\n\n'
              'Email: soporte@empresa.com\n'
              'Tel: (55) 1234-5678',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}