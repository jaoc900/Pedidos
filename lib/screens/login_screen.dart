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
import 'package:pedidos/core/network/di/inejction.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determinar el ancho máximo según el tamaño de pantalla
          final maxWidth = constraints.maxWidth > 600 ? 480.0 : double.infinity;

          return Stack(
            children: [
              // Decoración de fondo
              _buildBackgroundDecoration(),
              // Contenido principal
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
                          // Logo y branding
                          _buildBranding(),
                          const SizedBox(height: 32),
                          // Título y subtítulo
                          _buildHeader(),
                          const SizedBox(height: 32),
                          // Formulario
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
        // Campo de email
        CustomTextField(
          controller: _emailController,
          label: 'Correo electrónico',
          hint: 'nombre@empresa.com',
          icon: FontAwesomeIcons.envelope,
          borderRadius: AppTheme.borderRadiusXXl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
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
            onPressed: () {},
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
        PrimaryButton(
          text: 'Ingresar',
          borderRadius: AppTheme.borderRadiusXXl,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
        ),
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
              onPressed: () {
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

  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8, // Space between items
      runSpacing: 8, // Space between lines if they wrap
      children: [
        TextButton(
          onPressed: () {
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
          onPressed: () {
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
          onPressed: () {
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

  Future<void> _login() async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final apiClient = locator<ApiClient>();
      final response = await apiClient.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Guardar token si es necesario
      final token = response['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
      }

      // Cerrar loading
      Navigator.pop(context);

      // Navegar al home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on NetworkExceptions catch (e) {
      // Cerrar loading si estaba abierto
      Navigator.pop(context);

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error inesperado. Intenta nuevamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}