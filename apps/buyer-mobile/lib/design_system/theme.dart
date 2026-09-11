import 'package:flutter/material.dart';

import 'generated/color_tokens.dart';

abstract final class BuyerTheme {
  static const action = Color(MateryalColorTokens.actionPrimary);
  static const actionPressed = Color(MateryalColorTokens.actionPrimaryPressed);
  static const canvas = Color(MateryalColorTokens.surfaceCanvas);
  static const ink = Color(MateryalColorTokens.textStrong);
  static const muted = Color(MateryalColorTokens.textSecondary);
  static const border = Color(MateryalColorTokens.borderDefault);
  static const brandSoft = Color(MateryalColorTokens.brandOrange100);
  static const success = Color(MateryalColorTokens.statusSuccess);

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(MateryalColorTokens.brandOrange500),
          brightness: Brightness.light,
          surface: const Color(MateryalColorTokens.surfacePrimary),
        ).copyWith(
          primary: action,
          onPrimary: Colors.white,
          error: const Color(MateryalColorTokens.statusError),
          outline: const Color(MateryalColorTokens.borderDefault),
        );

    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: canvas,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: base.textTheme
          .apply(bodyColor: ink, displayColor: ink)
          .copyWith(
            bodyLarge: base.textTheme.bodyLarge?.copyWith(
              color: ink,
              height: 1.5,
            ),
            bodyMedium: base.textTheme.bodyMedium?.copyWith(
              color: ink,
              height: 1.5,
            ),
            titleLarge: base.textTheme.titleLarge?.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
            ),
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 32,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: Color(MateryalColorTokens.borderDefault)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 4,
        helperMaxLines: 4,
        floatingLabelStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: action, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(MateryalColorTokens.borderDefault),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(MateryalColorTokens.borderDefault),
          ),
        ),
      ),
    );
  }
}
