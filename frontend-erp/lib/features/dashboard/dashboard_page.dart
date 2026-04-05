import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../identity/auth/domain/auth_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.user});
  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Text('Hola, ${user.name.split(' ').first} 👋',
              style: AppTypography.h2),
          const SizedBox(height: AppSpacing.xs),
          Text('Aquí tienes el resumen del día',
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.textSecondary)),

          const SizedBox(height: AppSpacing.xl3),

          // KPIs
          LayoutBuilder(builder: (_, constraints) {
            final cols = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 600
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap:     true,
              physics:        const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing:  AppSpacing.lg,
              childAspectRatio: 1.6,
              children: const [
                AppStatCard(
                  title:      'Ventas del mes',
                  value:      'S/ 48,320',
                  subtitle:   'Abril 2026',
                  trend:      StatTrend.up,
                  trendLabel: '+12% vs marzo',
                  icon:       Icons.trending_up,
                  iconColor:  AppColors.success,
                ),
                AppStatCard(
                  title:      'Facturas pendientes',
                  value:      '23',
                  subtitle:   'Por cobrar',
                  trend:      StatTrend.down,
                  trendLabel: '-3 vs ayer',
                  icon:       Icons.receipt_long_outlined,
                  iconColor:  AppColors.warning,
                ),
                AppStatCard(
                  title:      'Productos en stock',
                  value:      '1,284',
                  subtitle:   '12 con stock bajo',
                  trend:      StatTrend.neutral,
                  trendLabel: 'Sin cambios',
                  icon:       Icons.inventory_2_outlined,
                  iconColor:  AppColors.info,
                ),
                AppStatCard(
                  title:      'Órdenes de compra',
                  value:      '7',
                  subtitle:   'Pendientes de recibir',
                  trend:      StatTrend.up,
                  trendLabel: '+2 nuevas hoy',
                  icon:       Icons.shopping_cart_outlined,
                  iconColor:  AppColors.primary,
                ),
              ],
            );
          }),

          const SizedBox(height: AppSpacing.xl3),

          // Actividad reciente
          AppCard(
            title:    'Actividad reciente',
            subtitle: 'Últimas acciones en el sistema',
            child: AppTimeline(events: const [
              TimelineEvent(
                title:       'Factura #F-0089 emitida',
                date:        'Hace 5 min',
                actor:       'Por: Carlos Mendoza',
                icon:        Icons.receipt_outlined,
                iconColor:   AppColors.success,
              ),
              TimelineEvent(
                title:       'Stock ajustado — Producto SKU-441',
                date:        'Hace 1h',
                actor:       'Por: Ana Torres',
                description: 'Ajuste de +50 unidades por inventario físico',
                icon:        Icons.warehouse_outlined,
                iconColor:   AppColors.info,
              ),
              TimelineEvent(
                title:       'Orden de compra #OC-0034 aprobada',
                date:        'Hace 2h',
                actor:       'Por: Luis García',
                icon:        Icons.check_circle_outline,
                iconColor:   AppColors.primary,
              ),
              TimelineEvent(
                title:       'Usuario "María López" creado',
                date:        'Hace 3h',
                actor:       'Por: Administrador',
                icon:        Icons.person_add_outlined,
                iconColor:   AppColors.secondary,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
