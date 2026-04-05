import 'package:flutter/material.dart';

/// Escala de radios — "slightly sharp edge" según el design system
/// md = 0.375rem ≈ 6px | xl = 0.75rem ≈ 12px
abstract class AppRadius {
  static const double xs   = 2.0;
  static const double sm   = 4.0;
  static const double md   = 6.0;   // botones, inputs, chips
  static const double lg   = 8.0;
  static const double xl   = 12.0;  // cards, modales
  static const double xl2  = 16.0;
  static const double full = 999.0;

  static const BorderRadius card    = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius button  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius input   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip    = BorderRadius.all(Radius.circular(full));
  static const BorderRadius dialog  = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius listItem = BorderRadius.all(Radius.circular(md));

  // Alias para compatibilidad
  static const BorderRadius cardRadius   = card;
  static const BorderRadius buttonRadius = button;
  static const BorderRadius inputRadius  = input;
  static const BorderRadius chipRadius   = chip;
  static const BorderRadius dialogRadius = dialog;
}
