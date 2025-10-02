import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/form_field_controller.dart';

class UpdateClientHeader extends StatelessWidget {
  const UpdateClientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Actualizar cliente',
              style: GlobalTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: GlobalTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            Icon(
              Icons.edit_square,
              color: GlobalTheme.of(context).primaryText,
              size: 32.0,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
        Divider(
          height: 24.0,
          thickness: 2.0,
          color: GlobalTheme.of(context).alternate,
        ),
      ],
    );
  }
}

class UpdateClientForm extends StatelessWidget {
  const UpdateClientForm({
    super.key,
    required this.formKey,
    required this.nitController,
    required this.nitFocusNode,
    required this.nombreController,
    required this.nombreFocusNode,
    required this.contactoController,
    required this.contactoFocusNode,
    required this.telefonoController,
    required this.telefonoFocusNode,
    required this.emailController,
    required this.emailFocusNode,
    required this.direccionController,
    required this.direccionFocusNode,
    required this.departmentOptions,
    required this.departmentController,
    required this.onDepartmentChanged,
    required this.cityOptions,
    required this.cityController,
    this.onCityChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nitController;
  final FocusNode nitFocusNode;
  final TextEditingController nombreController;
  final FocusNode nombreFocusNode;
  final TextEditingController contactoController;
  final FocusNode contactoFocusNode;
  final TextEditingController telefonoController;
  final FocusNode telefonoFocusNode;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController direccionController;
  final FocusNode direccionFocusNode;
  final List<String> departmentOptions;
  final FormFieldController<String> departmentController;
  final Function(String?) onDepartmentChanged;
  final List<String> cityOptions;
  final FormFieldController<String> cityController;
  final Function(String?)? onCityChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _buildReadOnlyField(
            context: context,
            controller: nitController,
            label: 'Documento',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            controller: nombreController,
            focusNode: nombreFocusNode,
            label: 'Nombre',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            controller: contactoController,
            focusNode: contactoFocusNode,
            label: 'Contacto',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            controller: telefonoController,
            focusNode: telefonoFocusNode,
            label: 'Teléfono',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            controller: emailController,
            focusNode: emailFocusNode,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            controller: direccionController,
            focusNode: direccionFocusNode,
            label: 'Dirección',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            context: context,
            label: 'Departamento',
            controller: departmentController,
            options: departmentOptions,
            onChanged: onDepartmentChanged,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            context: context,
            label: 'Ciudad',
            controller: cityController,
            options: cityOptions,
            onChanged: onCityChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: isRequired
          ? (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null
          : null,
    );
  }

  Widget _buildReadOnlyField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      readOnly: true,
      enabled: false,
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required FormFieldController<String> controller,
    required List<String> options,
    required Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class UpdateClientActions extends StatelessWidget {
  const UpdateClientActions({
    super.key,
    required this.onUpdate,
    required this.onClose,
    required this.isUpdating,
  });

  final VoidCallback onUpdate;
  final VoidCallback onClose;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isUpdating)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: onUpdate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Actualizar Cliente'),
            ),
          const SizedBox(width: 20.0),
          TextButton(
            onPressed: onClose,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

