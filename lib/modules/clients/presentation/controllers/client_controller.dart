import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';
import 'package:app_vendedores/modules/clients/domain/services/client_service.dart';
import 'package:app_vendedores/shared/confirmDialog/confirmation_dialog.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client_form.dart';

class ClientController {
  final BuildContext context;
  final ClientBloc clientBloc;
  final DownloadFileBloc downloadFileBloc;
  final UpdateClientBloc updateClientBloc;

  ClientController(
    this.context,
    this.clientBloc,
    {required this.downloadFileBloc, required this.updateClientBloc}
  );

  void searchClients(String query) {
    clientBloc.add(SearchClients(query));
  }

  void updateDateRange({DateTime? startDate, DateTime? endDate}) {
    final currentState = clientBloc.state;
    clientBloc.add(
      UpdateDateRange(
        startDate: startDate ?? currentState.startDate,
        endDate: endDate ?? currentState.endDate,
      ),
    );
  }

  void resetDateRange() {
    clientBloc.add(UpdateDateRange(startDate: null, endDate: null));
  }

  void showClientDetails(Client client) {
    final clientService = Provider.of<ClientService>(context, listen: false);
    clientService.setSelectedClient(client);

    try {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Editar Cliente'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(dialogContext).size.width * 0.9,
                child: BlocProvider.value(
                  value: updateClientBloc,
                  child: UpdateClientForm(client: client),
                ),
              ),
            ),
          );
        },
      ).then((_) {
        clientService.clearSelectedClient();
        if (context.mounted) {
          clientBloc.add(LoadClients());
        }
      });
    } catch (e) {
      debugPrint('Error al mostrar el diálogo: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el formulario de edición: $e')),
        );
      }
    }
  }

  Future<void> viewClientWallet(Client client) async {
    await _showConfirmationDialog(
      title: 'Descargar Cartera',
      content: '¿Desea descargar el estado de cartera de ${client.nombre}?',
      onConfirm: () {
        downloadFileBloc.add(DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.wallet,
        ));
      },
    );
  }

  Future<void> viewClientPending(Client client) async {
    await _showConfirmationDialog(
      title: 'Descargar Pedidos Pendientes',
      content: '¿Desea descargar los pedidos pendientes de ${client.nombre}?',
      onConfirm: () {
        downloadFileBloc.add(DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.orders,
          startDate: clientBloc.state.startDate,
          endDate: clientBloc.state.endDate,
        ));
      },
    );
  }

  Future<void> viewClientSales(Client client) async {
    await _showConfirmationDialog(
      title: 'Descargar Ventas',
      content: '¿Desea descargar el historial de Ventas de ${client.nombre}?',
      onConfirm: () {
        downloadFileBloc.add(DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.sales,
          startDate: clientBloc.state.startDate,
          endDate: clientBloc.state.endDate,
        ));
      },
    );
  }

  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) async {
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
