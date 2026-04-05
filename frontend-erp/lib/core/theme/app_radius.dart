import 'package:flutter/material.dart';

/// Border radius consistentes en toda la app.
abstract class AppRadius {
  static const double xs  = 4.0;
  static const double sm  = 6.0;
  static const double md  = 8.0;
  static const double lg  = 12.0;
  static const double xl  = 16.0;
  static const double xl2 = 24.0;
  static const double full = 999.0;

  static const BorderRadius cardRadius    = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius buttonRadius  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius inputRadius   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chipRadius    = BorderRadius.all(Radius.circular(full));
  static const BorderRadius dialogRadius  = BorderRadius.all(Radius.circular(xl));
}
