import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late TextEditingController _documentoController;
  late TextEditingController _contactoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.nombre ?? '');
    _emailController = TextEditingController(text: widget.client.email ?? '');
    _phoneController = TextEditingController(text: widget.client.tel1 ?? '');
    _addressController = TextEditingController(text: widget.client.direccion ?? '');
    _documentoController = TextEditingController(text: widget.client.nit ?? '');
    _contactoController = TextEditingController(text: widget.client.contacto ?? '');
    
    // Initialize the form with the client data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateClientBloc>().add(SetClientEvent(widget.client));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _documentoController.dispose();
    _contactoController.dispose();
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
          Navigator.of(context).pop(true);
        } else if (state is UpdateClientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is UpdateClientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpdateClientLoaded) {
          return _buildForm(state);
        }
        return const Center(child: Text('Error al cargar el formulario'));
      },
    );
  }

  Widget _buildForm(UpdateClientLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDocumentoField(),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildContactoField(),
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
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el nombre';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el correo electrónico';
        } else if (!value.contains('@')) {
          return 'Por favor ingrese un correo electrónico válido';
        }
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el teléfono';
        }
        return null;
      },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese la dirección';
        }
        return null;
      },
    );
  }

  Widget _buildDocumentoField() {
    return TextFormField(
      controller: _documentoController,
      decoration: InputDecoration(
        labelText: 'Documento (NIT)',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      style: TextStyle(color: Colors.grey[600]),
      enabled: false, // Hace que el campo sea de solo lectura
      keyboardType: TextInputType.none, // Deshabilita el teclado
    );
  }

  Widget _buildContactoField() {
    return TextFormField(
      controller: _contactoController,
      decoration: const InputDecoration(
        labelText: 'Contacto',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el contacto';
        }
        return null;
      },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un departamento';
        }
        return null;
      },
    );
  }

  Widget _buildCityDropdown(UpdateClientLoaded state) {
    return DropdownButtonFormField<String>(
      value: state.selectedCityCode,
      decoration: const InputDecoration(
        labelText: 'Ciudad',
        border: OutlineInputBorder(),
      ),
      items: state.cities
          .map((city) => DropdownMenuItem(
                value: city['code'],
                child: Text(city['name'] ?? ''),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<UpdateClientBloc>().add(CityChangedEvent(cityCode: value));
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione una ciudad';
        }
        return null;
      },
    );
  }

  Client _createUpdatedClient(UpdateClientLoaded state) {
    return widget.client.copyWith(
      nombre: _nameController.text,
      email: _emailController.text,
      tel1: _phoneController.text,
      direccion: _addressController.text,
      nit: _documentoController.text,
      contacto: _contactoController.text,
      // Add any other fields that need to be updated
    );
  }
}