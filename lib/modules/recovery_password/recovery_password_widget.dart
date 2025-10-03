import '../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'recovery_password_widgets.dart';
import 'recovery_password_controller.dart';
import 'recovery_password_model.dart';
export 'recovery_password_model.dart';

class RecoveryPasswordWidget extends StatefulWidget {
  const RecoveryPasswordWidget({super.key});

  @override
  State<RecoveryPasswordWidget> createState() => _RecoveryPasswordWidgetState();
}

class _RecoveryPasswordWidgetState extends State<RecoveryPasswordWidget> {
  late RecoveryPasswordModel _model;
  late RecoveryPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecoveryPasswordModel());
    _controller = RecoveryPasswordController(context);

    _model.txtNitTextController ??= TextEditingController();
    _model.txtNitFocusNode ??= FocusNode();
    _model.txtCorreoTextController ??= TextEditingController();
    _model.txtCorreoFocusNode ??= FocusNode();

    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: 460.0,
        decoration: BoxDecoration(
          color: GlobalTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RecoveryPasswordHeader(),
                if (_controller.state == UiState.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  RecoveryPasswordForm(
                    formKey: _model.formKey,
                    nitController: _model.txtNitTextController!,
                    nitFocusNode: _model.txtNitFocusNode!,
                    nitValidator: _model.txtNitTextControllerValidator.asValidator(context),
                    emailController: _model.txtCorreoTextController!,
                    emailFocusNode: _model.txtCorreoFocusNode!,
                    emailValidator: _model.txtCorreoTextControllerValidator.asValidator(context),
                    onResetPassword: () {
                      if (_model.formKey.currentState!.validate()) {
                        _controller.resetPassword(
                          nit: _model.txtNitTextController.text,
                          email: _model.txtCorreoTextController.text,
                        );
                      }
                    },
                  ),
                RecoveryPasswordFooter(
                  onGoToLogin: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
