import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_state.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              context.read<ClientBloc>().add(SearchClients(value));
            },
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o documento',
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ClientBloc, ClientState>(
            builder: (context, state) {
              if (state is ClientLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClientLoaded) {
                if (state.clients.isEmpty) {
                  return const Center(child: Text('No se encontraron clientes'));
                }
                return ListView.builder(
                  itemCount: state.clients.length,
                  itemBuilder: (context, index) {
                    final client = state.clients[index];
                    return ListTile(
                      title: Text(client.nombre),
                      subtitle: Text(client.nit),
                      onTap: () {
                        // Handle client selection
                      },
                    );
                  },
                );
              } else if (state is ClientError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Cargando clientes...'));
            },
          ),
        ),
      ],
    );
  }
}
