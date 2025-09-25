import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'update_client_widgets.dart';
import 'update_client_controller.dart';
import 'update_client_model.dart';
export 'update_client_model.dart';

class UpdateClientWidget extends StatefulWidget {
  const UpdateClientWidget({
    super.key,
    required this.dataClients,
    required this.updated,
  });

  final DataClienteStruct? dataClients;
  final Future Function()? updated;

  @override
  State<UpdateClientWidget> createState() => _UpdateClientWidgetState();
}

class _UpdateClientWidgetState extends State<UpdateClientWidget>
    with TickerProviderStateMixin {
  late UpdateClientModel _model;
  late UpdateClientController _controller;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdateClientModel());

    if (widget.dataClients == null) {
      // Handle error case where data is null, maybe pop the screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        // Optionally show a snackbar
      });
    } else {
      _controller = UpdateClientController(context, widget.dataClients!, widget.updated);
      _controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This check is important for when the widget is first built and controller is not yet initialized
    if (widget.dataClients == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 570.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE0E3E7)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UpdateClientHeader(),
                  if (_controller.state == UiState.loading)
                    const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()))
                  else
                    Column(
                      children: [
                        UpdateClientForm(
                          formKey: _controller.formKey,
                          nitController: _controller.nitController,
                          nitFocusNode: FocusNode(), // Manage inside controller if needed
                          nombreController: _controller.nombreController,
                          nombreFocusNode: FocusNode(),
                          contactoController: _controller.contactoController,
                          contactoFocusNode: FocusNode(),
                          telefonoController: _controller.telefonoController,
                          telefonoFocusNode: FocusNode(),
                          emailController: _controller.emailController,
                          emailFocusNode: FocusNode(),
                          direccionController: _controller.direccionController,
                          direccionFocusNode: FocusNode(),
                          departmentOptions: _controller.departmentOptions,
                          departmentController: _controller.departmentController,
                          onDepartmentChanged: _controller.onDepartmentChanged,
                          cityOptions: _controller.cityOptions,
                          cityController: _controller.cityController,
                          onCityChanged: _controller.onCityChanged,
                        ),
                        UpdateClientActions(
                          onUpdate: _controller.updateClient,
                          onClose: () => Navigator.pop(context),
                          isUpdating: _controller.state == UiState.loading,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}