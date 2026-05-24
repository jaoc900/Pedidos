import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;

  final List<HelpCategory> _categories = [
    HelpCategory(
      title: 'Comenzando',
      icon: FontAwesomeIcons.rocket,
      color: AppTheme.primary,
      articles: [
        HelpArticle(
          title: 'Primeros pasos en Verdant',
          description: 'Guía de inicio rápido para nuevos usuarios',
          content: 'Bienvenido a VerdantGrowth. Esta guía te ayudará a familiarizarte con las funciones principales...',
        ),
        HelpArticle(
          title: 'Configuración de perfil',
          description: 'Cómo personalizar tu perfil de usuario',
          content: 'Puedes editar tu perfil desde la sección "Más" > "Mi Perfil"...',
        ),
        HelpArticle(
          title: 'Navegación por la aplicación',
          description: 'Conoce todas las secciones disponibles',
          content: 'La aplicación cuenta con Dashboard, Órdenes, Clientes, Artículos, Reportes y Finanzas...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Gestión de Productos',
      icon: FontAwesomeIcons.box,
      color: AppTheme.secondary,
      articles: [
        HelpArticle(
          title: 'Agregar nuevo producto',
          description: 'Cómo añadir productos al inventario',
          content: 'Ve a la sección "Artículos" y presiona el botón "+" para agregar un nuevo producto...',
        ),
        HelpArticle(
          title: 'Control de inventario',
          description: 'Gestionar stock y alertas',
          content: 'El sistema te notificará cuando el stock esté bajo...',
        ),
        HelpArticle(
          title: 'Editar productos',
          description: 'Modificar información de productos existentes',
          content: 'Presiona el icono de lápiz en cada producto para editarlo...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Órdenes y Ventas',
      icon: FontAwesomeIcons.cartShopping,
      color: AppTheme.tertiary,
      articles: [
        HelpArticle(
          title: 'Crear una orden',
          description: 'Proceso para generar nuevos pedidos',
          content: 'Desde la sección "Órdenes" puedes crear y gestionar pedidos...',
        ),
        HelpArticle(
          title: 'Estados de orden',
          description: 'Pendiente, En camino, Entregada',
          content: 'Cada orden puede tener diferentes estados según su progreso...',
        ),
        HelpArticle(
          title: 'Cancelar una orden',
          description: 'Cómo cancelar un pedido',
          content: 'Si necesitas cancelar una orden, presiona el botón "Cancelar"...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Clientes',
      icon: FontAwesomeIcons.users,
      color: const Color(0xFF2196F3),
      articles: [
        HelpArticle(
          title: 'Registrar nuevo cliente',
          description: 'Añadir clientes a tu base de datos',
          content: 'Ve a "Clientes" y presiona el botón "+" para agregar un nuevo cliente...',
        ),
        HelpArticle(
          title: 'Historial de compras',
          description: 'Ver compras anteriores de clientes',
          content: 'Cada cliente tiene un historial de sus órdenes...',
        ),
        HelpArticle(
          title: 'Segmentación de clientes',
          description: 'Clasificar por VIP, Nuevo, Archivado',
          content: 'Puedes categorizar a tus clientes para mejor gestión...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Reportes',
      icon: FontAwesomeIcons.chartLine,
      color: AppTheme.warning,
      articles: [
        HelpArticle(
          title: 'Generar reportes',
          description: 'Cómo crear reportes personalizados',
          content: 'En la sección "Reportes" puedes seleccionar el tipo de reporte que necesitas...',
        ),
        HelpArticle(
          title: 'Interpretar gráficos',
          description: 'Entender las visualizaciones de datos',
          content: 'Los gráficos muestran tendencias y comparativas...',
        ),
        HelpArticle(
          title: 'Exportar datos',
          description: 'Descargar reportes en PDF o Excel',
          content: 'Usa el botón de exportar para descargar tus reportes...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Finanzas',
      icon: FontAwesomeIcons.moneyBill,
      color: AppTheme.error,
      articles: [
        HelpArticle(
          title: 'Registrar gastos',
          description: 'Cómo agregar gastos operativos',
          content: 'En Finanzas > Gastos puedes registrar todos tus egresos...',
        ),
        HelpArticle(
          title: 'Gestionar pagos',
          description: 'Control de pagos recibidos',
          content: 'Registra y da seguimiento a los pagos de clientes...',
        ),
        HelpArticle(
          title: 'Calendario de pagos',
          description: 'Visualizar fechas importantes',
          content: 'El calendario te muestra todas las fechas de pago programadas...',
        ),
      ],
    ),
    HelpCategory(
      title: 'Solución de Problemas',
      icon: FontAwesomeIcons.wrench,
      color: Colors.purple,
      articles: [
        HelpArticle(
          title: 'Error de conexión',
          description: 'Qué hacer si no carga la aplicación',
          content: 'Verifica tu conexión a internet y reinicia la app...',
        ),
        HelpArticle(
          title: 'Datos no se actualizan',
          description: 'Sincronización de información',
          content: 'Desliza hacia abajo para refrescar los datos...',
        ),
        HelpArticle(
          title: 'Contactar soporte',
          description: 'Cómo obtener ayuda adicional',
          content: 'Si el problema persiste, contacta a nuestro soporte técnico...',
        ),
      ],
    ),
  ];

  List<HelpCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;

    return _categories
        .map((category) {
      final filteredArticles = category.articles
          .where((article) =>
      article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
      return HelpCategory(
        title: category.title,
        icon: category.icon,
        color: category.color,
        articles: filteredArticles,
      );
    })
        .where((category) => category.articles.isNotEmpty)
        .toList();
  }

  void _showArticleDialog(HelpArticle article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(article.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                article.description,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                article.content,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('¿Te fue útil este artículo?'),
                  backgroundColor: AppTheme.primary,
                  action: SnackBarAction(
                    label: 'Sí',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Me fue útil'),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() async {
    if (_feedbackController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _feedbackController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Gracias por tu feedback!'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'soporte@verdant.com',
      query: 'subject=Consulta%20desde%20la%20app&body=Hola%2C%20necesito%20ayuda%20con...',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede abrir el cliente de correo'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _openFAQ() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo preguntas frecuentes...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner de bienvenida
                  _buildWelcomeBanner(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Barra de búsqueda
                  _buildSearchBar(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Categorías de ayuda
                  ..._filteredCategories.map((category) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingXl),
                    child: _buildCategorySection(category),
                  )),

                  // Sección de contacto
                  _buildContactSection(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Feedback
                  _buildFeedbackSection(),
                  const SizedBox(height: AppTheme.spacingXl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl, vertical: AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingLg),
                Text(
                  'Ayuda',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.questionCircle,
                size: 20,
                color: AppTheme.primary,
              ),
              onPressed: _openFAQ,
              tooltip: 'Preguntas frecuentes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Necesitas ayuda?',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Encuentra respuestas a tus preguntas o contacta con nuestro equipo de soporte.',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.headset,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar en la ayuda...',
          hintStyle: TextStyle(
            color: AppTheme.outline,
            fontSize: AppTheme.fontSizeBody,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 20,
              color: AppTheme.outline,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              size: 16,
              color: AppTheme.outline,
            ),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingLg,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(HelpCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            FaIcon(
              category.icon,
              size: 18,
              color: category.color,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              category.title,
              style: TextStyle(
                fontSize: AppTheme.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        ...category.articles.map((article) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _buildArticleCard(article, category.color),
        )),
      ],
    );
  }

  Widget _buildArticleCard(HelpArticle article, Color color) {
    return GestureDetector(
      onTap: () => _showArticleDialog(article),
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.fileAlt,
                  size: 20,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 16,
              color: AppTheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              FaIcon(
                FontAwesomeIcons.headset,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                '¿No encuentras lo que buscas?',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Nuestro equipo de soporte está disponible para ayudarte.',
            style: TextStyle(
              fontSize: AppTheme.fontSizeBody,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _contactSupport,
                  icon: FaIcon(
                    FontAwesomeIcons.envelope,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  label: const Text('Email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLg),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat de soporte - Próximamente'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.comment,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.message,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                'Envíanos tu feedback',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Cuéntanos tu experiencia o sugiere mejoras...',
              hintStyle: TextStyle(
                color: AppTheme.outlineVariant,
                fontSize: AppTheme.fontSizeSmall,
              ),
              filled: true,
              fillColor: Colors.white,
              border: _buildInputBorder(),
              enabledBorder: _buildInputBorder(),
              focusedBorder: _buildFocusedBorder(),
              contentPadding: const EdgeInsets.all(AppTheme.spacingLg),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Enviar feedback'),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: BorderSide(color: AppTheme.outlineVariant, width: 1),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
      borderSide: const BorderSide(color: AppTheme.primary, width: 2),
    );
  }
}

class HelpCategory {
  final String title;
  final FaIconData icon;
  final Color color;
  final List<HelpArticle> articles;

  HelpCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.articles,
  });
}

class HelpArticle {
  final String title;
  final String description;
  final String content;

  HelpArticle({
    required this.title,
    required this.description,
    required this.content,
  });
}