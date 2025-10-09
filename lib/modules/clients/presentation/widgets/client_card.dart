import 'package:flutter/material.dart';
import 'package:app_vendedores/core/theme/theme.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onViewDetails;
  final VoidCallback? onViewWallet;
  final VoidCallback? onViewPending;
  final VoidCallback? onViewSales;

  const ClientCard({
    super.key,
    required this.client,
    this.onViewDetails,
    this.onViewWallet,
    this.onViewPending,
    this.onViewSales,
  });

  @override
  Widget build(BuildContext context) {
    final colors = GlobalTheme.of(context);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: colors.secondaryBackground,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    client.nit,
                    style: colors.titleMedium.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                  ),
                  _buildInfoRow(context, client.nombre),
                  if (client.contacto?.isNotEmpty ?? false)
                    _buildInfoRow(context, 'Contacto: ${client.contacto}'),
                  if (client.tel1?.isNotEmpty ?? false)
                    _buildInfoRow(context, 'Teléfono: ${client.tel1}'),
                  if (client.email?.isNotEmpty ?? false)
                    _buildInfoRow(
                      context,
                      'Email: ${client.email}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (client.direccion?.isNotEmpty ?? false)
                    _buildInfoRow(
                      context,
                      'Dirección: ${client.direccion}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Divider(thickness: 2.0),
                  _buildActionButtons(context),
                ].map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: e,
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String text, {
    TextStyle? style,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.clip,
  }) {
    if (text.isEmpty) return const SizedBox.shrink();
    
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            text,
            style: style ?? GlobalTheme.of(context).bodyMedium,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: GlobalTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: color, size: 30.0),
            onPressed: onPressed,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: GlobalTheme.of(context).bodySmall.copyWith(
                fontSize: 12.0,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.remove_red_eye_rounded,
            label: 'Detalle',
            color: GlobalTheme.of(context).primary,
            onPressed: onViewDetails,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.wallet,
            label: 'Cartera',
            color: GlobalTheme.of(context).success,
            onPressed: onViewWallet,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.pending_actions_rounded,
            label: 'Pendientes',
            color: GlobalTheme.of(context).warning,
            onPressed: onViewPending,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.content_paste_search_rounded,
            label: 'Ventas',
            color: GlobalTheme.of(context).secondaryText,
            onPressed: onViewSales,
          ),
        ],
      ),
    );
  }
}
