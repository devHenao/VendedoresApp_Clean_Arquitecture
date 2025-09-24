import 'package:app_vendedores/backend/api_requests/_/api_manager.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'update_client_widget.dart' show UpdateClientWidget;
import 'package:flutter/material.dart';

class UpdateClientModel extends FlutterFlowModel<UpdateClientWidget> {
  ///  Local state fields for this component.

  List<NameDptoStruct> listDpto = [];
  void addToListDpto(NameDptoStruct item) => listDpto.add(item);
  void removeFromListDpto(NameDptoStruct item) => listDpto.remove(item);
  void removeAtIndexFromListDpto(int index) => listDpto.removeAt(index);
  void insertAtIndexInListDpto(int index, NameDptoStruct item) =>
      listDpto.insert(index, item);
  void updateListDptoAtIndex(int index, Function(NameDptoStruct) updateFn) =>
      listDpto[index] = updateFn(listDpto[index]);

  List<DataCityStruct> listCity = [];
  void addToListCity(DataCityStruct item) => listCity.add(item);
  void removeFromListCity(DataCityStruct item) => listCity.remove(item);
  void removeAtIndexFromListCity(int index) => listCity.removeAt(index);
  void insertAtIndexInListCity(int index, DataCityStruct item) =>
      listCity.insert(index, item);
  void updateListCityAtIndex(int index, Function(DataCityStruct) updateFn) =>
      listCity[index] = updateFn(listCity[index]);

  String? dpto = 'ANTIOQUIA';

  String? codigociiu;

  DataClienteStruct? updateData;
  void updateUpdateDataStruct(Function(DataClienteStruct) updateFn) {
    updateFn(updateData ??= DataClienteStruct());
  }

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (getListDepto)] action in updateClient widget.
  ApiCallResponse? apiResultDpto;
  // Stores action output result for [Backend Call - API (ListCities)] action in updateClient widget.
  ApiCallResponse? apiResultCity;
  // State field(s) for txtNit widget.
  FocusNode? txtNitFocusNode;
  TextEditingController? txtNitTextController;
  String? Function(BuildContext, String?)? txtNitTextControllerValidator;
  // State field(s) for txtNombre widget.
  FocusNode? txtNombreFocusNode;
  TextEditingController? txtNombreTextController;
  String? Function(BuildContext, String?)? txtNombreTextControllerValidator;
  String? _txtNombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Completar el campo';
    }

    return null;
  }

  // State field(s) for txtContacto widget.
  FocusNode? txtContactoFocusNode;
  TextEditingController? txtContactoTextController;
  String? Function(BuildContext, String?)? txtContactoTextControllerValidator;
  String? _txtContactoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Completar el campo';
    }

    return null;
  }

  // State field(s) for txtTelefono widget.
  FocusNode? txtTelefonoFocusNode;
  TextEditingController? txtTelefonoTextController;
  String? Function(BuildContext, String?)? txtTelefonoTextControllerValidator;
  String? _txtTelefonoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Completar el campo';
    }

    return null;
  }

  // State field(s) for DropDepartment widget.
  String? dropDepartmentValue;
  FormFieldController<String>? dropDepartmentValueController;
  // Stores action output result for [Backend Call - API (ListCities)] action in DropDepartment widget.
  ApiCallResponse? apiResultNewCity;
  // State field(s) for DropCity widget.
  String? dropCityValue;
  FormFieldController<String>? dropCityValueController;
  // State field(s) for txtEmail widget.
  FocusNode? txtEmailFocusNode;
  TextEditingController? txtEmailTextController;
  String? Function(BuildContext, String?)? txtEmailTextControllerValidator;
  String? _txtEmailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Completar el campo';
    }

    return null;
  }

  // State field(s) for txtDireccion widget.
  FocusNode? txtDireccionFocusNode;
  TextEditingController? txtDireccionTextController;
  String? Function(BuildContext, String?)? txtDireccionTextControllerValidator;
  String? _txtDireccionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Completar el campo';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (updateClient)] action in btnUpdate widget.
  ApiCallResponse? apiResultNewIDataClient;

  @override
  void initState(BuildContext context) {
    txtNombreTextControllerValidator = _txtNombreTextControllerValidator;
    txtContactoTextControllerValidator = _txtContactoTextControllerValidator;
    txtTelefonoTextControllerValidator = _txtTelefonoTextControllerValidator;
    txtEmailTextControllerValidator = _txtEmailTextControllerValidator;
    txtDireccionTextControllerValidator = _txtDireccionTextControllerValidator;
  }

  @override
  void dispose() {
    txtNitFocusNode?.dispose();
    txtNitTextController?.dispose();

    txtNombreFocusNode?.dispose();
    txtNombreTextController?.dispose();

    txtContactoFocusNode?.dispose();
    txtContactoTextController?.dispose();

    txtTelefonoFocusNode?.dispose();
    txtTelefonoTextController?.dispose();

    txtEmailFocusNode?.dispose();
    txtEmailTextController?.dispose();

    txtDireccionFocusNode?.dispose();
    txtDireccionTextController?.dispose();
  }
}
