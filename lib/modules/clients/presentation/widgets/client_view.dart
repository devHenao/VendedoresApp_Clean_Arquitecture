import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_state.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/client_card.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              context.read<ClientBloc>().add(SearchClients(value));
            },
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o documento',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ClientBloc, ClientState>(
            builder: (context, state) {
              if (state is ClientLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClientLoaded) {
                if (state.clients.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: state.clients.length,
                  itemBuilder: (context, index) {
                    final client = state.clients[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ClientCard(
                        client: client,
                        onViewDetails: () => _showClientDetails(context, client),
                        onViewWallet: () => _viewClientWallet(context, client),
                        onViewPending: () => _viewClientPending(context, client),
                        onViewSales: () => _viewClientSales(context, client),
                      ),
                    );
                  },
                );
              } else if (state is ClientError) {
                return _buildErrorState(context, state.message);
              }
              return _buildInitialState(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron clientes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los clientes',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<ClientBloc>().add(LoadClients());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Busca clientes por nombre o documento',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  void _showClientDetails(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIT: ${client.nit}'),
            if (client.tel1?.isNotEmpty ?? false) Text('Teléfono: ${client.tel1}'),
            if (client.email != null) Text('Email: ${client.email}'),
            if (client.direccion != null) Text('Dirección: ${client.direccion}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _viewClientWallet(BuildContext context, Client client) {
    // TODO: Implementar lógica para ver cartera del cliente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Visualizando cartera de ${client.nombre}')),
    );
  }

  void _viewClientPending(BuildContext context, Client client) {
    // TODO: Implementar lógica para ver pendientes del cliente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Visualizando pendientes de ${client.nombre}')),
    );
  }

  void _viewClientSales(BuildContext context, Client client) {
    // TODO: Implementar lógica para ver ventas del cliente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Visualizando ventas de ${client.nombre}')),
    );
  }
}
