// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DescriptionAnalysisStruct extends FFFirebaseStruct {
  DescriptionAnalysisStruct({
    bool? hasKeywords,
    List<String>? keywords,
    int? keywordCount,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _hasKeywords = hasKeywords,
        _keywords = keywords,
        _keywordCount = keywordCount,
        super(firestoreUtilData);

  // "hasKeywords" field.
  bool? _hasKeywords;
  bool get hasKeywords => _hasKeywords ?? false;
  set hasKeywords(bool? val) => _hasKeywords = val;

  bool hasHasKeywords() => _hasKeywords != null;

  // "keywords" field.
  List<String>? _keywords;
  List<String> get keywords => _keywords ?? const [];
  set keywords(List<String>? val) => _keywords = val;

  void updateKeywords(Function(List<String>) updateFn) {
    updateFn(_keywords ??= []);
  }

  bool hasKeywordsField() => _keywords != null;

  // "keywordCount" field.
  int? _keywordCount;
  int get keywordCount => _keywordCount ?? 0;
  set keywordCount(int? val) => _keywordCount = val;

  void incrementKeywordCount(int amount) =>
      keywordCount = keywordCount + amount;

  bool hasKeywordCount() => _keywordCount != null;

  static DescriptionAnalysisStruct fromMap(Map<String, dynamic> data) =>
      DescriptionAnalysisStruct(
        hasKeywords: data['hasKeywords'] as bool?,
        keywords: getDataList(data['keywords']),
        keywordCount: castToType<int>(data['keywordCount']),
      );

  static DescriptionAnalysisStruct? maybeFromMap(dynamic data) => data is Map
      ? DescriptionAnalysisStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hasKeywords': _hasKeywords,
        'keywords': _keywords,
        'keywordCount': _keywordCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hasKeywords': serializeParam(
          _hasKeywords,
          ParamType.bool,
        ),
        'keywords': serializeParam(
          _keywords,
          ParamType.String,
          isList: true,
        ),
        'keywordCount': serializeParam(
          _keywordCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static DescriptionAnalysisStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DescriptionAnalysisStruct(
        hasKeywords: deserializeParam(
          data['hasKeywords'],
          ParamType.bool,
          false,
        ),
        keywords: deserializeParam<String>(
          data['keywords'],
          ParamType.String,
          true,
        ),
        keywordCount: deserializeParam(
          data['keywordCount'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DescriptionAnalysisStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DescriptionAnalysisStruct &&
        hasKeywords == other.hasKeywords &&
        listEquality.equals(keywords, other.keywords) &&
        keywordCount == other.keywordCount;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([hasKeywords, keywords, keywordCount]);
}

DescriptionAnalysisStruct createDescriptionAnalysisStruct({
  bool? hasKeywords,
  int? keywordCount,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DescriptionAnalysisStruct(
      hasKeywords: hasKeywords,
      keywordCount: keywordCount,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DescriptionAnalysisStruct? updateDescriptionAnalysisStruct(
  DescriptionAnalysisStruct? descriptionAnalysis, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    descriptionAnalysis
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDescriptionAnalysisStructData(
  Map<String, dynamic> firestoreData,
  DescriptionAnalysisStruct? descriptionAnalysis,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (descriptionAnalysis == null) {
    return;
  }
  if (descriptionAnalysis.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && descriptionAnalysis.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final descriptionAnalysisData =
      getDescriptionAnalysisFirestoreData(descriptionAnalysis, forFieldValue);
  final nestedData =
      descriptionAnalysisData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      descriptionAnalysis.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDescriptionAnalysisFirestoreData(
  DescriptionAnalysisStruct? descriptionAnalysis, [
  bool forFieldValue = false,
]) {
  if (descriptionAnalysis == null) {
    return {};
  }
  final firestoreData = mapToFirestore(descriptionAnalysis.toMap());

  // Add any Firestore field values
  descriptionAnalysis.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDescriptionAnalysisListFirestoreData(
  List<DescriptionAnalysisStruct>? descriptionAnalysiss,
) =>
    descriptionAnalysiss
        ?.map((e) => getDescriptionAnalysisFirestoreData(e, true))
        .toList() ??
    [];
