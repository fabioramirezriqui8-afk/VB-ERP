/// Tipos de filtro soportados
enum FilterType { select, dateRange, numberRange }

/// Valor activo de un filtro
class AppFilterValue {
  const AppFilterValue({
    required this.key,
    required this.label,
    required this.displayValue,
    required this.rawValue,
  });

  final String key;          // mismo key que AppFilterDef
  final String label;        // label del filtro (ej: "Estado")
  final String displayValue; // texto para el chip (ej: "Activo")
  final dynamic rawValue;    // valor real para filtrar

  @override
  bool operator ==(Object other) =>
      other is AppFilterValue && other.key == key && other.displayValue == displayValue;

  @override
  int get hashCode => Object.hash(key, displayValue);
}

/// Definición de un filtro — describe cómo se renderiza y qué valores acepta
class AppFilterDef {
  const AppFilterDef({
    required this.key,
    required this.label,
    required this.type,
    this.options      = const [],  // para FilterType.select
    this.minValue,                 // para FilterType.numberRange
    this.maxValue,                 // para FilterType.numberRange
    this.numberSuffix = '',        // ej: "$", "kg"
  });

  final String     key;
  final String     label;
  final FilterType type;
  final List<String> options;
  final double?    minValue;
  final double?    maxValue;
  final String     numberSuffix;
}
