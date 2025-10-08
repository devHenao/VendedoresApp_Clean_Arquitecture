import 'package:flutter/material.dart';
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
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).cardColor,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            style: style ?? Theme.of(context).textTheme.bodyMedium,
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
            color: Theme.of(context).colorScheme.surfaceContainer,
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'Manrope',
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
            color: Theme.of(context).primaryColor,
            onPressed: onViewDetails,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.wallet,
            label: 'Cartera',
            color: Colors.green,
            onPressed: onViewWallet,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.pending_actions_rounded,
            label: 'Pendientes',
            color: const Color(0xFFF87C23),
            onPressed: onViewPending,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.content_paste_search_rounded,
            label: 'Ventas',
            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
            onPressed: onViewSales,
          ),
        ],
      ),
    );
  }
}
