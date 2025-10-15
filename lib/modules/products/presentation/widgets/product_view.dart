import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:app_vendedores/core/theme/theme.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/product/product_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:app_vendedores/modules/products/presentation/controllers/product_view_controller.dart';
import 'package:app_vendedores/modules/products/domain/usecases/get_products_use_case.dart';
import 'package:dio/dio.dart';
import 'package:app_vendedores/modules/products/infrastructure/datasources/product_remote_data_source.dart';
import 'package:app_vendedores/modules/products/infrastructure/repositories/product_repository_impl.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, this.vendedor});
  final String? vendedor;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late ProductViewController _viewController;
  bool _isLoadingInitial = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final remoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    final repository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);
    final getProductsUseCase = GetProductsUseCase(repository);

    _viewController = ProductViewController(
      appState: FFAppState(),
      getProductsUseCase: getProductsUseCase,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProducts() async {
    setState(() => _isLoadingInitial = true);
    final result = await _viewController.loadProducts(
      context: context,
      vendedorOverride: widget.vendedor,
    );
    setState(() => _isLoadingInitial = false);
    if (result.success) {
      if (result.message != null) {
        showSnackbar(context, result.message!);
      }
    } else {
      showSnackbar(context, result.message ?? 'Error al cargar productos');
    }
  }

  Future<void> _loadPrevPage() async {
    setState(() => _viewController.isLoadingPrevPage = true);
    try {
      await _viewController.loadPreviousPage(context, widget.vendedor ?? '');
    } finally {
      setState(() => _viewController.isLoadingPrevPage = false);
    }
  }

  Future<void> _loadNextPage() async {
    setState(() => _viewController.isLoadingNextPage = true);
    try {
      await _viewController.loadNextPage(context, widget.vendedor ?? '');
    } finally {
      setState(() => _viewController.isLoadingNextPage = false);
    }
  }

  Future<void> _scanBarcode() async {
    setState(() => _isScanning = true);
    try {
      final result = await BarcodeScanner.scan();
      final code = result.rawContent;
      if (code.isNotEmpty) {
        _searchController.text = code;
        await _viewController.searchProducts(context, code, widget.vendedor ?? '');
        setState(() {});
      }
    } catch (_) {
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Widget _buildHeader() {
    return Row(
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
            FontAwesomeIcons.cartShopping,
            color: GlobalTheme.of(context).primary,
            size: 30.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
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
                () => _viewController.searchProducts(context, _searchController.text, widget.vendedor ?? ''),
              );
            },
            onFieldSubmitted: (_) async => _viewController.searchProducts(context, _searchController.text, widget.vendedor ?? ''),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Buscar por nombre o código',
              suffixIcon: _searchController.text.isNotEmpty && _searchFocusNode.hasFocus
                  ? IconButton(
                      icon: Icon(Icons.clear, color: GlobalTheme.of(context).secondaryText, size: 20),
                      onPressed: () async {
                        _searchController.clear();
                        setState(() {});
                        await _viewController.searchProducts(context, '', widget.vendedor ?? '');
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
            onTap: () {},
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
              onTap: () async => _viewController.searchProducts(context, _searchController.text, widget.vendedor ?? ''),
              child: Icon(Icons.search_rounded, color: GlobalTheme.of(context).info, size: 24),
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: 40,
          width: 40,
          child: Material(
            color: _isScanning
                ? GlobalTheme.of(context).secondaryBackground
                : GlobalTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: _isScanning ? null : _scanBarcode,
              child: _isScanning
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(GlobalTheme.of(context).primary),
                      ),
                    )
                  : Icon(Icons.qr_code_scanner_outlined, color: GlobalTheme.of(context).primary, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationInfo() {
    final currentPage = _viewController.pages?.currentPage ?? 1;
    final totalCount = _viewController.pages?.totalCount ?? 0;
    final start = (currentPage - 1) * 10 + 1;
    final end = (currentPage * 10) < totalCount ? (currentPage * 10) : totalCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 0, 12),
      child: Row(
        children: [
          Text('Productos:', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
          const SizedBox(width: 5),
          Text('$start', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
          const SizedBox(width: 5),
          Text('al', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
          const SizedBox(width: 5),
          Text('$end', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
          const SizedBox(width: 5),
          Text('de:', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 16)),
          const SizedBox(width: 5),
          Text('$totalCount', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Row(
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
    );
  }

  Widget _buildProductsList(List<DataProductStruct> products) {
    return SingleChildScrollView(
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
                await _viewController.onSelectedChanged(context, item, state);
                safeSetState(() {});
              },
              callbackCantidad: (pCantidad) async {
                await _viewController.onQuantityChanged(context, item, pCantidad);
                safeSetState(() {});
              },
              callbackEliminar: () async {
                await _viewController.onDelete(context, item);
                safeSetState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 35,
                width: 35,
                child: Material(
                  color: _viewController.isLoadingPrevPage
                      ? GlobalTheme.of(context).secondaryBackground
                      : GlobalTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _viewController.isLoadingPrevPage ? null : _loadPrevPage,
                    child: _viewController.isLoadingPrevPage
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(GlobalTheme.of(context).primary),
                            ),
                          )
                        : Icon(Icons.navigate_before_rounded, color: GlobalTheme.of(context).info, size: 20),
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
                    Text('${_viewController.pages?.currentPage ?? 1}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                    const SizedBox(width: 2),
                    Text('-', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                    const SizedBox(width: 2),
                    Text('${_viewController.pages?.totalPages ?? 1}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
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
                  color: _viewController.isLoadingNextPage
                      ? GlobalTheme.of(context).secondaryBackground
                      : GlobalTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: (_viewController.isLoadingNextPage || _viewController.pages?.hasNextPage == false)
                        ? null
                        : _loadNextPage,
                    child: _viewController.isLoadingNextPage
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(GlobalTheme.of(context).primary),
                            ),
                          )
                        : Icon(Icons.navigate_next_rounded, color: GlobalTheme.of(context).info, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final appState = FFAppState();
    final products = List<DataProductStruct>.from(appState.productList)
      ..sort((a, b) => a.descripcio.toLowerCase().compareTo(b.descripcio.toLowerCase()));

    if (_isLoadingInitial && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildSearchRow(),
              const SizedBox(height: 5),
              Divider(thickness: 2.0, color: GlobalTheme.of(context).alternate),
            ],
          ),
        ),
        if (_viewController.pages != null && products.isNotEmpty)
          _buildPaginationInfo(),
        if (!_viewController.isLoadingProducts && products.isEmpty) _buildEmptyState(),
        if (products.isNotEmpty)
          Expanded(
            child: _buildProductsList(products),
          ),
        if (products.isNotEmpty && _viewController.pages != null)
          _buildPaginationControls(),
      ],
    );
  }
}
