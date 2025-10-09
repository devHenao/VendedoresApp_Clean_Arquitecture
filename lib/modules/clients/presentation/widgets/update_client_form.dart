import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/core/theme/theme.dart';
import 'package:app_vendedores/core/validations/validators.dart';

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
    _addressController =
        TextEditingController(text: widget.client.direccion ?? '');
    _documentoController = TextEditingController(text: widget.client.nit);
    _contactoController =
        TextEditingController(text: widget.client.contacto ?? '');

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
    final theme = GlobalTheme.of(context);
    return BlocConsumer<UpdateClientBloc, UpdateClientState>(
      listener: (context, state) {
        if (state is UpdateClientLoaded) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text('Cliente actualizado con éxito'),
                  backgroundColor: theme.success),
            );
            Navigator.of(context).pop(true);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    state.errorMessage ?? 'Error al actualizar el cliente'),
                backgroundColor: theme.error,
              ),
            );
          }
        } else if (state is UpdateClientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UpdateClientLoaded && state.isSubmitting;
        
        if (state is UpdateClientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpdateClientLoaded) {
          return _buildForm(state, isSubmitting);
        }
        return const Center(child: Text('Error al cargar el formulario'));
      },
    );
  }

  Widget _buildForm(UpdateClientLoaded state, bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDocumentoField(isSubmitting),
            const SizedBox(height: 16),
            _buildNameField(isSubmitting),
            const SizedBox(height: 16),
            _buildContactoField(isSubmitting),
            const SizedBox(height: 16),
            _buildEmailField(isSubmitting),
            const SizedBox(height: 16),
            _buildPhoneField(isSubmitting),
            const SizedBox(height: 16),
            _buildDepartmentDropdown(state, isSubmitting),
            const SizedBox(height: 16),
            _buildCityDropdown(state, isSubmitting),
            const SizedBox(height: 16),
            _buildAddressField(isSubmitting),
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

  Widget _buildAddressField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _addressController,
      enabled: !isSubmitting,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Dirección *',
        suffixIcon: const Icon(Icons.location_on_outlined, size: 20),
        labelStyle:
            theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: AppValidators.validateAddress,
    );
  }

  Widget _buildDocumentoField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _documentoController,
      enabled: !isSubmitting,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: 'Documento *',
        suffixIcon: const Icon(Icons.credit_card_outlined, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el documento';
        }
        return null;
      },
    );
  }

  Widget _buildContactoField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _contactoController,
      enabled: !isSubmitting,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: 'Contacto',
        suffixIcon: const Icon(Icons.person_outline, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildNameField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _nameController,
      enabled: !isSubmitting,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: 'Nombre *',
        suffixIcon: const Icon(Icons.person_outline, size: 20),
        labelStyle:
            theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: AppValidators.validateName,
    );
  }

  Widget _buildEmailField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _emailController,
      enabled: !isSubmitting,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: 'Correo Electrónico *',
        suffixIcon: const Icon(Icons.email_outlined, size: 20),
        labelStyle:
            theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: AppValidators.validateEmail,
    );
  }

  Widget _buildPhoneField(bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    
    return TextFormField(
      controller: _phoneController,
      enabled: !isSubmitting,
      keyboardType: TextInputType.phone,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isSubmitting ? colors.secondaryText : colors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: 'Teléfono *',
        suffixIcon: const Icon(Icons.phone_outlined, size: 20),
        labelStyle:
            theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: AppValidators.validatePhone,
    );
  }

  Widget _buildDepartmentDropdown(UpdateClientLoaded state, bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    final isDisabled = isSubmitting || state.isSubmitting;
    
    return DropdownButtonFormField<String>(
      initialValue: state.selectedDepartment ?? widget.client.nomdpto,
      onChanged: isDisabled 
          ? null 
          : (String? value) {
              if (value != null) {
                context.read<UpdateClientBloc>().add(DepartmentChangedEvent(value));
              }
            },
      disabledHint: Text(
        state.selectedDepartment ?? widget.client.nomdpto ?? 'Seleccione un departamento',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colors.secondaryText,
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Departamento *',
        suffixIcon: const Icon(Icons.location_city_outlined, size: 20),
        labelStyle:
            theme.textTheme.bodyMedium?.copyWith(color: colors.secondaryText),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: state.departments
          .map<DropdownMenuItem<String>>((dept) => DropdownMenuItem<String>(
                value: dept,
                child: Text(dept),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un departamento';
        }
        return null;
      },
    );
  }

  Widget _buildCityDropdown(UpdateClientLoaded state, bool isSubmitting) {
    final theme = Theme.of(context);
    final colors = GlobalTheme.of(context);
    final isDisabled = isSubmitting || state.isSubmitting;
    
    final String? initialCityCode = state.selectedCityCode ?? widget.client.nomciud;
    
    final bool isCityInList = state.cities.any(
      (city) => city['code']?.toString() == initialCityCode,
    );
    
    if (initialCityCode != null && initialCityCode.isNotEmpty && !isCityInList) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UpdateClientBloc>().add(const CityChangedEvent(cityCode: ''));
      });
    }
    
    final selectedCity = isCityInList
        ? state.cities.firstWhere(
            (city) => city['code']?.toString() == initialCityCode,
          )
        : {'code': '', 'name': 'Seleccione una ciudad'};
    
    final String? dropdownValue = selectedCity['code']?.toString().isNotEmpty == true
        ? selectedCity['code']?.toString()
        : null;
    
    return DropdownButtonFormField<String>(
      initialValue: dropdownValue,
      onChanged: isDisabled || state.isLoadingCities
          ? null
          : (String? value) {
              if (value != null) {
                context.read<UpdateClientBloc>().add(CityChangedEvent(cityCode: value));
              }
            },
      disabledHint: Text(
        selectedCity['name']?.toString() ?? 'Seleccione una ciudad',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colors.secondaryText,
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.primaryText),
      decoration: InputDecoration(
        labelText: 'Ciudad *',
        suffixIcon: state.isLoadingCities
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.map_outlined, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: state.cities
          .map((city) => DropdownMenuItem<String>(
                value: city['code']?.toString() ?? '',
                child: Text(city['name']?.toString() ?? ''),
              ))
          .toList(),
      validator: (value) {
        if (state.isLoadingCities) {
          return 'Cargando ciudades...';
        }
        return AppValidators.validateCity(value);
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
      nomciud: state.selectedCityName,
      nomdpto: state.selectedDepartment,
    );
  }
}
