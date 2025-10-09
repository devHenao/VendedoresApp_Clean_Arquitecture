import 'package:app_vendedores/core/theme/theme.dart';
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
              content:
                  Text(state.errorMessage ?? 'Error al descargar el archivo'),
              backgroundColor: GlobalTheme.of(context).error,
            ),
          );
        } else if (state.status == DownloadFileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Archivo descargado correctamente'),
              backgroundColor: GlobalTheme.of(context).success,
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
                                decoration: InputDecoration(
                                  labelText:
                                      'Buscar cliente por nombre o documento',
                                  labelStyle: GlobalTheme.of(context).labelMedium,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: GlobalTheme.of(context).secondaryText,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                      color: GlobalTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                      color: GlobalTheme.of(context).primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: GlobalTheme.of(context).bodyMedium,
                              ),
                              const SizedBox(height: 16.0),
                              DateRangeSelectorWidget(
                                controller: DateRangeSelectorController()
                                  ..updateStartDate(state.startDate)
                                  ..updateEndDate(state.endDate),
                                model: const DateRangeSelectorModel(
                                  title:
                                      'Selecciona el rango de fechas para filtrar los reportes',
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
                      color: GlobalTheme.of(context).accent4,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: GlobalTheme.of(context).primary,
                        ),
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
            color: GlobalTheme.of(context).secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron clientes',
            style: GlobalTheme.of(context).titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: GlobalTheme.of(context).bodyMedium,
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
              color: GlobalTheme.of(context).error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los clientes',
              style: GlobalTheme.of(context).titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GlobalTheme.of(context).bodyMedium,
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
            color: GlobalTheme.of(context).secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'Busca clientes por nombre o documento',
            style: GlobalTheme.of(context).titleMedium,
          ),
        ],
      ),
    );
  }
}
