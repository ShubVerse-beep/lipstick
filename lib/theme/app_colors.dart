import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds: warm, low-contrast greens keep the interface calm and readable.
  static const Color primaryBg = Color(0xFFFFFFFF);
  static const Color secondaryBg = Color(0xFFF4F9F6);
  static const Color leafBg = Color(0xFFEAF5EE);

  // Refined green system: deep ink for contrast, fresh greens for actions,
  // and pale greens for supporting surfaces.
  static const Color leafGreenDark = Color(0xFF123C2B);
  static const Color leafGreenDeep = Color(0xFF1B513B);
  static const Color leafGreenPrimary = Color(0xFF247A57);
  static const Color leafGreenMedium = Color(0xFF3D966F);
  static const Color leafGreenLight = Color(0xFF62B58B);
  static const Color leafGreenMint = Color(0xFF8ACDA9);
  static const Color leafGreenPale = Color(0xFFDDF1E4);
  static const Color leafGreenAccent = Color(0xFFA9D9BC);

  // Core Theme Accents
  static const Color primaryAccent = Color(0xFF247A57);
  static const Color secondaryAccent = Color(0xFF8ACDA9);
  static const Color lightGreenAccent = Color(0xFFBFE4CC);
  static const Color medicalGreen = Color(0xFF4AA77B);
  static const Color darkNavy = Color(0xFF123C2B);

  // Text Colors
  static const Color textDark = Color(0xFF143629);
  static const Color textMedium = Color(0xFF416454);
  static const Color textMuted = Color(0xFF6F8D7D);

  // Surfaces, focus, and shadows
  static const Color glassBorder = Color(0x293D966F);
  static const Color glassBackground = Color(0xE6FFFFFF);
  static const Color surfaceBorder = Color(0x1F247A57);
  static const Color focusRing = Color(0x66247A57);
  static const Color disabled = Color(0xFFA8C3B4);
  static const Color disabledBackground = Color(0xFFE7F0EA);
  static const Color shadow = Color(0x14245A42);
  static const Color cardShadow = Color(0x1A1B513B);

  // Status & utility colors stay within the green visual language. The names
  // remain stable for existing screens and business logic.
  static const Color error = Color(0xFF1B513B);
  static const Color success = Color(0xFF247A57);
  static const Color warning = Color(0xFF6A956F);
  static const Color emergency = Color(0xFF123C2B);
  static const Color indigo = Color(0xFF3D966F);

  // Leaf Green Gradients
  static const LinearGradient leafGradient = LinearGradient(
    colors: [Color(0xFF1B513B), Color(0xFF247A57), Color(0xFF3D966F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientFresh = LinearGradient(
    colors: [Color(0xFF247A57), Color(0xFF3D966F), Color(0xFF62B58B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientLight = LinearGradient(
    colors: [Color(0xFF3D966F), Color(0xFF62B58B), Color(0xFF8ACDA9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientHero = LinearGradient(
    colors: [Color(0xFF123C2B), Color(0xFF1B513B), Color(0xFF247A57)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientSubtle = LinearGradient(
    colors: [Color(0xFFF4F9F6), Color(0xFFDDF1E4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientCard = LinearGradient(
    colors: [Color(0xFF247A57), Color(0xFF62B58B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafGradientFloating = LinearGradient(
    colors: [Color(0xFF247A57), Color(0xFF62B58B), Color(0xFF8ACDA9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
