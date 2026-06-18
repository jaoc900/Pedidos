import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales basados en el diseño original
  static const Color primary = Color(0xFF006B2B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1A863C);
  static const Color onPrimaryContainer = Color(0xFFF7FFF2);

  static const Color secondary = Color(0xFF2A6B2C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFACF4A4);
  static const Color onSecondaryContainer = Color(0xFF307231);

  static const Color tertiary = Color(0xFF416600);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF538100);
  static const Color onTertiaryContainer = Color(0xFFFAFFEA);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color background = Color(0xFFF7FAF8);
  static const Color onBackground = Color(0xFF181C1B);

  static const Color surface = Color(0xFFF7FAF8);
  static const Color onSurface = Color(0xFF181C1B);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E1);
  static const Color onSurfaceVariant = Color(0xFF3F4A3E);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF7FAF8);
  static const Color surfaceDim = Color(0xFFD7DBD9);
  static const Color surfaceContainer = Color(0xFFEBEFED);
  static const Color surfaceContainerLow = Color(0xFFF1F4F2);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E7);

  static const Color outline = Color(0xFF6F7A6D);
  static const Color outlineVariant = Color(0xFFBECABB);

  static const Color inverseSurface = Color(0xFF2D3130);
  static const Color onInverseSurface = Color(0xFFEEF1EF);
  static const Color inversePrimary = Color(0xFF77DC87);

  // Colores adicionales para botones específicos
  static const Color loginButtonColor = Color(0xFF1B5E20);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0); 
  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // Espaciado estándar
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;
  static const double spacingXxxl = 48;

  // Bordes redondeados
  static const double borderRadiusSm = 8;
  static const double borderRadiusMd = 12;
  static const double borderRadiusLg = 16;
  static const double borderRadiusXl = 20;
  static const double borderRadiusXXl = 40;
  static const double borderRadiusFull = 9999;

  // Alturas de touch target mínimo (accesibilidad)
  static const double touchTargetMinHeight = 44;
  static const double touchTargetMinWidth = 44;

  // Tamaños de fuente
  static const double fontSizeDisplay = 48;
  static const double fontSizeHeadline = 32;
  static const double fontSizeTitle = 24;
  static const double fontSizeBody = 16;
  static const double fontSizeLabel = 14;
  static const double fontSizeSmall = 12;

  // Configuración del tema claro
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Manrope',

      // ColorScheme completo
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: background,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: onInverseSurface,
        inversePrimary: inversePrimary,
      ),

      // Estilos de texto
      textTheme: _buildTextTheme(),

      // Estilos de AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: surface,
        foregroundColor: onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: fontSizeTitle,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),

      // Estilos de Input
      inputDecorationTheme: _buildInputDecorationTheme(),

      // Estilos de botones
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),

      // Estilos de Checkbox
      checkboxTheme: _buildCheckboxTheme(),

      // Estilos de Card - CORREGIDO
      cardTheme: _buildCardTheme(),

      // Estilos de Chip
      chipTheme: _buildChipTheme(),

      // Estilos de Dialog - CORREGIDO
      dialogTheme: _buildDialogTheme(),

      // Estilos de SnackBar
      snackBarTheme: _buildSnackBarTheme(),

      // Dividers
      dividerTheme: _buildDividerTheme(),

      // Navegación
      navigationBarTheme: _buildNavigationBarTheme(),
      navigationRailTheme: _buildNavigationRailTheme(),
    );
  }

  // Tema oscuro
  static ThemeData darkTheme() {
    final darkColorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF77DC87),
      onPrimary: Color(0xFF002108),
      primaryContainer: Color(0xFF1A863C),
      onPrimaryContainer: Color(0xFFF7FFF2),
      secondary: Color(0xFF91D78A),
      onSecondary: Color(0xFF002203),
      secondaryContainer: Color(0xFF0C5216),
      onSecondaryContainer: Color(0xFFACF4A4),
      tertiary: Color(0xFF9BD844),
      onTertiary: Color(0xFF112000),
      tertiaryContainer: Color(0xFF314F00),
      onTertiaryContainer: Color(0xFFB6F55E),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF181C1B),
      onSurface: Color(0xFFE0E3E1),
      surfaceContainerHighest: Color(0xFF3F4A3E),
      onSurfaceVariant: Color(0xFFBECABB),
      outline: Color(0xFF899A85),
      outlineVariant: Color(0xFF3F4A3E),
      inverseSurface: Color(0xFFE0E3E1),
      onInverseSurface: Color(0xFF181C1B),
      inversePrimary: Color(0xFF006E2C),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Manrope',
      colorScheme: darkColorScheme,
      textTheme: _buildDarkTextTheme(),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: _buildDarkInputDecorationTheme(),
      elevatedButtonTheme: _buildDarkElevatedButtonTheme(),
      textButtonTheme: _buildDarkTextButtonTheme(),
      checkboxTheme: _buildDarkCheckboxTheme(),

      cardTheme: _buildDarkCardTheme(), // CORREGIDO
      dialogTheme: _buildDialogTheme(), // CORREGIDO - Reutilizamos el mismo
    );
  }

  // Construcción de TextTheme
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // Display Large
      displayLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeDisplay,
        height: 56 / 48,
        letterSpacing: -0.02,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 40,
        height: 48 / 40,
        letterSpacing: -0.01,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w800,
      ),

      // Headline Large
      headlineLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeHeadline,
        height: 40 / 32,
        letterSpacing: -0.01,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeTitle,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),

      // Body Large
      bodyLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeBody,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeSmall,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
      ),

      // Label Large
      labelLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeLabel,
        height: 20 / 14,
        letterSpacing: 0.02,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeSmall,
        height: 16 / 12,
        letterSpacing: 0.03,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0.04,
        fontWeight: FontWeight.w500,
      ),

      // Title
      titleLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeBody,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    return _buildTextTheme().apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );
  }

  // InputDecorationTheme
  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeLabel,
        color: onSurfaceVariant,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeBody,
        color: outline,
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeSmall,
        color: error,
      ),
      prefixIconColor: outline,
      suffixIconColor: outline,
    );
  }

  static InputDecorationTheme _buildDarkInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        borderSide: const BorderSide(color: inversePrimary, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeLabel,
        color: onSurfaceVariant,
      ),
      prefixIconColor: outline,
      suffixIconColor: outline,
    );
  }

  // ElevatedButtonTheme
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: loginButtonColor,
        foregroundColor: onPrimary,
        minimumSize: const Size.fromHeight(touchTargetMinHeight),
        padding: const EdgeInsets.symmetric(horizontal: spacingXl, vertical: spacingMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
        elevation: 4,
        shadowColor: loginButtonColor.withValues(alpha: 0.2),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: fontSizeBody,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildDarkElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: inversePrimary,
        foregroundColor: onPrimaryFixed,
        minimumSize: const Size.fromHeight(touchTargetMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
        elevation: 2,
      ),
    );
  }

  // TextButtonTheme
  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(touchTargetMinWidth, touchTargetMinHeight),
        padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSm),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: fontSizeLabel,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildDarkTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: inversePrimary,
        minimumSize: const Size(touchTargetMinWidth, touchTargetMinHeight),
      ),
    );
  }

  // OutlinedButtonTheme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: outline),
        minimumSize: const Size.fromHeight(touchTargetMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: fontSizeBody,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // CheckboxTheme
  static CheckboxThemeData _buildCheckboxTheme() {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSm),
      ),
      side: const BorderSide(color: outline, width: 1.5),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return onPrimary;
        }
        return null;
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return Colors.transparent;
      }),
    );
  }

  static CheckboxThemeData _buildDarkCheckboxTheme() {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSm),
      ),
      side: const BorderSide(color: outlineVariant, width: 1.5),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return onPrimary;
        }
        return null;
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return inversePrimary;
        }
        return Colors.transparent;
      }),
    );
  }

  // CardTheme - CORREGIDO (ahora retorna CardTheme correctamente)
  static CardThemeData _buildCardTheme() {
    return const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusLg)),
      ),
      color: surface,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    );
  }

  static CardThemeData _buildDarkCardTheme() {
    return const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadiusLg),
        ),
      ),
      color: Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    );
  }

  // ChipTheme
  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: surfaceContainerHighest,
      disabledColor: outlineVariant,
      selectedColor: primaryContainer,
      secondarySelectedColor: primary,
      padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingSm),
      labelStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeLabel,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusFull),
      ),
      side: const BorderSide(color: outline, width: 0),
    );
  }

  // DialogTheme - CORREGIDO (ahora retorna DialogTheme correctamente)
  static DialogThemeData _buildDialogTheme() {
    return const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusXl)),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeBody,
        color: onSurfaceVariant,
      ),
    );
  }

  // SnackBarTheme
  static SnackBarThemeData _buildSnackBarTheme() {
    return const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusMd)),
      ),
    );
  }

  // DividerTheme
  static DividerThemeData _buildDividerTheme() {
    return const DividerThemeData(
      color: outlineVariant,
      thickness: 1,
      space: spacingLg,
    );
  }

  // NavigationBarTheme
  static NavigationBarThemeData _buildNavigationBarTheme() {
    return NavigationBarThemeData(
      elevation: 0,
      height: 80,
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontFamily: 'Manrope',
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          fontFamily: 'Manrope',
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 24);
        }
        return const IconThemeData(color: outline, size: 24);
      }),
    );
  }

  // NavigationRailTheme
  static NavigationRailThemeData _buildNavigationRailTheme() {
    return const NavigationRailThemeData(
      backgroundColor: surface,
      elevation: 0,
      selectedIconTheme: IconThemeData(color: primary, size: 24),
      unselectedIconTheme: IconThemeData(color: outline, size: 24),
      selectedLabelTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Extensiones útiles para colores adicionales
  static const Color onPrimaryFixed = Color(0xFF002108);
  static const Color onPrimaryFixedVariant = Color(0xFF005320);
  static const Color onSecondaryFixed = Color(0xFF002203);
  static const Color onSecondaryFixedVariant = Color(0xFF0C5216);
  static const Color onTertiaryFixed = Color(0xFF112000);
  static const Color onTertiaryFixedVariant = Color(0xFF314F00);
  static const Color primaryFixed = Color(0xFF93F9A1);
  static const Color primaryFixedDim = Color(0xFF77DC87);
  static const Color secondaryFixed = Color(0xFFACF4A4);
  static const Color secondaryFixedDim = Color(0xFF91D78A);
  static const Color tertiaryFixed = Color(0xFFB6F55E);
  static const Color tertiaryFixedDim = Color(0xFF9BD844);
}