import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_event.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

class UpdateClientFormKey {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
}

typedef OnClientUpdated = void Function(Client client);

class UpdateClientForm extends StatefulWidget {
  final UpdateClientFormKey formKey;
  final OnClientUpdated? onClientUpdated;
  
  const UpdateClientForm({
    Key? key,
    required this.formKey,
    this.onClientUpdated,
  }) : super(key: key);

  @override
  _UpdateClientFormState createState() => _UpdateClientFormState();
}

class _UpdateClientFormState extends State<UpdateClientForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateClientBloc, UpdateClientState>(
      listener: (context, state) {
        if (state is UpdateClientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UpdateClientLoaded) {
          _updateControllers(state.client);
          
          return Form(
            key: widget.formKey.key,
            onChanged: () {
              // Actualizar el cliente cuando cambie algún campo
              if (widget.onClientUpdated != null) {
                final updatedClient = _createUpdatedClient(state.client, state);
                widget.onClientUpdated!(updatedClient);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildDepartmentDropdown(state),
                const SizedBox(height: 16),
                _buildCityDropdown(state),
                const SizedBox(height: 16),
                _buildAddressField(),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'El nombre es requerido' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'El email es requerido';
        if (!value!.contains('@')) return 'Email inválido';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Teléfono',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildDepartmentDropdown(UpdateClientLoaded state) {
    return DropdownButtonFormField<String>(
      value: state.selectedDepartment,
      decoration: const InputDecoration(
        labelText: 'Departamento',
        border: OutlineInputBorder(),
      ),
      items: state.departments
          .map((dept) => DropdownMenuItem(
                value: dept,
                child: Text(dept),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context
              .read<UpdateClientBloc>()
              .add(DepartmentChangedEvent(value));
        }
      },
      validator: (value) =>
          value == null ? 'Por favor seleccione un departamento' : null,
    );
  }

  Widget _buildCityDropdown(UpdateClientLoaded state) {
    return DropdownButtonFormField<String>(
      value: state.selectedCity,
      decoration: const InputDecoration(
        labelText: 'Ciudad',
        border: OutlineInputBorder(),
      ),
      items: state.cities
          .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
          .toList(),
      onChanged: state.cities.isEmpty
          ? null
          : (value) {
              if (value != null) {
                context.read<UpdateClientBloc>().add(CityChangedEvent(value));
              }
            },
      validator: (value) => value == null ? 'Por favor seleccione una ciudad' : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Dirección',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  void _updateControllers(Client client) {
    _nameController.text = client.nombre;
    _emailController.text = client.email ?? '';
    _phoneController.text = client.tel1 ?? '';
    _addressController.text = client.direccion ?? '';
  }

  Client _createUpdatedClient(Client currentClient, UpdateClientState state) {
    if (state is! UpdateClientLoaded) {
      throw Exception('Estado no válido para actualizar el cliente');
    }
    
    return currentClient.copyWith(
      nombre: _nameController.text.trim(),
      email: _emailController.text.trim(),
      tel1: _phoneController.text.trim(),
      direccion: _addressController.text.trim(),
      nomciud: state.selectedCity,
      nomdpto: state.selectedDepartment,
    );
  }
}
