import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            Icon(
              Icons.edit_square,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 32.0,
            ),
          ].divide(const SizedBox(width: 5.0)),
        ),
        Divider(
          height: 24.0,
          thickness: 2.0,
          color: FlutterFlowTheme.of(context).alternate,
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
    this.nombreValidator,
    required this.contactoController,
    required this.contactoFocusNode,
    this.contactoValidator,
    required this.telefonoController,
    required this.telefonoFocusNode,
    this.telefonoValidator,
    required this.emailController,
    required this.emailFocusNode,
    this.emailValidator,
    required this.direccionController,
    required this.direccionFocusNode,
    this.direccionValidator,
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
  final FormFieldValidator<String>? nombreValidator;
  final TextEditingController contactoController;
  final FocusNode contactoFocusNode;
  final FormFieldValidator<String>? contactoValidator;
  final TextEditingController telefonoController;
  final FocusNode telefonoFocusNode;
  final FormFieldValidator<String>? telefonoValidator;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final FormFieldValidator<String>? emailValidator;
  final TextEditingController direccionController;
  final FocusNode direccionFocusNode;
  final FormFieldValidator<String>? direccionValidator;
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
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            controller: nitController,
            focusNode: nitFocusNode,
            label: 'Documento:',
            readOnly: true,
          ),
          _buildTextField(
            context,
            controller: nombreController,
            focusNode: nombreFocusNode,
            label: 'Nombre:',
            validator: nombreValidator,
          ),
          _buildTextField(
            context,
            controller: contactoController,
            focusNode: contactoFocusNode,
            label: 'Contacto:',
            validator: contactoValidator,
          ),
          _buildTextField(
            context,
            controller: telefonoController,
            focusNode: telefonoFocusNode,
            label: 'Teléfono:',
            validator: telefonoValidator,
          ),
          _buildTextField(
            context,
            controller: emailController,
            focusNode: emailFocusNode,
            label: 'Email:',
            validator: emailValidator,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            context,
            controller: direccionController,
            focusNode: direccionFocusNode,
            label: 'Dirección:',
            validator: direccionValidator,
          ),
          _buildDropdownField(
            context,
            label: 'Departamento:',
            controller: departmentController,
            options: departmentOptions,
            onChanged: onDepartmentChanged,
          ),
          _buildDropdownField(
            context,
            label: 'Ciudad:',
            controller: cityController,
            options: cityOptions,
            onChanged: onCityChanged,
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    {
      required TextEditingController controller,
      required FocusNode focusNode,
      required String label,
      FormFieldValidator<String>? validator,
      bool readOnly = false,
      TextInputType? keyboardType,
    }
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: FlutterFlowTheme.of(context).titleLarge.override(fontFamily: 'Outfit', letterSpacing: 0.0, fontWeight: FontWeight.w600)),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              readOnly: readOnly,
              keyboardType: keyboardType,
              decoration: _inputDecoration(context),
              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', letterSpacing: 0.0, fontWeight: FontWeight.w500),
              validator: validator,
            ),
          ),
        ),
      ].divide(const SizedBox(width: 10)),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    {
      required String label,
      required FormFieldController<String> controller,
      required List<String> options,
      required Function(String?)? onChanged,
    }
  ) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(label, style: FlutterFlowTheme.of(context).titleLarge.override(fontFamily: 'Outfit', letterSpacing: 0.0, fontWeight: FontWeight.w600)),
        Expanded(
          child: FlutterFlowDropDown<String>(
            controller: controller,
            options: options,
            onChanged: onChanged,
            width: 300,
            height: 50,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', letterSpacing: 0.0),
            hintText: 'Seleccione...',
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: FlutterFlowTheme.of(context).secondaryText, size: 24),
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 2,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2,
            borderRadius: 8,
            margin: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
            hidesUnderline: true,
            isOverButton: true,
            isSearchable: false,
            isMultiSelect: false,
          ),
        ),
      ].divide(const SizedBox(width: 10)),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'Manrope', letterSpacing: 0.0),
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'Manrope', letterSpacing: 0.0, fontWeight: FontWeight.w500),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUpdating)
            const CircularProgressIndicator()
          else
            FFButtonWidget(
              onPressed: onUpdate,
              text: 'Actualizar',
              icon: const Icon(Icons.save_alt, size: 15.0),
              options: FFButtonOptions(
                height: 40.0,
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Manrope', color: Colors.white, letterSpacing: 0.0),
                elevation: 2.0,
                borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
          FFButtonWidget(
            onPressed: onClose,
            text: 'Cerrar',
            icon: const Icon(Icons.close, size: 15.0),
            options: FFButtonOptions(
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              color: FlutterFlowTheme.of(context).primaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Manrope', color: FlutterFlowTheme.of(context).primaryText, letterSpacing: 0.0),
              elevation: 0.0,
              borderSide: const BorderSide(color: Color(0x4A161C24)),
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ].divide(const SizedBox(width: 20.0)),
      ),
    );
  }
}
