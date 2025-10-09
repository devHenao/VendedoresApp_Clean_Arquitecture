import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_state.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client_form.dart';

class UpdateClientDialog extends StatelessWidget {
  final Client client;
  final UpdateClientBloc updateClientBloc;
  final VoidCallback onSuccess;

  const UpdateClientDialog({
    super.key,
    required this.client,
    required this.updateClientBloc,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateClientBloc, UpdateClientState>(
      bloc: updateClientBloc,
      listenWhen: (previous, current) => current is UpdateClientSuccess,
      listener: (context, state) => onSuccess(),
      child: AlertDialog(
        title: const Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Actualizar cliente',
            ),
            SizedBox(width: 5.0),
            Icon(
              Icons.edit_square,
              size: 29.0,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: BlocProvider.value(
              value: updateClientBloc,
              child: UpdateClientForm(client: client),
            ),
          ),
        ),
      ),
    );
  }
}
