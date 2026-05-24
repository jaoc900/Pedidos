import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/register_screen.dart';
import 'package:pedidos/screens/admin_dashboard.dart';
import 'package:pedidos/screens/admin_home_screen.dart';
import 'package:pedidos/screens/employee_home.dart';

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
          top: 0,
          right: 0,
          child: Opacity(
            opacity: 0.05,
            child: FaIcon(
              FontAwesomeIcons.seedling,
              size: MediaQuery.of(context).size.width * 0.8,
              color: AppTheme.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Opacity(
            opacity: 0.05,
            child: FaIcon(
              FontAwesomeIcons.leaf,
              size: MediaQuery.of(context).size.width * 0.8,
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
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(
              color: AppTheme.onSurfaceVariant,
            ),
            prefixIcon: FaIcon(
              FontAwesomeIcons.envelope,
              size: 20,
              color: AppTheme.outline,
            ),
            hintText: 'nombre@empresa.com',
          ),
        ),
        const SizedBox(height: 24),
        // Campo de contraseña
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
              color: AppTheme.onSurfaceVariant,
            ),
            prefixIcon: FaIcon(
              FontAwesomeIcons.lock,
              size: 20,
              color: AppTheme.outline,
            ),
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
            hintText: '••••••••',
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
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
        const SizedBox(height: 32),
        // Botón de login
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeHome(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.loginButtonColor,
            foregroundColor: AppTheme.onPrimary,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Ingresar'),
              SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.arrowRight, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 32),
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
                    builder: (context) => const RegisterScreen(), // Asegúrate de importar RegisterScreen
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
        const SizedBox(height: 32),
        // Footer
        _buildFooter(),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade500,
            textStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Términos de servicio'),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade500,
            textStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Política de privacidad'),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
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
}