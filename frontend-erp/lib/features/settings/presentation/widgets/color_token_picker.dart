import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Solo el picker de un token de color — sin lógica de tema
class ColorTokenPicker extends StatelessWidget {
  const ColorTokenPicker({
    super.key,
    required this.label,
    required this.description,
    required this.color,
    required this.onChanged,
    this.swatches = const [],
  });

  final String label;
  final String description;
  final Color color;
  final ValueChanged<Color> onChanged;
  final List<Color> swatches; // colores sugeridos

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Muestra del color actual
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color:        color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:      color.withOpacity(0.4),
                      blurRadius: 8,
                      offset:     const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Text(label, style: AppTypography.labelLg.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
                        ),
                        child: Text(
                          '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                          style: AppTypography.code.copyWith(fontSize: 10, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(description,
                      style: AppTypography.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      )),
                ],
              ),
            ),
          ],
        ),

        // Swatches sugeridos
        if (swatches.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: swatches.map((s) => GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color:        s,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: s == color
                        ? Colors.white
                        : Colors.white.withOpacity(0.1),
                    width: s == color ? 2 : 1,
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ColorPickerDialog(
        initial:   color,
        onChanged: onChanged,
      ),
    );
  }
}

// ── Dialog de color picker ────────────────────────────────────────────────────

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initial, required this.onChanged});
  final Color initial;
  final ValueChanged<Color> onChanged;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selected;
  final _hexCtrl = TextEditingController();

  // Paleta de colores predefinidos
  static const _palette = [
    Color(0xFF4A148C), Color(0xFF6A1B9A), Color(0xFF7B1FA2), Color(0xFF8E24AA),
    Color(0xFF1565C0), Color(0xFF0277BD), Color(0xFF00838F), Color(0xFF00695C),
    Color(0xFF2E7D32), Color(0xFF558B2F), Color(0xFFF57F17), Color(0xFFE65100),
    Color(0xFFBF360C), Color(0xFFC62828), Color(0xFF37474F), Color(0xFF263238),
    Color(0xFF121212), Color(0xFF1C1B1B), Color(0xFF2A2A2A), Color(0xFFFFFFFF),
    Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0), Color(0xFFCBD5E1),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _hexCtrl.text = '#${_selected.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _selectColor(Color c) {
    setState(() {
      _selected = c;
      _hexCtrl.text = '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
    });
  }

  void _applyHex(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        _selectColor(Color(int.parse('FF$clean', radix: 16)));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: cs.surface,
      surfaceTintColor: cs.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text('Personalizar Color', style: AppTypography.h4),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preview
            Container(
              height: 80,
              decoration: BoxDecoration(
                color:        _selected,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: _selected.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Center(
                child: Text(
                  '#${_selected.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(
                    color: _selected.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Hex input
            TextField(
              controller:  _hexCtrl,
              style: AppTypography.code,
              decoration: InputDecoration(
                labelText: 'Código Hexadecimal',
                prefixText: '# ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: cs.surfaceContainerLow,
              ),
              onSubmitted: _applyHex,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Paleta
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Sugerencias', style: AppTypography.labelSm.copyWith(color: cs.onSurface.withOpacity(0.5))),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: _palette.map((c) => GestureDetector(
                onTap: () => _selectColor(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color:        c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c == _selected
                          ? cs.primary
                          : Colors.white.withOpacity(0.1),
                      width: c == _selected ? 3 : 1,
                    ),
                    boxShadow: c == _selected ? [BoxShadow(color: c.withOpacity(0.4), blurRadius: 10)] : null,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.lg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: cs.onSurface.withOpacity(0.6)),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onChanged(_selected);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
