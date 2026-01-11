// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class GetPptyStruct extends FFFirebaseStruct {
  GetPptyStruct({
    int? resultsPerPage,
    int? totalPages,
    int? totalResultCount,
    int? currentPage,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _resultsPerPage = resultsPerPage,
        _totalPages = totalPages,
        _totalResultCount = totalResultCount,
        _currentPage = currentPage,
        super(firestoreUtilData);

  // "resultsPerPage" field.
  int? _resultsPerPage;
  int get resultsPerPage => _resultsPerPage ?? 0;
  set resultsPerPage(int? val) => _resultsPerPage = val;

  void incrementResultsPerPage(int amount) =>
      resultsPerPage = resultsPerPage + amount;

  bool hasResultsPerPage() => _resultsPerPage != null;

  // "totalPages" field.
  int? _totalPages;
  int get totalPages => _totalPages ?? 0;
  set totalPages(int? val) => _totalPages = val;

  void incrementTotalPages(int amount) => totalPages = totalPages + amount;

  bool hasTotalPages() => _totalPages != null;

  // "totalResultCount" field.
  int? _totalResultCount;
  int get totalResultCount => _totalResultCount ?? 0;
  set totalResultCount(int? val) => _totalResultCount = val;

  void incrementTotalResultCount(int amount) =>
      totalResultCount = totalResultCount + amount;

  bool hasTotalResultCount() => _totalResultCount != null;

  // "currentPage" field.
  int? _currentPage;
  int get currentPage => _currentPage ?? 0;
  set currentPage(int? val) => _currentPage = val;

  void incrementCurrentPage(int amount) => currentPage = currentPage + amount;

  bool hasCurrentPage() => _currentPage != null;

  static GetPptyStruct fromMap(Map<String, dynamic> data) => GetPptyStruct(
        resultsPerPage: castToType<int>(data['resultsPerPage']),
        totalPages: castToType<int>(data['totalPages']),
        totalResultCount: castToType<int>(data['totalResultCount']),
        currentPage: castToType<int>(data['currentPage']),
      );

  static GetPptyStruct? maybeFromMap(dynamic data) =>
      data is Map ? GetPptyStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'resultsPerPage': _resultsPerPage,
        'totalPages': _totalPages,
        'totalResultCount': _totalResultCount,
        'currentPage': _currentPage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'resultsPerPage': serializeParam(
          _resultsPerPage,
          ParamType.int,
        ),
        'totalPages': serializeParam(
          _totalPages,
          ParamType.int,
        ),
        'totalResultCount': serializeParam(
          _totalResultCount,
          ParamType.int,
        ),
        'currentPage': serializeParam(
          _currentPage,
          ParamType.int,
        ),
      }.withoutNulls;

  static GetPptyStruct fromSerializableMap(Map<String, dynamic> data) =>
      GetPptyStruct(
        resultsPerPage: deserializeParam(
          data['resultsPerPage'],
          ParamType.int,
          false,
        ),
        totalPages: deserializeParam(
          data['totalPages'],
          ParamType.int,
          false,
        ),
        totalResultCount: deserializeParam(
          data['totalResultCount'],
          ParamType.int,
          false,
        ),
        currentPage: deserializeParam(
          data['currentPage'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'GetPptyStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GetPptyStruct &&
        resultsPerPage == other.resultsPerPage &&
        totalPages == other.totalPages &&
        totalResultCount == other.totalResultCount &&
        currentPage == other.currentPage;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([resultsPerPage, totalPages, totalResultCount, currentPage]);
}

GetPptyStruct createGetPptyStruct({
  int? resultsPerPage,
  int? totalPages,
  int? totalResultCount,
  int? currentPage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GetPptyStruct(
      resultsPerPage: resultsPerPage,
      totalPages: totalPages,
      totalResultCount: totalResultCount,
      currentPage: currentPage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GetPptyStruct? updateGetPptyStruct(
  GetPptyStruct? getPpty, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    getPpty
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGetPptyStructData(
  Map<String, dynamic> firestoreData,
  GetPptyStruct? getPpty,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (getPpty == null) {
    return;
  }
  if (getPpty.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && getPpty.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final getPptyData = getGetPptyFirestoreData(getPpty, forFieldValue);
  final nestedData = getPptyData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = getPpty.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGetPptyFirestoreData(
  GetPptyStruct? getPpty, [
  bool forFieldValue = false,
]) {
  if (getPpty == null) {
    return {};
  }
  final firestoreData = mapToFirestore(getPpty.toMap());

  // Add any Firestore field values
  getPpty.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGetPptyListFirestoreData(
  List<GetPptyStruct>? getPptys,
) =>
    getPptys?.map((e) => getGetPptyFirestoreData(e, true)).toList() ?? [];
