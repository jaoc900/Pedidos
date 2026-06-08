import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/widgets/primary_button.dart';
import 'package:pedidos/enums/botton_status_enum.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  ButtonState _buttonState = ButtonState.active;

  // Map para almacenar errores del backend
  final Map<String, String?> _backendErrors = {
    'firstName': null,
    'lastName': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
  };

// Método para validar la fortaleza de la contraseña en tiempo real
  void _validatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) return;

    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    if (!hasMinLength || !hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar) {
      // Opcional: Mostrar un indicador visual de la fortaleza de la contraseña
      print('Contraseña débil - Requisitos faltantes:');
      if (!hasMinLength) print('- Mínimo 8 caracteres');
      if (!hasUppercase) print('- Una mayúscula');
      if (!hasLowercase) print('- Una minúscula');
      if (!hasNumber) print('- Un número');
      if (!hasSpecialChar) print('- Un carácter especial');
    }
  }

  // Clientes HTTP
  late ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    // Inicializar los clientes manualmente
    final httpClient = HttpClient();
    _apiClient = ApiClient(httpClient);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _buttonState = ButtonState.loading;
    });

    final userData = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    try {
      final response = await _apiClient.register(userData);

      if (mounted) {
        setState(() {
          _buttonState = ButtonState.active;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Registro exitoso! Por favor inicia sesión.'),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _buttonState = ButtonState.active;
        });

        _processBackendError(e);
      }
    }
  }

// Procesar errores del backend
  void _processBackendError(dynamic error) {
    print('🔍 Procesando error: $error');

    try {
      final errorStr = error.toString();

      // Error de contraseña
      if (errorStr.contains('La contraseña debe tener al menos 8 caracteres')) {
        setState(() {
          _backendErrors['password'] = 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
        });
        _formKey.currentState?.validate();

        // Mostrar diálogo con requisitos
        _showPasswordRequirementsDialog();
      }
      // Error de email duplicado
      else if (errorStr.contains('email') && errorStr.contains('already')) {
        setState(() {
          _backendErrors['email'] = 'Este correo electrónico ya está registrado';
        });
        _formKey.currentState?.validate();
      }
      // Error general
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorStr.replaceFirst('Exception: ', '')),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (parseError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: ${error.toString()}'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

// Mostrar diálogo con requisitos de contraseña
  void _showPasswordRequirementsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Requisitos de contraseña'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('La contraseña debe cumplir con:'),
            SizedBox(height: 12),
            Text('• Mínimo 8 caracteres'),
            SizedBox(height: 4),
            Text('• Al menos una mayúscula (A-Z)'),
            SizedBox(height: 4),
            Text('• Al menos una minúscula (a-z)'),
            SizedBox(height: 4),
            Text('• Al menos un número (0-9)'),
            SizedBox(height: 4),
            Text('• Al menos un carácter especial (!@#%^&*)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final horizontalPadding = isTablet ? AppTheme.spacingXl : AppTheme.spacingLg;
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppTheme.spacingXl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card principal - ya no tiene márgenes laterales en móvil
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusXXl,
                        ),
                        border: Border.all(
                          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Hero Section con imagen
                          _buildHeroSection(),
                          // Formulario
                          _buildForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Imagen de fondo
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.borderRadiusXXl),
            topRight: Radius.circular(AppTheme.borderRadiusXXl),
          ),
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuARvxFc5GXD6UP8Q62oATNpGZYFEzyyUYCri0JHLgiAwzZcF04zLfJlKTxb6U5pU0_b5uBZ-WLfFHf4SdYBpXFjUISAnsKVAFDSeDbaGHiIMMjmyq-rofvNB_gsMAHBmyHEvbSc83qRRhUDO9y_y3GiBnmB7XdcVq-flYkdhAlVbyp1bxTKu2JEt1wp__9uZxKikJZRqFO0biv-mRtv4nQT6OZSPDjRdOJJ0WfdI0S765n80-XaanDjg9me84vkJM6TAjoXwTbGs_yF',
            height: 192,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 192,
                color: AppTheme.primaryContainer,
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.building,
                    size: 64,
                    color: AppTheme.primary,
                  ),
                ),
              );
            },
          ),
        ),
        // Gradiente overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppTheme.surfaceContainerLowest, Colors.transparent],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
        ),
        // Texto overlay
        Positioned(
          bottom: AppTheme.spacingXl,
          left: AppTheme.spacingXl,
          right: AppTheme.spacingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crea tu cuenta',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: AppTheme.primaryFixed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Únete a la gestión comercial eficiente',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryFixed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nombres
            CustomTextField(
              controller: _firstNameController,
              label: 'Nombres',
              hint: 'Ej. Juan Carlos',
              icon: FontAwesomeIcons.user,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              onChanged: (value) {
                // Limpiar error del backend cuando el usuario escribe
                if (_backendErrors['firstName'] != null) {
                  setState(() {
                    _backendErrors['firstName'] = null;
                  });
                }
              },
              validator: (value) {
                if (_backendErrors['firstName'] != null) {
                  return _backendErrors['firstName'];
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tus nombres';
                }
                if (value.length < 2) {
                  return 'Los nombres deben tener al menos 2 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Apellidos
            CustomTextField(
              controller: _lastNameController,
              label: 'Apellidos',
              hint: 'Ej. Pérez González',
              icon: FontAwesomeIcons.userGroup,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              onChanged: (value) {
                if (_backendErrors['lastName'] != null) {
                  setState(() {
                    _backendErrors['lastName'] = null;
                  });
                }
              },
              validator: (value) {
                if (_backendErrors['lastName'] != null) {
                  return _backendErrors['lastName'];
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tus apellidos';
                }
                if (value.length < 2) {
                  return 'Los apellidos deben tener al menos 2 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Correo Electrónico
            CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'ejemplo@comercia.com',
              icon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              onChanged: (value) {
                if (_backendErrors['email'] != null) {
                  setState(() {
                    _backendErrors['email'] = null;
                  });
                }
              },
              validator: (value) {
                if (_backendErrors['email'] != null) {
                  return _backendErrors['email'];
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Contraseña con validador mejorado
            CustomTextField(
              controller: _passwordController,
              label: 'Contraseña',
              hint: '••••••••',
              icon: FontAwesomeIcons.lock,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              onChanged: (value) {
                if (_backendErrors['password'] != null) {
                  setState(() {
                    _backendErrors['password'] = null;
                  });
                }
                // Validar contraseña en tiempo real
                _validatePasswordStrength(value);
              },
              suffixIcon: IconButton(
                icon: FaIcon(
                  _obscurePassword
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (_backendErrors['password'] != null) {
                  return _backendErrors['password'];
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una contraseña';
                }
                if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'La contraseña debe tener al menos una mayúscula';
                }
                if (!RegExp(r'[a-z]').hasMatch(value)) {
                  return 'La contraseña debe tener al menos una minúscula';
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return 'La contraseña debe tener al menos un número';
                }
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'La contraseña debe tener al menos un carácter especial';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Confirmar Contraseña
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirmar contraseña',
              hint: '••••••••',
              icon: FontAwesomeIcons.clock,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              borderRadius: AppTheme.borderRadiusXXl,
              onChanged: (value) {
                if (_backendErrors['confirmPassword'] != null) {
                  setState(() {
                    _backendErrors['confirmPassword'] = null;
                  });
                }
              },
              suffixIcon: IconButton(
                icon: FaIcon(
                  _obscureConfirmPassword
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (_backendErrors['confirmPassword'] != null) {
                  return _backendErrors['confirmPassword'];
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor confirma tu contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Términos y condiciones
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primary,
                    side: BorderSide(color: AppTheme.outlineVariant),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      children: [
                        const TextSpan(text: 'Acepto los '),
                        TextSpan(
                          text: 'términos de servicio',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _showTermsDialog,
                        ),
                        const TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'política de privacidad',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _showPrivacyDialog,
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Botón de Registro
            PrimaryButton(
              text: 'Registrarse',
              state: _buttonState,
              icon: FontAwesomeIcons.arrowRight,
              onPressed: _handleRegister,
              fullWidth: true,
              height: 56,
              fontSize: 16,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Link para iniciar sesión
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(color: AppTheme.onSurfaceVariant),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos de Servicio'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí irían los términos de servicio completos.\n\n'
            'Este es un texto de ejemplo para mostrar cómo se vería '
            'el diálogo de términos y condiciones.',
          ),
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

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí iría la política de privacidad completa.\n\n'
            'Este es un texto de ejemplo para mostrar cómo se vería '
            'el diálogo de política de privacidad.',
          ),
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
