import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/screens/modals/confirmation_modal.dart';
import 'package:pedidos/widgets/custom_top_app_bar.dart';
import 'package:pedidos/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos editables
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _bioController;

  bool _isEditing = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario (ejemplo)
    _nameController = TextEditingController(text: 'Alejandro Rodríguez');
    _emailController = TextEditingController(text: 'alejandro@verdant.com');
    _phoneController = TextEditingController(text: '+52 555 123 4567');
    _positionController = TextEditingController(text: 'Administrador');
    _bioController = TextEditingController(
      text: 'Apasionado por la agricultura sostenible y la tecnología. Encargado de la gestión de inventarios y finanzas.',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado exitosamente'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
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
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera, size: 24),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad: Tomar foto'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.image, size: 24),
              title: const Text('Seleccionar de galería'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad: Seleccionar imagen'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.trashCan, size: 24, color: AppTheme.error),
              title: const Text('Eliminar foto', style: TextStyle(color: AppTheme.error)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foto de perfil eliminada'),
                    backgroundColor: AppTheme.error,
                  ),
                );
              },
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña actualizada'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
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
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta eliminada. Redirigiendo...'),
            backgroundColor: AppTheme.error,
          ),
        );
        // Aquí iría la navegación a login
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Foto de perfil
                  _buildProfileImage(),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Formulario de perfil
                  _buildProfileForm(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Preferencias
                  _buildPreferencesSection(),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Acciones de cuenta
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

  Widget _buildTopAppBar() {
    // Construir acciones según modo edición
    List<Widget> actions = [];

    if (!_isEditing) {
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
    } else {
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
      actions: [
        AppBarButton(
            icon: FontAwesomeIcons.save,
            onPressed: () => {})
      ],
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
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_6iZ29fNDT9qzWxDsmKL2dSfXzmNo85liJ-wV1CW46883sjJQuX3X8aGsUhAVXzWS5AYwbj34abpIVpbyp5eCmgHyMy6pBNZE6AQq5GVxBaKg3fCyVan7njjhkxfr--2xeOca6agoJ0C4TZtG5gjs2nOuw0PO1_miNOOt2H6piXw5LcfRZCcZjCAn6LgE2UjCVwBS9q58jPHjko4L9MEZJZLlYpZIbKSpfzomNeKBL-xaV4AAvCxceRExeU_xnc8m0arrCqrhdsX',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.primaryContainer,
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _changeProfileImage,
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
            // Nombre completo
            CustomTextField(
              controller: _nameController,
              label: 'Nombre completo',
              hint: 'Tu nombre completo',
              icon: FontAwesomeIcons.user,
              enabled: _isEditing,
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

            // Correo electrónico
            CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'correo@ejemplo.com',
              icon: FontAwesomeIcons.envelope,
              enabled: _isEditing,
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

            // Teléfono
            CustomTextField(
              controller: _phoneController,
              label: 'Teléfono',
              hint: '+52 555 123 4567',
              icon: FontAwesomeIcons.phone,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Cargo
            CustomTextField(
              controller: _positionController,
              label: 'Cargo',
              hint: 'Tu cargo en la empresa',
              icon: FontAwesomeIcons.briefcase,
              enabled: _isEditing,
              textInputAction: TextInputAction.next,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Biografía
            CustomTextField(
              controller: _bioController,
              label: 'Biografía',
              hint: 'Cuéntanos sobre ti...',
              icon: FontAwesomeIcons.alignLeft,
              enabled: _isEditing,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              borderRadius: AppTheme.borderRadiusXXl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.gear,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Preferencias',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SwitchListTile(
            title: const Text('Notificaciones push'),
            subtitle: const Text('Recibir alertas y notificaciones'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambiar tema de la aplicación'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Autenticación de dos factores'),
            subtitle: const Text('Mayor seguridad para tu cuenta'),
            value: _twoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
            },
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ],
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
            onTap: _changePassword,
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
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }
}