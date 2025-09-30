import 'package:app_vendedores/shared/mensajes/ok_actualizado/ok_actualizado_widget.dart';
import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';

enum UiState { initial, loading, success, error }

class UpdateClientController extends ChangeNotifier {
  UpdateClientController(this.context, this.initialData, this.onClientUpdated) {
    _initialize();
  }

  // Dependencies
  final BuildContext context;
  final DataClienteStruct initialData;
  final Future Function()? onClientUpdated;

  // State
  UiState _state = UiState.loading;
  String? _errorMessage;
  List<NameDptoStruct> _departments = [];
  List<DataCityStruct> _cities = [];

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  late TextEditingController nitController;
  late TextEditingController nombreController;
  late TextEditingController contactoController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  late TextEditingController direccionController;
  late FormFieldController<String> departmentController;
  late FormFieldController<String> cityController;

  // Getters
  UiState get state => _state;
  String? get errorMessage => _errorMessage;
  List<String> get departmentOptions => _departments.map((d) => d.nomdpto).toList();
  List<String> get cityOptions => _cities.map((c) => c.nomciud).toList();

  void _initialize() {
    // Initialize text controllers
    nitController = TextEditingController(text: initialData.nit);
    nombreController = TextEditingController(text: initialData.nombre);
    contactoController = TextEditingController(text: initialData.contacto);
    telefonoController = TextEditingController(text: initialData.tel1);
    emailController = TextEditingController(text: initialData.email);
    direccionController = TextEditingController(text: initialData.direccion);

    // Initialize dropdown controllers
    departmentController = FormFieldController<String>(initialData.nomdpto);
    cityController = FormFieldController<String>(initialData.cdciiu);

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadDepartments();
    if (departmentController.value != null && departmentController.value!.isNotEmpty) {
      await _loadCities(departmentController.value!);
    }
    _state = UiState.initial;
    notifyListeners();
  }

  Future<void> _loadDepartments() async {
    final apiResult = await MaestrasGroup.getListDeptoCall.call(token: FFAppState().infoSeller.token);
    if (apiResult.succeeded) {
      _departments = (getJsonField(apiResult.jsonBody, r'''$.data''', true) as List)
          .map<NameDptoStruct>((e) => NameDptoStruct.fromMap(e))
          .toList();
    } else {
      _handleError(getJsonField(apiResult.jsonBody, r'''$.data''').toString());
    }
    notifyListeners();
  }

  Future<void> _loadCities(String department) async {
    final apiResult = await MaestrasGroup.listCitiesCall.call(
      token: FFAppState().infoSeller.token,
      deparment: department,
    );
    if (apiResult.succeeded) {
      _cities = (getJsonField(apiResult.jsonBody, r'''$.data''', true) as List)
          .map<DataCityStruct>((e) => DataCityStruct.fromMap(e))
          .toList();
    } else {
      _handleError(getJsonField(apiResult.jsonBody, r'''$.data''').toString());
    }
    notifyListeners();
  }

  Future<void> onDepartmentChanged(String? val) async {
    if (val == null) return;
    departmentController.value = val;
    cityController.value = null; // Clear city selection
    _cities = [];
    notifyListeners();
    await _loadCities(val);
  }

  void onCityChanged(String? val) {
    cityController.value = val;
    notifyListeners();
  }

  Future<void> updateClient() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    _state = UiState.loading;
    notifyListeners();

    final dataToUpdate = {
      'nit': nitController.text,
      'nombre': nombreController.text,
      'contacto': contactoController.text,
      'tel1': telefonoController.text,
      'email': emailController.text,
      'direccion': direccionController.text,
      'cdciiu': cityController.value,
    };

    final apiResult = await ClientsGroup.updateClientCall.call(
      token: FFAppState().infoSeller.token,
      dataJson: dataToUpdate,
    );

    if (apiResult.succeeded) {
      _state = UiState.success;
      await _showSuccessDialog();
      await onClientUpdated?.call();
      Navigator.pop(context);
    } else {
      _handleError(getJsonField(apiResult.jsonBody, r'''$.message''').toString());
    }
    
    if (_state != UiState.success) {
      _state = UiState.initial;
    }
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    _state = UiState.error;
    _showErrorDialog();
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) => const Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: OkActualizadoWidget(),
      ),
    );
  }

  Future<void> _showErrorDialog() async {
    await showDialog(
      context: context,
      builder: (alertDialogContext) => AlertDialog(
        title: const Text('Error'),
        content: Text(_errorMessage ?? 'Ocurrió un error.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nitController.dispose();
    nombreController.dispose();
    contactoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    direccionController.dispose();
    departmentController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
