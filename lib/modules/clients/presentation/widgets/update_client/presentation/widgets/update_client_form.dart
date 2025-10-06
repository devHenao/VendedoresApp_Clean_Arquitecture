import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_event.dart';

class UpdateClientForm extends StatefulWidget {
  final Client client;
  const UpdateClientForm({super.key, required this.client});

  @override
  State<UpdateClientForm> createState() => _UpdateClientFormState();
}

class _UpdateClientFormState extends State<UpdateClientForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    context.read<UpdateClientBloc>().add(SetClientEvent(widget.client));
    _nameController = TextEditingController(text: widget.client.nombre);
    _emailController = TextEditingController(text: widget.client.email);
    _phoneController = TextEditingController(text: widget.client.tel1);
    _addressController = TextEditingController(text: widget.client.direccion);
  }

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
        if (state is UpdateClientLoaded && state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente actualizado con éxito')),
          );
          Navigator.of(context).pop(true); // Indicar que la actualización fue exitosa
        } else if (state is UpdateClientLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        if (state is UpdateClientLoading || state is UpdateClientInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpdateClientLoaded) {
          _updateControllers(state.client);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final updatedClient = _createUpdatedClient(state);
                              context.read<UpdateClientBloc>().add(
                                    UpdateClientSubmittedEvent(updatedClient),
                                  );
                            }
                          },
                    child: state.isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Actualizar'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UpdateClientError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Estado no manejado'));
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
      validator: (value) {
        if (value == null || value.isEmpty) return 'El nombre es requerido';
        return null;
      },
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
        if (value == null || value.isEmpty) return 'El email es requerido';
        if (!value.contains('@')) return 'Email inválido';
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
    final selectedValue = state.departments.toSet().contains(state.selectedDepartment)
        ? state.selectedDepartment
        : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Departamento',
        border: OutlineInputBorder(),
      ),
      items: state.departments.toSet()
          .map((dept) => DropdownMenuItem(
                value: dept,
                child: Text(dept),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<UpdateClientBloc>().add(DepartmentChangedEvent(value));
        }
      },
      validator: (value) =>
          value == null ? 'Por favor seleccione un departamento' : null,
    );
  }

  Widget _buildCityDropdown(UpdateClientLoaded state) {
    final selectedValue = state.cities.toSet().contains(state.selectedCity)
        ? state.selectedCity
        : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Ciudad',
        border: OutlineInputBorder(),
      ),
      items: state.cities.toSet()
          .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<UpdateClientBloc>().add(CityChangedEvent(value));
        }
      },
      validator: (value) =>
          value == null ? 'Por favor seleccione una ciudad' : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Dirección',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _updateControllers(Client client) {
    if (_nameController.text != client.nombre) {
      _nameController.text = client.nombre;
    }
    if (_emailController.text != client.email) {
      _emailController.text = client.email ?? '';
    }
    if (_phoneController.text != client.tel1) {
      _phoneController.text = client.tel1 ?? '';
    }
    if (_addressController.text != client.direccion) {
      _addressController.text = client.direccion ?? '';
    }
  }

  Client _createUpdatedClient(UpdateClientLoaded state) {
    return widget.client.copyWith(
      nombre: _nameController.text,
      email: _emailController.text,
      tel1: _phoneController.text,
      direccion: _addressController.text,
      nomdpto: state.selectedDepartment,
      nomciud: state.selectedCity,
    );
  }
}
