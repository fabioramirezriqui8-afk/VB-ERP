import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class UploadedFile {
  const UploadedFile({required this.name, required this.size, this.url});
  final String name;
  final int size; // bytes
  final String? url;

  String get sizeLabel {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class AppFileUpload extends StatelessWidget {
  const AppFileUpload({
    super.key,
    required this.onTap,
    this.files        = const [],
    this.onRemove,
    this.label        = 'Adjuntar archivos',
    this.hint         = 'PDF, JPG, PNG — máx. 10MB',
    this.accept       = const ['pdf', 'jpg', 'png'],
    this.maxFiles     = 5,
    this.isLoading    = false,
    this.errorText,
  });

  final VoidCallback onTap;
  final List<UploadedFile> files;
  final void Function(UploadedFile)? onRemove;
  final String label;
  final String hint;
  final List<String> accept;
  final int maxFiles;
  final bool isLoading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final canAdd = files.length < maxFiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Zona de drop / botón
        if (canAdd)
          InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xl2,
                horizontal: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText != null
                      ? AppColors.error
                      : AppColors.border,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surfaceElevated,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(label, style: AppTypography.labelMd),
                  const SizedBox(height: 2),
                  Text(hint, style: AppTypography.caption),
                ],
              ),
            ),
          ),

        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(errorText!,
              style: AppTypography.bodySm.copyWith(color: AppColors.error)),
        ],

        // Lista de archivos subidos
        if (files.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ...files.map((f) => _FileItem(file: f, onRemove: onRemove)),
        ],
      ],
    );
  }
}

class _FileItem extends StatelessWidget {
  const _FileItem({required this.file, this.onRemove});
  final UploadedFile file;
  final void Function(UploadedFile)? onRemove;

  IconData get _icon {
    final ext = file.name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf'  => Icons.picture_as_pdf_outlined,
      'jpg' || 'jpeg' || 'png' || 'gif' => Icons.image_outlined,
      'xls' || 'xlsx' => Icons.table_chart_outlined,
      _      => Icons.insert_drive_file_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical:   AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(_icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    style: AppTypography.labelMd,
                    overflow: TextOverflow.ellipsis),
                Text(file.sizeLabel, style: AppTypography.caption),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () => onRemove!(file),
              color: AppColors.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
        ],
      ),
    );
  }
}
