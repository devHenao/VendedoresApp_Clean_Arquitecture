import 'package:app_vendedores/core/theme/theme.dart';
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
      listenWhen: (previous, current) {
        if (previous is UpdateClientLoaded && current is UpdateClientLoaded) {
          return !previous.isSuccess && current.isSuccess;
        }
        return false;
      },
      listener: (context, state) => onSuccess(),
      child: AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Actualizar cliente',
              style: GlobalTheme.of(context).headlineSmall,
            ),
            const SizedBox(width: 5.0),
            Icon(
              Icons.edit_square,
              color: GlobalTheme.of(context).secondaryText,
              size: 29.0,
            ),
          ],
        ),
        backgroundColor: GlobalTheme.of(context).secondaryBackground,
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
