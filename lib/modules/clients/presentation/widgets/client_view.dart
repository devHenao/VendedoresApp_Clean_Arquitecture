import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/shared/datePickers/date_range_selector_controller.dart';
import 'package:app_vendedores/shared/datePickers/date_range_selector_model.dart';
import 'package:app_vendedores/shared/datePickers/date_range_selector_widget.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_state.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_state.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';
import 'package:app_vendedores/modules/clients/presentation/controllers/client_controller.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/client_card.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final clientBloc = context.read<ClientBloc>();
    final downloadFileBloc = context.read<DownloadFileBloc>();
    final updateClientBloc = context.read<UpdateClientBloc>();
    final controller = ClientController(
      context, 
      clientBloc, 
      downloadFileBloc: downloadFileBloc,
      updateClientBloc: updateClientBloc,
    );

    return BlocListener<DownloadFileBloc, DownloadFileState>(
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
          downloadFileBloc.add(DownloadFileReset());
        }
      },
      child: BlocBuilder<DownloadFileBloc, DownloadFileState>(
        builder: (context, downloadState) {
          return BlocBuilder<ClientBloc, ClientState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Scaffold(
                    body: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                onChanged: controller.searchClients,
                                decoration: const InputDecoration(
                                  labelText: 'Buscar cliente por nombre o documento',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              DateRangeSelectorWidget(
                                controller: DateRangeSelectorController()
                                  ..updateStartDate(state.startDate)
                                  ..updateEndDate(state.endDate),
                                model: const DateRangeSelectorModel(
                                  title: 'Selecciona el rango de fechas para filtrar los reportes',
                                ),
                                onStartDateSelected: (date) => 
                                    controller.updateDateRange(startDate: date),
                                onEndDateSelected: (date) => 
                                    controller.updateDateRange(endDate: date),
                                onClearDates: controller.resetDateRange,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _buildClientList(context, state, controller),
                        ),
                      ],
                    ),
                  ),
                  if (downloadState.status == DownloadFileStatus.loading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildClientList(
    BuildContext context, 
    ClientState state,
    ClientController controller,
  ) {
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
              onViewDetails: () => controller.showClientDetails(client),
              onViewWallet: () => controller.viewClientWallet(client),
              onViewPending: () => controller.viewClientPending(client),
              onViewSales: () => controller.viewClientSales(client),
            ),
          );
        },
      );
    } else if (state is ClientError) {
      return _buildErrorState(context, state.message);
    }
    return _buildInitialState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
}