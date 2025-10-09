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
      listenWhen: (previous, current) => current is UpdateClientSuccess,
      listener: (context, state) => onSuccess(),
      child: Dialog(
        backgroundColor: GlobalTheme.of(context).transparent,
        elevation: 0,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: GlobalTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_square,
                  color: GlobalTheme.of(context).primary,
                  size: 48.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Actualizar Cliente',
                  textAlign: TextAlign.center,
                  style: GlobalTheme.of(context).headlineSmall,
                ),
                const SizedBox(height: 24.0),
                BlocProvider.value(
                  value: updateClientBloc,
                  child: UpdateClientForm(client: client),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
