import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/services/client_service.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_state.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/widgets/update_client_form.dart';

class UpdateClientPage extends StatefulWidget {
  const UpdateClientPage({Key? key}) : super(key: key);

  @override
  _UpdateClientPageState createState() => _UpdateClientPageState();
}

class _UpdateClientPageState extends State<UpdateClientPage> {
  final _formKey = UpdateClientFormKey();
  Client? _currentClient;

  @override
  void initState() {
    super.initState();
    
    // Obtener el cliente del servicio
    final clientService = Provider.of<ClientService>(context, listen: false);
    if (clientService.hasSelectedClient) {
      // Usar el cliente del servicio
      context.read<UpdateClientBloc>().add(
        SetClientEvent(clientService.selectedClient!)
      );
    } else {
      // Si no hay cliente seleccionado, mostrar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se ha seleccionado ningún cliente')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateClientBloc, UpdateClientState>(
      listener: (context, state) {
        if (state is UpdateClientLoaded && state.isSuccess) {
          Navigator.of(context).pop(state.client);
        } else if (state is UpdateClientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<UpdateClientBloc, UpdateClientState>(
        builder: (context, state) {
          if (state is UpdateClientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UpdateClientError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Obtener el cliente del servicio y volver a cargarlo
                      final clientService = Provider.of<ClientService>(context, listen: false);
                      if (clientService.hasSelectedClient) {
                        context.read<UpdateClientBloc>().add(
                          SetClientEvent(clientService.selectedClient!)
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is UpdateClientLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UpdateClientForm(
                    formKey: _formKey,
                    onClientUpdated: (client) {
                      _currentClient = client;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => _onSavePressed(context, state),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Método para manejar el guardado del formulario
  void _onSavePressed(BuildContext context, UpdateClientState state) {
    if (_formKey.key.currentState?.validate() ?? false) {
      _formKey.key.currentState?.save();
      if (_currentClient != null) {
        context.read<UpdateClientBloc>().add(
              UpdateClientSubmittedEvent(_currentClient!),
            );
      }
    }
  }
}
