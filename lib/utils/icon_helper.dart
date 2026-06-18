import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Helper para manejar el catálogo de iconos de Font Awesome
class IconHelper {
  // Mapa de nombres de iconos a sus respectivos FaIconData
  static const Map<String, FaIconData> _iconMap = {
    // General
    'tags': FontAwesomeIcons.tags,
    'tag': FontAwesomeIcons.tag,
    'star': FontAwesomeIcons.star,
    'heart': FontAwesomeIcons.heart,
    'check': FontAwesomeIcons.check,
    'xmark': FontAwesomeIcons.xmark,
    'plus': FontAwesomeIcons.plus,
    'minus': FontAwesomeIcons.minus,

    // Compras
    'cart': FontAwesomeIcons.cartShopping,
    'cartPlus': FontAwesomeIcons.cartPlus,
    'shoppingBag': FontAwesomeIcons.bagShopping,
    'shoppingBasket': FontAwesomeIcons.basketShopping,
    'receipt': FontAwesomeIcons.receipt,
    'creditCard': FontAwesomeIcons.creditCard,
    'moneyBill': FontAwesomeIcons.moneyBill,

    // Productos
    'box': FontAwesomeIcons.box,
    'boxes': FontAwesomeIcons.boxesStacked,
    'boxOpen': FontAwesomeIcons.boxOpen,

    // Clientes
    'user': FontAwesomeIcons.user,
    'users': FontAwesomeIcons.users,
    'userPlus': FontAwesomeIcons.userPlus,
    'userMinus': FontAwesomeIcons.userMinus,
    'userCheck': FontAwesomeIcons.userCheck,
    'userGear': FontAwesomeIcons.userGear,

    // Hogar
    'home': FontAwesomeIcons.house,
    'building': FontAwesomeIcons.building,

    // Alimentos
    'utensils': FontAwesomeIcons.utensils,
    'apple': FontAwesomeIcons.apple,
    'carrot': FontAwesomeIcons.carrot,

    // Transporte
    'car': FontAwesomeIcons.car,
    'truck': FontAwesomeIcons.truck,
    'truckFast': FontAwesomeIcons.truckFast,
    'bicycle': FontAwesomeIcons.bicycle,
    'plane': FontAwesomeIcons.plane,

    // Servicios
    'bolt': FontAwesomeIcons.bolt,
    'lightbulb': FontAwesomeIcons.lightbulb,
    'water': FontAwesomeIcons.water,
    'fire': FontAwesomeIcons.fire,
    'trash': FontAwesomeIcons.trash,
    'leaf': FontAwesomeIcons.leaf,
    'seedling': FontAwesomeIcons.seedling,

    // Mantenimiento
    'wrench': FontAwesomeIcons.wrench,
    'tools': FontAwesomeIcons.tools,
    'hammer': FontAwesomeIcons.hammer,
    'paintbrush': FontAwesomeIcons.paintbrush,
    'broom': FontAwesomeIcons.broom,

    // Marketing
    'bullhorn': FontAwesomeIcons.bullhorn,
    'chartLine': FontAwesomeIcons.chartLine,
    'chartBar': FontAwesomeIcons.chartBar,
    'chartPie': FontAwesomeIcons.chartPie,
    'envelope': FontAwesomeIcons.envelope,

    // Salud
    'heartPulse': FontAwesomeIcons.heartPulse,
    'hospital': FontAwesomeIcons.hospital,
    'stethoscope': FontAwesomeIcons.stethoscope,
    'syringe': FontAwesomeIcons.syringe,

    // Educación
    'graduationCap': FontAwesomeIcons.graduationCap,
    'school': FontAwesomeIcons.school,
    'book': FontAwesomeIcons.book,
    'bookOpen': FontAwesomeIcons.bookOpen,

    // Entretenimiento
    'gamepad': FontAwesomeIcons.gamepad,
    'music': FontAwesomeIcons.music,
    'headphones': FontAwesomeIcons.headphones,

    // Viajes
    'suitcase': FontAwesomeIcons.suitcase,
    'hotel': FontAwesomeIcons.hotel,
    'umbrellaBeach': FontAwesomeIcons.umbrellaBeach,
    'mountain': FontAwesomeIcons.mountain,

    // Finanzas
    'wallet': FontAwesomeIcons.wallet,
    'piggyBank': FontAwesomeIcons.piggyBank,
    'calculator': FontAwesomeIcons.calculator,
    'percent': FontAwesomeIcons.percent,

    // Documentos
    'file': FontAwesomeIcons.file,
    'fileLines': FontAwesomeIcons.fileLines,
    'fileInvoice': FontAwesomeIcons.fileInvoice,
    'filePdf': FontAwesomeIcons.filePdf,
    'clipboard': FontAwesomeIcons.clipboard,
    'clipboardList': FontAwesomeIcons.clipboardList,

    // Notificaciones
    'bell': FontAwesomeIcons.bell,
    'bellSlash': FontAwesomeIcons.bellSlash,
    'message': FontAwesomeIcons.message,
    'comment': FontAwesomeIcons.comment,
    'comments': FontAwesomeIcons.comments,
    'inbox': FontAwesomeIcons.inbox,

    // Configuración
    'gear': FontAwesomeIcons.gear,
    'sliders': FontAwesomeIcons.sliders,

    // Seguridad
    'lock': FontAwesomeIcons.lock,
    'lockOpen': FontAwesomeIcons.lockOpen,
    'shield': FontAwesomeIcons.shield,
    'key': FontAwesomeIcons.key,
    'fingerprint': FontAwesomeIcons.fingerprint,

    // Fechas
    'calendar': FontAwesomeIcons.calendar,
    'calendarDay': FontAwesomeIcons.calendarDay,
    'clock': FontAwesomeIcons.clock,
    'hourglass': FontAwesomeIcons.hourglass,

    // Búsqueda
    'search': FontAwesomeIcons.magnifyingGlass,
    'filter': FontAwesomeIcons.filter,

    // Navegación
    'dashboard': FontAwesomeIcons.chartPie,
    'menu': FontAwesomeIcons.bars,
    'ellipsisV': FontAwesomeIcons.ellipsisVertical,
    'arrowLeft': FontAwesomeIcons.arrowLeft,
    'arrowRight': FontAwesomeIcons.arrowRight,
    'arrowUp': FontAwesomeIcons.arrowUp,
    'arrowDown': FontAwesomeIcons.arrowDown,
    'chevronLeft': FontAwesomeIcons.chevronLeft,
    'chevronRight': FontAwesomeIcons.chevronRight,
    'chevronUp': FontAwesomeIcons.chevronUp,
    'chevronDown': FontAwesomeIcons.chevronDown,

    // Redes Sociales
    'facebook': FontAwesomeIcons.facebook,
    'twitter': FontAwesomeIcons.twitter,
    'instagram': FontAwesomeIcons.instagram,
    'linkedin': FontAwesomeIcons.linkedin,
    'whatsapp': FontAwesomeIcons.whatsapp,
    'paypal': FontAwesomeIcons.paypal,

    // Estado
    'checkCircle': FontAwesomeIcons.circleCheck,
    'exclamationCircle': FontAwesomeIcons.circleExclamation,
    'infoCircle': FontAwesomeIcons.circleInfo,
    'questionCircle': FontAwesomeIcons.circleQuestion,
    'timesCircle': FontAwesomeIcons.circleXmark,
    'warning': FontAwesomeIcons.triangleExclamation,
    'spinner': FontAwesomeIcons.spinner,
    'sync': FontAwesomeIcons.sync,

    // Acciones
    'edit': FontAwesomeIcons.pen,
    'delete': FontAwesomeIcons.trashCan,
    'floppyDisk': FontAwesomeIcons.floppyDisk,
    'print': FontAwesomeIcons.print,
    'download': FontAwesomeIcons.download,
    'upload': FontAwesomeIcons.upload,
    'share': FontAwesomeIcons.share,
    'copy': FontAwesomeIcons.copy,

    // Agricultura
    'tree': FontAwesomeIcons.tree,
    'tractor': FontAwesomeIcons.tractor,
    'droplet': FontAwesomeIcons.droplet,
  };

  /// Obtiene el IconData a partir del nombre del icono
  static FaIconData? getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) return null;
    return _iconMap[iconName];
  }

  /// Obtiene el icono con un fallback por defecto
  static FaIcon getIconOrDefault(String? iconName, {double size = 20, Color? color}) {
    final icon = getIcon(iconName);
    return FaIcon(
      icon ?? FontAwesomeIcons.tags,
      size: size,
      color: color,
    );
  }

  /// Verifica si un nombre de icono existe
  static bool hasIcon(String? iconName) {
    return iconName != null && _iconMap.containsKey(iconName);
  }
}

/// Extensión para usar el helper fácilmente
extension IconHelperExtension on String? {
  FaIconData? get toIconData => IconHelper.getIcon(this);
  FaIcon toIconOrDefault({double size = 20, Color? color}) =>
      IconHelper.getIconOrDefault(this, size: size, color: color);
  bool get hasIcon => IconHelper.hasIcon(this);
}