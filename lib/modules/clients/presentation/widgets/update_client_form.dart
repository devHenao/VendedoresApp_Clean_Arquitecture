import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/core/theme/theme.dart';

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
    _nameController = TextEditingController(text: widget.client.nombre);
    _emailController = TextEditingController(text: widget.client.email ?? '');
    _phoneController = TextEditingController(text: widget.client.tel1 ?? '');
    _addressController = TextEditingController(text: widget.client.direccion ?? '');
    _documentoController = TextEditingController(text: widget.client.nit);
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
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
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
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
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
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'ACTUALIZAR CLIENTE',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _addressController,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Dirección',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese la dirección';
        }
        return null;
      },
    );
  }

  Widget _buildDocumentoField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _documentoController,
      enabled: false,
      style: TextStyle(color: colors.secondaryText),
      decoration: InputDecoration(
        labelText: 'Documento (NIT)',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.accent4,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: TextInputType.none,
    );
  }
  
  Widget _buildNameField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _nameController,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el nombre';
        }
        return null;
      },
    );
  }
  
  Widget _buildContactoField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _contactoController,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Contacto',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
  
  Widget _buildEmailField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _emailController,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty && !value.contains('@')) {
          return 'Ingrese un correo electrónico válido';
        }
        return null;
      },
    );
  }
  
  Widget _buildPhoneField() {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _phoneController,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Teléfono',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
  
  Widget _buildDepartmentDropdown(UpdateClientLoaded state) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return DropdownButtonFormField<String>(
      initialValue: state.selectedDepartment,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Departamento',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: state.departments
          .map((dept) => DropdownMenuItem<String>(
                value: dept,
                child: Text(dept),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<UpdateClientBloc>().add(DepartmentChangedEvent(value));
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
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return DropdownButtonFormField<String>(
      value: state.selectedCityCode,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Ciudad',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        filled: true,
        fillColor: colors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: state.cities
          .map((city) => DropdownMenuItem<String>(
                value: city['code'] ?? '',
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