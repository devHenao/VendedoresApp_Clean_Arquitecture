import '../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'register_order_model.dart';
export 'register_order_model.dart';

class RegisterOrderWidget extends StatefulWidget {
  const RegisterOrderWidget({super.key});

  @override
  State<RegisterOrderWidget> createState() => _RegisterOrderWidgetState();
}

class _RegisterOrderWidgetState extends State<RegisterOrderWidget> {
  late RegisterOrderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterOrderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: GlobalTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: GlobalTheme.of(context).success,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                       Icon(
                          Icons.shopping_bag,
                          color: GlobalTheme.of(context).success,
                          size: 30.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Registrado',
                                      style: GlobalTheme.of(context).headlineSmall.copyWith(
                                            color: GlobalTheme.of(context).success,
                                          ),
                                    ),
                                  ].divide(const SizedBox(width: 5.0)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '¡Su pedido ha sido registrado con exito!',
                                        style: GlobalTheme.of(context).bodyMedium,
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 5.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Ok',
                                style: GlobalTheme.of(context).bodyMedium.copyWith(
                                      color: GlobalTheme.of(context).success,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ].divide(const SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
