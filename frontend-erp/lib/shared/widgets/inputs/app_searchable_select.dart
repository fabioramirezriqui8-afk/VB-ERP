import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppSearchableSelect<T> extends StatefulWidget {
  const AppSearchableSelect({
    super.key,
    required this.options,
    required this.onChanged,
    required this.labelBuilder,
    this.value,
    this.label,
    this.hint       = 'Buscar...',
    this.errorText,
    this.enabled    = true,
    this.validator,
  });

  final List<T> options;
  final ValueChanged<T?> onChanged;
  final String Function(T) labelBuilder;
  final T? value;
  final String? label;
  final String hint;
  final String? errorText;
  final bool enabled;
  final FormFieldValidator<T>? validator;

  @override
  State<AppSearchableSelect<T>> createState() => _AppSearchableSelectState<T>();
}

class _AppSearchableSelectState<T> extends State<AppSearchableSelect<T>> {
  final _controller = TextEditingController();
  final _layerLink  = LayerLink();
  OverlayEntry? _overlay;
  List<T> _filtered = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
    if (widget.value != null) {
      _controller.text = widget.labelBuilder(widget.value as T);
    }
  }

  void _openDropdown() {
    if (_isOpen) return;
    _isOpen = true;
    _overlay = _buildOverlay();
    Overlay.of(context).insert(_overlay!);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    _isOpen  = false;
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = widget.options
          .where((o) => widget.labelBuilder(o)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
    _overlay?.markNeedsBuild();
  }

  void _select(T option) {
    _controller.text = widget.labelBuilder(option);
    widget.onChanged(option);
    _closeDropdown();
  }

  OverlayEntry _buildOverlay() {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link:       _layerLink,
          showWhenUnlinked: false,
          offset:     Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: _filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text('Sin resultados', style: AppTypography.bodyMd),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final opt = _filtered[i];
                        return InkWell(
                          onTap: () => _select(opt),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical:   AppSpacing.md,
                            ),
                            child: Text(widget.labelBuilder(opt),
                                style: AppTypography.bodyMd),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller:  _controller,
        enabled:     widget.enabled,
        style:       AppTypography.bodyMd,
        onChanged:   _onSearch,
        onTap:       _openDropdown,
        validator:   widget.validator != null
            ? (_) => widget.validator!(widget.value)
            : null,
        decoration: InputDecoration(
          labelText:  widget.label,
          hintText:   widget.hint,
          errorText:  widget.errorText,
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: widget.value != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged(null);
                    setState(() => _filtered = widget.options);
                  },
                )
              : const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
