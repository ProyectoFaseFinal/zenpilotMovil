import 'package:flutter/material.dart';

// --- COLORES MATERIAL DESIGN ---
const Color kPrimaryColor = Color(0xFF0D47A1);
const Color kPrimaryLight = Color(0xFF5472D3);
const Color kPrimaryDark = Color(0xFF002171);
const Color kAccentColor = Color(0xFF00B0FF);
const Color kBackgroundColor = Color(0xFFFAFAFA);
const Color kSurfaceColor = Color(0xFFFFFFFF);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF212121);
const Color kTextSecondary = Color(0xFF757575);
const Color kDividerColor = Color(0xFFE0E0E0);
const Color kErrorColor = Color(0xFFD32F2F);
const Color kSuccessColor = Color(0xFF388E3C);
const Color kWarningColor = Color(0xFFF57C00);

// Colores neón
const Color kNeonBlue = Color(0xFF00E5FF);
const Color kNeonPurple = Color(0xFF7C4DFF);

// --- ESTILOS DE TEXTO ---
const TextStyle kH1Style = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: kTextPrimary,
  letterSpacing: -0.5,
);

const TextStyle kH2Style = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextPrimary,
  letterSpacing: 0,
);

const TextStyle kH3Style = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: kTextPrimary,
  letterSpacing: 0.15,
);

const TextStyle kBodyStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: kTextPrimary,
  letterSpacing: 0.5,
);

const TextStyle kBodyBoldStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kTextPrimary,
  letterSpacing: 0.5,
);

const TextStyle kSmallBodyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: kTextSecondary,
  letterSpacing: 0.25,
);

const TextStyle kCaptionStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: kTextSecondary,
  letterSpacing: 0.4,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.25,
);

// --- FUNCIONES HELPER ---
InputDecoration getInputDecoration({
  required String label,
  String? hint,
  IconData? prefixIcon,
  Widget? suffixIcon, required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefixIcon != null 
      ? Icon(prefixIcon, color: kPrimaryColor, size: 22) 
      : null,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: kSurfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kDividerColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kDividerColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kErrorColor, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: kBodyStyle.copyWith(color: kTextSecondary),
    hintStyle: kSmallBodyStyle,
  );
}

List<BoxShadow> getCardShadow() {
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

List<BoxShadow> getNeonGlow(Color color) {
  return [
    BoxShadow(
      color: color.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}