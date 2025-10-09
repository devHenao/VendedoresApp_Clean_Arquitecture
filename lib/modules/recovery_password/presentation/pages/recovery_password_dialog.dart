import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/mensajes/ok_password/ok_password_widget.dart';
import '../../domain/usecases/reset_password.dart';
import '../../infrastructure/datasources/recovery_password_datasource.dart';
import '../../infrastructure/repositories/recovery_password_repository_impl.dart';
import '../bloc/recovery_password_bloc.dart';
import '../widgets/recovery_password_header.dart';
import '../widgets/recovery_password_form.dart';
import '../widgets/recovery_password_footer.dart';

class RecoveryPasswordDialog extends StatelessWidget {
  const RecoveryPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoveryPasswordBloc(
        resetPassword: ResetPassword(
          RecoveryPasswordRepositoryImpl(
            RecoveryPasswordDatasource(),
          ),
        ),
      ),
      child: const _RecoveryPasswordView(),
    );
  }
}

class _RecoveryPasswordView extends StatefulWidget {
  const _RecoveryPasswordView();

  @override
  State<_RecoveryPasswordView> createState() => _RecoveryPasswordViewState();
}

class _RecoveryPasswordViewState extends State<_RecoveryPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _emailController = TextEditingController();
  final _nitFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _nitController.dispose();
    _emailController.dispose();
    _nitFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoveryPasswordBloc, RecoveryPasswordState>(
      listener: (context, state) {
        if (state.status == RecoveryPasswordStatus.success) {
          showDialog(
            context: context,
            builder: (dialogContext) => Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0)
                  .resolve(Directionality.of(context)),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.95,
                child: const OkPasswordWidget(),
              ),
            ),
          );
        } else if (state.status == RecoveryPasswordStatus.error) {
          showDialog(
            context: context,
            builder: (alertDialogContext) {
              final colors = GlobalTheme.of(alertDialogContext);
              return AlertDialog(
                backgroundColor: colors.secondaryBackground,
                title: Text('Error', style: colors.headlineSmall),
                content: Text(
                  state.errorMessage ?? 'Ocurrió un error desconocido.',
                  style: colors.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok', style: colors.bodyMedium.copyWith(color: colors.primary)),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
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
                  BlocBuilder<RecoveryPasswordBloc, RecoveryPasswordState>(
                    builder: (context, state) {
                      if (state.status == RecoveryPasswordStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return RecoveryPasswordForm(
                        formKey: _formKey,
                        nitController: _nitController,
                        nitFocusNode: _nitFocusNode,
                        emailController: _emailController,
                        emailFocusNode: _emailFocusNode,
                        onResetPassword: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RecoveryPasswordBloc>().add(
                                  ResetPasswordRequested(
                                    nit: _nitController.text,
                                    email: _emailController.text,
                                  ),
                                );
                          }
                        },
                      );
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
      ),
    );
  }
}
