import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AvatarUser {
  const AvatarUser({required this.name, this.avatarUrl, this.color});
  final String name;
  final String? avatarUrl;
  final Color? color;
}

class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({
    super.key,
    required this.users,
    this.maxVisible = 4,
    this.size       = 32.0,
    this.onTap,
  });

  final List<AvatarUser> users;
  final int maxVisible;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final visible  = users.take(maxVisible).toList();
    final overflow = users.length - maxVisible;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size,
        width:  size * 0.7 * visible.length +
                (overflow > 0 ? size * 0.7 : 0) +
                size * 0.3,
        child: Stack(
          children: [
            ...visible.asMap().entries.map((e) => Positioned(
                  left: e.key * size * 0.7,
                  child: _Avatar(user: e.value, size: size),
                )),
            if (overflow > 0)
              Positioned(
                left: visible.length * size * 0.7,
                child: _OverflowAvatar(count: overflow, size: size),
              ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user, required this.size});
  final AvatarUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: user.name,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: user.color ?? AppColors.primary,
        ),
        child: ClipOval(
          child: user.avatarUrl != null
              ? Image.network(user.avatarUrl!, fit: BoxFit.cover)
              : Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _OverflowAvatar extends StatelessWidget {
  const _OverflowAvatar({required this.count, required this.size});
  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: AppColors.borderStrong,
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
