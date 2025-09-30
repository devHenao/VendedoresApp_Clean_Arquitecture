import 'package:app_vendedores/shared/datePickers/date_range_selector_controller.dart';
import 'package:app_vendedores/shared/datePickers/date_range_selector_model.dart';
import 'package:app_vendedores/shared/datePickers/date_range_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_state.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_state.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/client_card.dart';
import 'package:app_vendedores/shared/confirmDialog/confirmation_dialog.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DownloadFileBloc, DownloadFileState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == DownloadFileStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error al descargar el archivo'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (state.status == DownloadFileStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archivo descargado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
              // Resetear el estado después de mostrar el mensaje
              context.read<DownloadFileBloc>().add(DownloadFileReset());
            }
          },
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Buscador
                    TextField(
                      onChanged: (value) {
                        context.read<ClientBloc>().add(SearchClients(value));
                      },
                      decoration: const InputDecoration(
                        labelText: 'Buscar cliente',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Selector de rango de fechas
                    DateRangeSelectorWidget(
                      controller: DateRangeSelectorController()
                        ..updateStartDate(state.startDate)
                        ..updateEndDate(state.endDate),
                      model: const DateRangeSelectorModel(
                        title: 'Selecciona el rango de fechas para filtrar los reportes',
                        startDateLabel: 'Fecha de inicio',
                        endDateLabel: 'Fecha de fin',
                      ),
                      onStartDateSelected: (date) {
                        context.read<ClientBloc>().add(UpdateDateRange(
                          startDate: date,
                          endDate: state.endDate,
                        ));
                      },
                      onEndDateSelected: (date) {
                        context.read<ClientBloc>().add(UpdateDateRange(
                          startDate: state.startDate,
                          endDate: date,
                        ));
                      },
                      onClearDates: () {
                        context.read<ClientBloc>().add(const UpdateDateRange(
                          startDate: null,
                          endDate: null,
                        ));
                      },
                    ),
                  ],
                );
              },
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
        ),
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
    _showDownloadConfirmationDialog(
      context,
      'Descargar cartera',
      '¿Desea descargar el reporte de cartera de ${client.nombre}?',
      () => _downloadFile(context, client, DownloadType.wallet),
    );
  }

  Future<void> _viewClientPending(BuildContext context, Client client) async {
    final state = context.read<ClientBloc>().state;
    final result = await ConfirmationDialog.show(
      context: context,
      title: 'Descargar pendientes',
      content: '¿Desea descargar el reporte de pendientes de ${client.nombre}?',
      confirmText: 'Descargar',
    );
    
    if (result == true) {
      _downloadFile(
        context,
        client,
        DownloadType.orders,
        startDate: state.startDate,
        endDate: state.endDate,
      );
    }
  }

  Future<void> _viewClientSales(BuildContext context, Client client) async {
    final state = context.read<ClientBloc>().state;
    final result = await ConfirmationDialog.show(
      context: context,
      title: 'Descargar ventas',
      content: '¿Desea descargar el reporte de ventas de ${client.nombre}?',
      confirmText: 'Descargar',
    );
    
    if (result == true) {
      _downloadFile(
        context,
        client,
        DownloadType.sales,
        startDate: state.startDate,
        endDate: state.endDate,
      );
    }
  }

  void _downloadFile(
    BuildContext context,
    Client client,
    DownloadType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    context.read<DownloadFileBloc>().add(
          DownloadFileRequested(
            clientId: client.nit,
            type: type,
            startDate: startDate,
            endDate: endDate,
          ),
        );
  }

  Future<void> _showDownloadConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) async {
    final result = await ConfirmationDialog.show(
      context: context,
      title: title,
      content: content,
      confirmText: 'Descargar',
      cancelText: 'Cancelar',
    );
    
    if (result == true) {
      onConfirm();
    }
  }

}
