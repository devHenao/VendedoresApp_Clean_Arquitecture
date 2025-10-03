// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataPageStruct extends BaseStruct {
  DataPageStruct({
    int? countTotal,
    int? currentPage,
    int? totalPages,
    int? pageSize,
    int? totalCount,
    bool? hasPreviousPage,
    bool? hasNextPage,
  })  : _countTotal = countTotal,
        _currentPage = currentPage,
        _totalPages = totalPages,
        _pageSize = pageSize,
        _totalCount = totalCount,
        _hasPreviousPage = hasPreviousPage,
        _hasNextPage = hasNextPage;

  // "countTotal" field.
  int? _countTotal;
  int get countTotal => _countTotal ?? 0;
  set countTotal(int? val) => _countTotal = val;

  void incrementCountTotal(int amount) => countTotal = countTotal + amount;

  bool hasCountTotal() => _countTotal != null;

  // "currentPage" field.
  int? _currentPage;
  int get currentPage => _currentPage ?? 0;
  set currentPage(int? val) => _currentPage = val;

  void incrementCurrentPage(int amount) => currentPage = currentPage + amount;

  bool hasCurrentPage() => _currentPage != null;

  // "totalPages" field.
  int? _totalPages;
  int get totalPages => _totalPages ?? 0;
  set totalPages(int? val) => _totalPages = val;

  void incrementTotalPages(int amount) => totalPages = totalPages + amount;

  bool hasTotalPages() => _totalPages != null;

  // "pageSize" field.
  int? _pageSize;
  int get pageSize => _pageSize ?? 0;
  set pageSize(int? val) => _pageSize = val;

  void incrementPageSize(int amount) => pageSize = pageSize + amount;

  bool hasPageSize() => _pageSize != null;

  // "totalCount" field.
  int? _totalCount;
  int get totalCount => _totalCount ?? 0;
  set totalCount(int? val) => _totalCount = val;

  void incrementTotalCount(int amount) => totalCount = totalCount + amount;

  bool hasTotalCount() => _totalCount != null;

  // "hasPreviousPage" field.
  bool? _hasPreviousPage;
  bool get hasPreviousPage => _hasPreviousPage ?? false;
  set hasPreviousPage(bool? val) => _hasPreviousPage = val;

  bool hasHasPreviousPage() => _hasPreviousPage != null;

  // "hasNextPage" field.
  bool? _hasNextPage;
  bool get hasNextPage => _hasNextPage ?? false;
  set hasNextPage(bool? val) => _hasNextPage = val;

  bool hasHasNextPage() => _hasNextPage != null;

  static DataPageStruct fromMap(Map<String, dynamic> data) => DataPageStruct(
        countTotal: castToType<int>(data['countTotal']),
        currentPage: castToType<int>(data['currentPage']),
        totalPages: castToType<int>(data['totalPages']),
        pageSize: castToType<int>(data['pageSize']),
        totalCount: castToType<int>(data['totalCount']),
        hasPreviousPage: data['hasPreviousPage'] as bool?,
        hasNextPage: data['hasNextPage'] as bool?,
      );

  static DataPageStruct? maybeFromMap(dynamic data) =>
      data is Map ? DataPageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'countTotal': _countTotal,
        'currentPage': _currentPage,
        'totalPages': _totalPages,
        'pageSize': _pageSize,
        'totalCount': _totalCount,
        'hasPreviousPage': _hasPreviousPage,
        'hasNextPage': _hasNextPage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'countTotal': serializeParam(
          _countTotal,
          ParamType.int,
        ),
        'currentPage': serializeParam(
          _currentPage,
          ParamType.int,
        ),
        'totalPages': serializeParam(
          _totalPages,
          ParamType.int,
        ),
        'pageSize': serializeParam(
          _pageSize,
          ParamType.int,
        ),
        'totalCount': serializeParam(
          _totalCount,
          ParamType.int,
        ),
        'hasPreviousPage': serializeParam(
          _hasPreviousPage,
          ParamType.bool,
        ),
        'hasNextPage': serializeParam(
          _hasNextPage,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DataPageStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataPageStruct(
        countTotal: deserializeParam(
          data['countTotal'],
          ParamType.int,
          false,
        ),
        currentPage: deserializeParam(
          data['currentPage'],
          ParamType.int,
          false,
        ),
        totalPages: deserializeParam(
          data['totalPages'],
          ParamType.int,
          false,
        ),
        pageSize: deserializeParam(
          data['pageSize'],
          ParamType.int,
          false,
        ),
        totalCount: deserializeParam(
          data['totalCount'],
          ParamType.int,
          false,
        ),
        hasPreviousPage: deserializeParam(
          data['hasPreviousPage'],
          ParamType.bool,
          false,
        ),
        hasNextPage: deserializeParam(
          data['hasNextPage'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DataPageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataPageStruct &&
        countTotal == other.countTotal &&
        currentPage == other.currentPage &&
        totalPages == other.totalPages &&
        pageSize == other.pageSize &&
        totalCount == other.totalCount &&
        hasPreviousPage == other.hasPreviousPage &&
        hasNextPage == other.hasNextPage;
  }

  @override
  int get hashCode => const ListEquality().hash([
        countTotal,
        currentPage,
        totalPages,
        pageSize,
        totalCount,
        hasPreviousPage,
        hasNextPage
      ]);
}

DataPageStruct createDataPageStruct({
  int? countTotal,
  int? currentPage,
  int? totalPages,
  int? pageSize,
  int? totalCount,
  bool? hasPreviousPage,
  bool? hasNextPage,
}) =>
    DataPageStruct(
      countTotal: countTotal,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
      totalCount: totalCount,
      hasPreviousPage: hasPreviousPage,
      hasNextPage: hasNextPage,
    );
