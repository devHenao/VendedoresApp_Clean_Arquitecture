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
  late ProductViewController _viewController;

  @override
  void initState() {
    super.initState();
    _viewController = ProductViewController(FFAppState());
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
    final result = await _viewController.loadProducts(
      context: context,
      filter: _buscar,
      page: page ?? (_pages?.currentPage ?? 1),
      codprecioOverride: widget.codprecio,
    );
    if (result.success) {
      _pages = result.pages;
      _hasProduct = false;
      if (result.message != null) {
        showSnackbar(context, result.message!);
      }
      FFAppState().update(() {});
      safeSetState(() {});
    } else {
      _hasProduct = false;
      showSnackbar(context, result.message ?? 'Error al cargar productos');
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

    // Extracted UI into smaller widgets
    final onSelectedChanged = (DataProductStruct item, bool? state) async {
      await _viewController.onSelectedChanged(context, item, state);
      safeSetState(() {});
    };
    final onQuantityChanged = (DataProductStruct item, double? pCantidad) async {
      await _viewController.onQuantityChanged(context, item, pCantidad);
      safeSetState(() {});
    };
    final onDelete = (DataProductStruct item) async {
      await _viewController.onDelete(context, item);
      safeSetState(() {});
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              _ProductsHeader(onCartTap: () => context.pushNamed('Carrito')),
              const SizedBox(height: 8),
              _SearchRow(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: () {
                  setState(() {});
                  EasyDebounce.debounce(
                    'search-products',
                    const Duration(milliseconds: 450),
                    () => _refreshProductList(page: 1),
                  );
                },
                onSubmitted: () async => _refreshProductList(page: 1),
                onSearchTap: () async => _refreshProductList(page: 1),
                onScanTap: _scanBarcode,
                onClear: () async {
                  _searchController.clear();
                  setState(() {});
                  await _refreshProductList(page: 1);
                  _searchFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 5),
              Divider(thickness: 2.0, color: GlobalTheme.of(context).alternate),
            ],
          ),
        ),
        if (_pages != null && products.isNotEmpty)
          _PaginationInfo(pages: _pages, pageSize: 10),
        _LoadingSection(
          show: _hasProduct || _isLoadingNextPage || _isLoadingPrevPage,
          isNextPage: _isLoadingNextPage,
        ),
        if (!_hasProduct && products.isEmpty) const _EmptyState(),
        if (products.isNotEmpty)
          Expanded(
            child: _ProductsList(
              products: products,
              onSelectedChanged: onSelectedChanged,
              onQuantityChanged: onQuantityChanged,
              onDelete: onDelete,
            ),
          ),
        if (products.isNotEmpty && _pages != null)
          _PaginationControls(
            pages: _pages!,
            onPrev: _loadPrevPage,
            onNext: _loadNextPage,
          ),
      ],
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({required this.onCartTap});
  final VoidCallback onCartTap;
  @override
  Widget build(BuildContext context) {
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
          onTap: onCartTap,
          child: FaIcon(
            FontAwesomeIcons.shoppingCart,
            color: GlobalTheme.of(context).primary,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearchTap,
    required this.onScanTap,
    required this.onClear,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final Future<void> Function() onSubmitted;
  final VoidCallback onSearchTap;
  final VoidCallback onScanTap;
  final Future<void> Function() onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (_) => onChanged(),
            onFieldSubmitted: (_) async => onSubmitted(),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Buscar por nombre o código',
              suffixIcon: controller.text.isNotEmpty && focusNode.hasFocus
                  ? IconButton(
                      icon: Icon(Icons.clear, color: GlobalTheme.of(context).secondaryText, size: 20),
                      onPressed: () async => onClear(),
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
              onTap: onSearchTap,
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
              onTap: onScanTap,
              child: Icon(Icons.qr_code_scanner_outlined, color: GlobalTheme.of(context).primary, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaginationInfo extends StatelessWidget {
  const _PaginationInfo({required this.pages, required this.pageSize});
  final DataPageStruct? pages;
  final int pageSize;
  @override
  Widget build(BuildContext context) {
    final currentPage = pages?.currentPage ?? 1;
    final totalCount = pages?.totalCount ?? 0;
    final start = (currentPage - 1) * pageSize + 1;
    final end = (currentPage * pageSize) < totalCount ? (currentPage * pageSize) : totalCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 12),
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
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection({required this.show, required this.isNextPage});
  final bool show;
  final bool isNextPage;
  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(GlobalTheme.of(context).primary)),
          const SizedBox(height: 16),
          Text(
            isNextPage ? 'Cargando más productos...' : 'Buscando productos...',
            style: GlobalTheme.of(context).titleSmall.override(
                  fontFamily: 'Manrope',
                  color: GlobalTheme.of(context).primary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
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
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({
    required this.products,
    required this.onSelectedChanged,
    required this.onQuantityChanged,
    required this.onDelete,
  });
  final List<DataProductStruct> products;
  final Future<void> Function(DataProductStruct, bool?) onSelectedChanged;
  final Future<void> Function(DataProductStruct, double?) onQuantityChanged;
  final Future<void> Function(DataProductStruct) onDelete;
  @override
  Widget build(BuildContext context) {
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
              callBackSeleccionado: (state) async => onSelectedChanged(item, state),
              callbackCantidad: (pCantidad) async => onQuantityChanged(item, pCantidad),
              callbackEliminar: () async => onDelete(item),
            );
          },
        ),
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.pages,
    required this.onPrev,
    required this.onNext,
  });
  final DataPageStruct pages;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    onTap: onPrev,
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
                    Text('${pages.currentPage}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                    const SizedBox(width: 2),
                    Text('-', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
                    const SizedBox(width: 2),
                    Text('${pages.totalPages}', style: GlobalTheme.of(context).bodyMedium.override(fontFamily: 'Manrope', fontSize: 14)),
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
                    onTap: pages.hasNextPage == false ? null : onNext,
                    child: Icon(Icons.navigate_next_rounded, color: GlobalTheme.of(context).info, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
