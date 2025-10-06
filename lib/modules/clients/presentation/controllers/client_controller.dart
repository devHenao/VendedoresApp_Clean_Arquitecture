import 'package:flutter/material.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';
import 'package:app_vendedores/shared/confirmDialog/confirmation_dialog.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/update_client_widget.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';

class ClientController {
  final BuildContext context;
  final ClientBloc clientBloc;
  final DownloadFileBloc downloadFileBloc;

  ClientController(this.context, this.clientBloc, {required this.downloadFileBloc});

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
    // Convert Client to DataClienteStruct using the createDataClienteStruct helper
    final dataClient = createDataClienteStruct(
      nombre: client.nombre,
      nit: client.nit,
      tel1: client.tel1,
      email: client.email,
      direccion: client.direccion,
      // Set default values for required fields
      tipoCar: 'C',  // Default value for tipoCar
      codigoCta: client.nit,  // Using NIT as codigoCta
      vendedor: '',  // Empty default
      cdciiu: '',    // Empty default
      contacto: '',  // Empty default
      codprecio: '1', // Default price code
      nomciud: '',   // Empty default
      nomdpto: '',   // Empty default
    );
    
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: UpdateClientWidget(
          dataClients: dataClient,
          updated: () async {
            // Refresh client list or perform any action after update
            // For example: clientBloc.add(LoadClients());
            Navigator.of(context).pop(); // Close the dialog after update
            return; // Explicit return to satisfy the Future return type
          },
        ),
      ),
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
    return; // Explicitly return void
  }
}
