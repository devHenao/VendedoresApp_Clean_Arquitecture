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
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/pages/update_client_page.dart';

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
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    updateDateRange(startDate: firstDay, endDate: lastDay);
  }

  void viewClientWallet(Client client) {
    _showConfirmationDialog(
      title: 'Descargar cartera',
      content: '¿Desea descargar el reporte de cartera de ${client.nombre}?',
      onConfirm: () => downloadFileBloc.add(
        DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.wallet,
        ),
      ),
    );
  }

  void viewClientPending(Client client) {
    final state = clientBloc.state;
    _showConfirmationDialog(
      title: 'Descargar pendientes',
      content: '¿Desea descargar el reporte de pendientes de ${client.nombre}?',
      onConfirm: () => downloadFileBloc.add(
        DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.orders,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  void viewClientSales(Client client) {
    final state = clientBloc.state;
    _showConfirmationDialog(
      title: 'Descargar ventas',
      content: '¿Desea descargar el reporte de Ventas de ${client.nombre}?',
      onConfirm: () => downloadFileBloc.add(
        DownloadFileRequested(
          clientId: client.nit,
          type: DownloadType.sales,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> showClientDetails(Client client) async {
    try {
      // Obtener el servicio de clientes
      final clientService = Provider.of<ClientService>(context, listen: false);
      
      // Establecer el cliente seleccionado
      clientService.setSelectedClient(client);
      
      // Mostrar el diálogo
      await showDialog<Client?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Editar Cliente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(dialogContext).size.width * 0.8,
                    child: BlocProvider.value(
                      value: updateClientBloc,
                      child: const UpdateClientPage(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        // Limpiar el cliente seleccionado
        clientService.clearSelectedClient();
        
        // Recargar la lista de clientes después de cerrar el diálogo
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
    return; // Explicitly return void
  }
}
