import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:app_vendedores/core/theme/theme.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:app_vendedores/core/backend/api_requests/api_calls.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:app_vendedores/modules/products/presentation/widgets/product/product_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, this.codprecio});
  final String? codprecio;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  DataPageStruct? _pages;
  bool _hasProduct = false;
  bool _isLoadingNextPage = false;
  bool _isLoadingPrevPage = false;
  String _buscar = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshProductList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _refreshProductList({int? page}) async {
    _buscar = _searchController.text;
    setState(() => _hasProduct = true);
    final appState = FFAppState();
    final effectiveToken = (appState.infoSeller.token.isNotEmpty)
        ? appState.infoSeller.token
        : (currentAuthenticationToken ?? '');
    final effectiveCodPrecio = (widget.codprecio != null && widget.codprecio!.isNotEmpty)
        ? widget.codprecio!
        : appState.dataCliente.codprecio;

    if (effectiveCodPrecio.isEmpty) {
      _hasProduct = false;
      showSnackbar(context, 'Selecciona un cliente para ver productos (codprecio vacío).');
      safeSetState(() {});
      return;
    }
    if (effectiveToken.isEmpty) {
      _hasProduct = false;
      showSnackbar(context, 'No hay token de autenticación. Inicia sesión nuevamente.');
      safeSetState(() {});
      return;
    }
    final apiResult = await ProductsGroup.postListProductByCodPrecioCall.call(
      token: effectiveToken,
      codprecio: effectiveCodPrecio,
      pageNumber: page ?? (_pages?.currentPage ?? 1),
      pageSize: 10,
      filter: _buscar,
    );
    if (apiResult.succeeded) {
      final dataList = (getJsonField(apiResult.jsonBody, r'''$.data.data''', true) as List?)
              ?.map((e) => DataProductStruct.maybeFromMap(e)!)
              .toList() ??
          [];
      final merged = await actions.actualizarListaProductosCache(
        dataList,
        appState.shoppingCart.toList(),
        _buscar,
      );
      appState.productList = merged;
      final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
      appState.store = updatedStore;
      _pages = DataPageStruct.maybeFromMap(getJsonField(apiResult.jsonBody, r'''$.data'''));
      _hasProduct = false;
      appState.update(() {});
      safeSetState(() {});
      if (merged.isEmpty) {
        showSnackbar(context, 'No se encontraron productos para el filtro actual.');
      }
    } else {
      _hasProduct = false;
      final message = getJsonField(apiResult.jsonBody, r'''$.message''')?.toString() ?? 'Error al cargar productos';
      showSnackbar(context, message);
      safeSetState(() {});
    }
  }

  Future<void> _loadPrevPage() async {
    if (_isLoadingPrevPage || (_pages?.currentPage ?? 1) <= 1) return;
    setState(() => _isLoadingPrevPage = true);
    try {
      await _refreshProductList(page: (_pages?.currentPage ?? 1) - 1);
    } finally {
      if (mounted) setState(() => _isLoadingPrevPage = false);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingNextPage || (_pages?.hasNextPage == false)) return;
    setState(() => _isLoadingNextPage = true);
    try {
      await _refreshProductList(page: (_pages!.currentPage + 1));
    } finally {
      if (mounted) setState(() => _isLoadingNextPage = false);
    }
  }

  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      final code = result.rawContent;
      if (code.isNotEmpty) {
        _searchController.text = code;
        _buscar = code;
        await _refreshProductList(page: 1);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final appState = FFAppState();
    final products = List<DataProductStruct>.from(appState.productList)
      ..sort((a, b) => a.descripcio.toLowerCase().compareTo(b.descripcio.toLowerCase()));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Productos',
                    style: GlobalTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: GlobalTheme.of(context).primaryText,
                          fontSize: 30.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                  InkWell(
                    onTap: () => context.pushNamed('Carrito'),
                    child: FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      color: GlobalTheme.of(context).primary,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: (_) {
                        setState(() {});
                        EasyDebounce.debounce(
                          'search-products',
                          const Duration(milliseconds: 450),
                          () => _refreshProductList(page: 1),
                        );
                      },
                      onFieldSubmitted: (_) async => _refreshProductList(page: 1),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Buscar por nombre o código',
                        suffixIcon: _searchController.text.isNotEmpty && _searchFocusNode.hasFocus
                            ? IconButton(
                                icon: Icon(Icons.clear, color: GlobalTheme.of(context).secondaryText, size: 20),
                                onPressed: () async {
                                  _searchController.clear();
                                  setState(() {});
                                  await _refreshProductList(page: 1);
                                  _searchFocusNode.requestFocus();
                                },
                              )
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalTheme.of(context).secondaryText,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: GlobalTheme.of(context).secondaryBackground,
                      ),
                      style: GlobalTheme.of(context).bodyMedium,
                      cursorColor: GlobalTheme.of(context).primaryText,
                      onTap: () => safeSetState(() {}),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: GlobalTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () async => _refreshProductList(page: 1),
                        child: Icon(Icons.search_rounded, color: GlobalTheme.of(context).info, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: GlobalTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: _scanBarcode,
                        child: Icon(Icons.qr_code_scanner_outlined, color: GlobalTheme.of(context).primary, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Divider(thickness: 2.0, color: GlobalTheme.of(context).alternate),
            ],
          ),
        ),
        if (_pages != null && products.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 12),
            child: Row(
              children: [
                Text('Productos:', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
                const SizedBox(width: 5),
                Text('${((_pages?.currentPage ?? 1) - 1) * 10 + 1}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
                const SizedBox(width: 5),
                Text('al', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
                const SizedBox(width: 5),
                Text('${(((_pages?.currentPage ?? 1) * 10) < (_pages?.totalCount ?? 0)) ? ((_pages?.currentPage ?? 1) * 10) : (_pages?.totalCount ?? 0)}',
                    style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
                const SizedBox(width: 5),
                Text('de:', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 16)),
                const SizedBox(width: 5),
                Text('${_pages?.totalCount ?? 0}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
              ],
            ),
          ),
        if (_hasProduct || _isLoadingNextPage || _isLoadingPrevPage)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(GlobalTheme.of(context).primary)),
                const SizedBox(height: 16),
                Text(
                  _isLoadingNextPage ? 'Cargando más productos...' : 'Buscando productos...',
                  style: GlobalTheme.of(context).titleSmall.override(
                        fontFamily: 'Manrope',
                        color: GlobalTheme.of(context).primary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        if (!_hasProduct && products.isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/images/Empty_Box.png', width: 200, height: 200, fit: BoxFit.cover),
                  ),
                  Text(
                    'No hay productos',
                    style: GlobalTheme.of(context).titleSmall.override(
                          fontFamily: 'Manrope',
                          color: GlobalTheme.of(context).secondaryText,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        if (products.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  primary: false,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5.0),
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return ProductWidget(
                      key: Key('product_${index}_${item.codproduc}'),
                      selecionado: item.selected,
                      cantidad: item.cantidad,
                      productItem: item,
                      precio: item.precio,
                      saldo: item.saldo,
                      callBackSeleccionado: (state) async {
                        await actions.seleccionarProducto(item, item.codproduc);
                        final addProducto = await actions.agregarProducto(
                          appState.dataProductList.toList(),
                          item,
                          state ?? false,
                        );
                        appState.dataProductList = addProducto;
                        final listaAgregarProducto = await actions.agregarProductoCarrito(
                          appState.shoppingCart.toList(),
                          item,
                          appState.infoSeller.storageDefault,
                          '0',
                          '0',
                          item.cantidad,
                        );
                        appState.shoppingCart = listaAgregarProducto;
                        final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
                        appState.store = updatedStore;
                        appState.update(() {});
                        safeSetState(() {});
                      },
                      callbackCantidad: (pCantidad) async {
                        final resultCache = await actions.modificarCantidad(
                          item,
                          appState.productList.toList(),
                          pCantidad,
                        );
                        appState.dataProductList = resultCache;
                        final listaCarrito = await actions.agregarProductoCarrito(
                          appState.shoppingCart.toList(),
                          item,
                          appState.infoSeller.storageDefault,
                          '0',
                          '0',
                          pCantidad,
                        );
                        appState.shoppingCart = listaCarrito;
                        final updatedStore2 = await actions.updateStoreQuantity(appState.shoppingCart.toList());
                        appState.store = updatedStore2;
                        appState.update(() {});
                        safeSetState(() {});
                      },
                      callbackEliminar: () async {
                        final eliminado = await actions.eliminarProductoCarrito(
                          appState.infoSeller.storageDefault,
                          '0',
                          '0',
                          item.codproduc,
                          appState.shoppingCart.toList(),
                        );
                        appState.shoppingCart = eliminado;
                        final updatedStore3 = await actions.updateStoreQuantity(appState.shoppingCart.toList());
                        appState.store = updatedStore3;
                        appState.update(() {});
                        safeSetState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        if (products.isNotEmpty && _pages != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Material(
                        color: GlobalTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: _loadPrevPage,
                          child: Icon(Icons.navigate_before_rounded, color: GlobalTheme.of(context).info, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: GlobalTheme.of(context).accent2),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Página:', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                          const SizedBox(width: 2),
                          Text('${_pages?.currentPage}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                          const SizedBox(width: 2),
                          Text('-', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                          const SizedBox(width: 2),
                          Text('${_pages?.totalPages}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Material(
                        color: GlobalTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: _pages?.hasNextPage == false ? null : _loadNextPage,
                          child: Icon(Icons.navigate_next_rounded, color: GlobalTheme.of(context).info, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
