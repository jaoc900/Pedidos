import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';
import 'package:pedidos/models/user_model.dart';
import 'package:pedidos/core/network/http_client.dart';
import 'package:pedidos/core/network/api_client.dart';
import 'package:pedidos/core/network/exceptions/network_exceptions.dart';
import 'package:pedidos/widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores - Inicializar con valores vacíos
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _roleController;

  // Variables para la imagen
  File? _profileImage;
  String? _profileImageUrl;
  String? _profileImageBase64;

  // Estados
  bool _isEditing = false;
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _twoFactorEnabled = false;

  // Clientes
  late ApiClient _apiClient;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con valores vacíos
    _firstNameController = TextEditingController(text: '');
    _lastNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _addressController = TextEditingController(text: '');
    _roleController = TextEditingController(text: '');

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Inicializar API client
      final httpClient = HttpClient();
      _apiClient = ApiClient(httpClient);

      // Cargar datos del perfil
      await _loadProfile();
    } catch (e) {
      print('Error en inicialización: $e');
      setState(() {
        _isLoading = false;
      });
      _showError('Error al cargar el perfil: ${e.toString()}');
    }
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _apiClient.getProfile();
      final user = UserModel.fromJson(response);

      print('Usuario cargado: ${user.firstName} ${user.lastName}');
      print('Tiene foto en base64: ${user.profilePictureBase64 != null}');

      setState(() {
        // Actualizar textos de los controladores
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _addressController.text = user.address ?? '';
        _roleController.text = _getRoleName(user.role);

        // Priorizar base64 sobre URL
        if (user.profilePictureBase64 != null && user.profilePictureBase64!.isNotEmpty) {
          _profileImageBase64 = user.profilePictureBase64;
          _profileImageUrl = null;
        } else {
          _profileImageUrl = user.profilePictureUrl;
          _profileImageBase64 = null;
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar perfil: $e');
      setState(() {
        _isLoading = false;
      });
      _handleError(e);
    }
  }

  String _getRoleName(String role) {
    switch(role) {
      case '1': return 'Cliente';
      case '2': return 'Vendedor';
      case '3': return 'Supervisor';
      case '4': return 'Administrador';
      default: return 'Usuario';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      };

      userData.removeWhere((key, value) => value == null);

      final response = await _apiClient.updateProfile(userData);

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      _showSuccess('Perfil actualizado exitosamente');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _handleError(e);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (photo != null) {
        await _uploadProfilePhoto(File(photo.path));
      }
    } catch (e) {
      _showError('Error al tomar la foto: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (image != null) {
        await _uploadProfilePhoto(File(image.path));
      }
    } catch (e) {
      _showError('Error al seleccionar la imagen: $e');
    }
  }

  Future<void> _uploadProfilePhoto(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.uploadProfilePhoto(imageFile);

      // Dependiendo de cómo tu API responda después de subir la foto
      final photoUrl = response['data']['photoUrl'] ?? response['photoUrl'];
      final photoBase64 = response['data']['profilePictureBase64'] ?? response['profilePictureBase64'];

      setState(() {
        _profileImage = null;
        if (photoBase64 != null) {
          _profileImageBase64 = photoBase64;
          _profileImageUrl = null;
        } else {
          _profileImageUrl = photoUrl;
          _profileImageBase64 = null;
        }
        _isLoading = false;
      });

      _showSuccess('Foto de perfil actualizada');

      // Recargar el perfil para obtener los datos actualizados
      await _loadProfile();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _handleError(e);
    }
  }

  Future<void> _deleteProfileImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar foto de perfil'),
        content: const Text('¿Estás seguro de que deseas eliminar tu foto de perfil?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _apiClient.deleteProfilePhoto();

        setState(() {
          _profileImage = null;
          _profileImageUrl = null;
          _profileImageBase64 = null;
          _isLoading = false;
        });

        _showSuccess('Foto de perfil eliminada');

        // Recargar el perfil para actualizar los datos
        await _loadProfile();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _handleError(e);
      }
    }
  }

  Future<void> _changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Estado para mostrar/ocultar contraseñas
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return AlertDialog(
            title: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.lock,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                const Text('Cambiar Contraseña'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite, // Asegura que el contenido tome el ancho completo
              child: SingleChildScrollView( // Envolver en SingleChildScrollView para evitar overflow
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Contraseña actual
                      CustomTextField(
                        controller: currentPasswordController,
                        label: 'Contraseña actual',
                        hint: 'Ingresa tu contraseña actual',
                        icon: FontAwesomeIcons.lock,
                        obscureText: obscureCurrent,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: FaIcon(
                            obscureCurrent ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 18,
                            color: AppTheme.outline,
                          ),
                          onPressed: () {
                            setStateModal(() {
                              obscureCurrent = !obscureCurrent;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña actual';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Nueva contraseña
                      CustomTextField(
                        controller: newPasswordController,
                        label: 'Nueva contraseña',
                        hint: 'Ingresa tu nueva contraseña (mínimo 6 caracteres)',
                        icon: FontAwesomeIcons.lock,
                        obscureText: obscureNew,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: FaIcon(
                            obscureNew ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 18,
                            color: AppTheme.outline,
                          ),
                          onPressed: () {
                            setStateModal(() {
                              obscureNew = !obscureNew;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa la nueva contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Confirmar nueva contraseña
                      CustomTextField(
                        controller: confirmPasswordController,
                        label: 'Confirmar contraseña',
                        hint: 'Confirma tu nueva contraseña',
                        icon: FontAwesomeIcons.lock,
                        obscureText: obscureConfirm,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: FaIcon(
                            obscureConfirm ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 18,
                            color: AppTheme.outline,
                          ),
                          onPressed: () {
                            setStateModal(() {
                              obscureConfirm = !obscureConfirm;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirma tu nueva contraseña';
                          }
                          if (value != newPasswordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),

                      // Indicador de fortaleza de contraseña
                      if (newPasswordController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppTheme.spacingSm),
                          child: _buildPasswordStrengthIndicator(newPasswordController.text),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.error,
                ),
                child: const Text('Cancelar'),
              ),
              PrimaryButton(
                text: 'Actualizar',
                borderRadius: AppTheme.borderRadiusXXl,
                height: 45,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                fullWidth: false,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
            actionsPadding: const EdgeInsets.all(AppTheme.spacingMd),
            contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
            ),
            // Limitar la altura máxima del diálogo
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          );
        },
      ),
    );

    if (result == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final Map<String, dynamic> passwordData = {
          'currentPassword': currentPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        };

        await _apiClient.changePassword(passwordData);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showSuccess('Contraseña actualizada exitosamente');

          // Limpiar los campos
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _handleError(e);
        }
      }
    }
  }

// Método opcional para mostrar la fortaleza de la contraseña
  Widget _buildPasswordStrengthIndicator(String password) {
    int strength = _calculatePasswordStrength(password);
    Color color;
    String text;

    if (strength <= 2) {
      color = AppTheme.error;
      text = 'Débil';
    } else if (strength <= 4) {
      color = AppTheme.warning;
      text = 'Media';
    } else {
      color = AppTheme.success;
      text = 'Fuerte';
    }

    return Column(
      children: [
        const SizedBox(height: AppTheme.spacingSm),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 6,
                backgroundColor: AppTheme.outlineVariant,
                color: color,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    if (password.length >= 10) strength++;

    return strength.clamp(0, 6);
  }

  void _deleteAccount() {
    ConfirmationModal.show(
      context,
      title: 'Eliminar Cuenta',
      message: '¿Estás seguro de que deseas eliminar tu cuenta?\n\nEsta acción es irreversible y perderás todos tus datos.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: ConfirmationType.warning,
      customIcon: FontAwesomeIcons.trashCan,
      onConfirm: () async {
        // TODO: Implementar eliminación de cuenta
        if (context.mounted) {
          _showSuccess('Cuenta eliminada. Redirigiendo...');
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      },
    );
  }

  void _handleError(dynamic error) {
    String message = 'Ha ocurrido un error inesperado';

    if (error is NetworkExceptions) {
      message = error.message;
      print('NetworkException: ${error.message}');
    } else if (error is String) {
      message = error;
      print('String error: $error');
    } else if (error is Exception) {
      message = error.toString();
      print('Exception: $error');
    } else {
      print('Unknown error: $error');
    }

    _showError(message);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty || fullName.trim().isEmpty) return 'U';

    final trimmedName = fullName.trim();
    final names = trimmedName.split(' ');

    final validWords = names.where((word) => word.isNotEmpty).toList();

    if (validWords.isEmpty) return 'U';

    if (validWords.length >= 2) {
      final firstInitial = validWords[0][0];
      final secondInitial = validWords[1][0];
      return '${firstInitial.toUpperCase()}${secondInitial.toUpperCase()}';
    } else {
      return validWords[0][0].toUpperCase();
    }
  }

  Widget _getProfileImageWidget() {
    final String fullName = '${_firstNameController.text} ${_lastNameController.text}';
    final String initials = _getInitials(fullName);

    // Si hay imagen local (desde cámara/galería)
    if (_profileImage != null) {
      return ClipOval(
        child: Image.file(
          _profileImage!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    // Si hay imagen en base64
    if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
      try {
        // Asegurarse de que el base64 está limpio
        String cleanBase64 = _profileImageBase64!;

        // Si aún tiene el prefijo, lo removemos
        if (cleanBase64.contains(',')) {
          cleanBase64 = cleanBase64.substring(cleanBase64.indexOf(',') + 1);
        }

        final bytes = base64Decode(cleanBase64);
        print('Base64 decodificado correctamente, tamaño: ${bytes.length} bytes');

        return ClipOval(
          child: Image.memory(
            bytes,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error al cargar imagen base64: $error');
              return _buildInitialsWidget(initials);
            },
          ),
        );
      } catch (e) {
        print('Error decodificando base64: $e');
        print('Base64 string (primeros 100 chars): ${_profileImageBase64!.substring(0, _profileImageBase64!.length > 100 ? 100 : _profileImageBase64!.length)}');
        return _buildInitialsWidget(initials);
      }
    }

    // Si hay URL de imagen
    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          _profileImageUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildInitialsWidget(initials);
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error al cargar imagen URL: $error');
            return _buildInitialsWidget(initials);
          },
        ),
      );
    }

    // Si no hay imagen, mostrar iniciales
    return _buildInitialsWidget(initials);
  }

// Widget helper para iniciales
  Widget _buildInitialsWidget(String initials) {
    return ClipOval(
      child: Container(
        width: 120,
        height: 120,
        color: AppTheme.primaryContainer,
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildTopAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildProfileForm(),
                  const SizedBox(height: AppTheme.spacingXl),
                  _buildAccountActions(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    List<Widget> actions = [];

    if (!_isEditing && !_isLoading) {
      actions.add(
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.pen,
            size: 20,
            color: AppTheme.primary,
          ),
          onPressed: _toggleEditMode,
        ),
      );
    } else if (_isEditing && !_isLoading) {
      actions.addAll([
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.save,
            size: 20,
            color: AppTheme.secondary,
          ),
          onPressed: _saveProfile,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.times,
            size: 20,
            color: AppTheme.error,
          ),
          onPressed: _toggleEditMode,
        ),
      ]);
    }

    return CustomTopAppBar(
      title: 'Mi Perfil',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      actions: actions,
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _getProfileImageWidget(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isLoading ? null : _changeProfileImage,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeProfileImage() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppTheme.spacingSm),

            // Opción 1: Tomar foto
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.camera,
                    size: 22,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              title: const Text(
                'Tomar foto',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Usar la cámara para tomar una foto'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),

            const Divider(height: 0),

            // Opción 2: Seleccionar de galería
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.image,
                    size: 22,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              title: const Text(
                'Seleccionar de galería',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Elegir una imagen de tu galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),

            // Opción 3: Eliminar foto (solo visible si hay una foto)
            // Verificar si hay foto (local, URL o base64)
            if (_hasProfileImage())
              const Divider(height: 0),
            if (_hasProfileImage())
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.trashCan,
                      size: 22,
                      color: AppTheme.error,
                    ),
                  ),
                ),
                title: Text(
                  'Eliminar foto',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.error,
                  ),
                ),
                subtitle: const Text('Eliminar tu foto de perfil actual'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteProfileImage();
                },
              ),

            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

// Método helper para verificar si hay una foto de perfil
  bool _hasProfileImage() {
    return _profileImage != null ||
        (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) ||
        (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty);
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CustomTextField(
              controller: _firstNameController,
              label: 'Nombre',
              hint: 'Tu nombre',
              icon: FontAwesomeIcons.user,
              enabled: _isEditing && !_isLoading,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            CustomTextField(
              controller: _lastNameController,
              label: 'Apellido',
              hint: 'Tu apellido',
              icon: FontAwesomeIcons.user,
              enabled: _isEditing && !_isLoading,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu apellido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'correo@ejemplo.com',
              icon: FontAwesomeIcons.envelope,
              enabled: _isEditing && !_isLoading,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu correo';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Correo inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingLg),
            CustomTextField(
              controller: _phoneController,
              label: 'Teléfono',
              hint: '+52 555 123 4567',
              icon: FontAwesomeIcons.phone,
              enabled: _isEditing && !_isLoading,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            CustomTextField(
              controller: _addressController,
              label: 'Dirección',
              hint: 'Tu dirección completa',
              icon: FontAwesomeIcons.locationDot,
              enabled: _isEditing && !_isLoading,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
              maxLines: 2,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            CustomTextField(
              controller: _roleController,
              label: 'Rol',
              hint: 'Tu rol en el sistema',
              icon: FontAwesomeIcons.briefcase,
              enabled: false,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.lock,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),
            ),
            title: const Text('Cambiar contraseña'),
            subtitle: const Text('Actualiza tu contraseña de acceso'),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppTheme.outline,
            ),
            onTap: _isLoading ? null : _changePassword,
          ),
          const Divider(),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: 20,
                  color: AppTheme.error,
                ),
              ),
            ),
            title: const Text('Eliminar cuenta', style: TextStyle(color: AppTheme.error)),
            subtitle: const Text('Eliminar permanentemente tu cuenta'),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppTheme.error,
            ),
            onTap: _isLoading ? null : _deleteAccount,
          ),
        ],
      ),
    );
  }
}