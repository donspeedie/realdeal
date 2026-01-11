// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class KeyFactsStruct extends FFFirebaseStruct {
  KeyFactsStruct({
    String? description,
    int? rank,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _description = description,
        _rank = rank,
        super(firestoreUtilData);

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "rank" field.
  int? _rank;
  int get rank => _rank ?? 0;
  set rank(int? val) => _rank = val;

  void incrementRank(int amount) => rank = rank + amount;

  bool hasRank() => _rank != null;

  static KeyFactsStruct fromMap(Map<String, dynamic> data) => KeyFactsStruct(
        description: data['description'] as String?,
        rank: castToType<int>(data['rank']),
      );

  static KeyFactsStruct? maybeFromMap(dynamic data) =>
      data is Map ? KeyFactsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'description': _description,
        'rank': _rank,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'rank': serializeParam(
          _rank,
          ParamType.int,
        ),
      }.withoutNulls;

  static KeyFactsStruct fromSerializableMap(Map<String, dynamic> data) =>
      KeyFactsStruct(
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        rank: deserializeParam(
          data['rank'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'KeyFactsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is KeyFactsStruct &&
        description == other.description &&
        rank == other.rank;
  }

  @override
  int get hashCode => const ListEquality().hash([description, rank]);
}

KeyFactsStruct createKeyFactsStruct({
  String? description,
  int? rank,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    KeyFactsStruct(
      description: description,
      rank: rank,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

KeyFactsStruct? updateKeyFactsStruct(
  KeyFactsStruct? keyFacts, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    keyFacts
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addKeyFactsStructData(
  Map<String, dynamic> firestoreData,
  KeyFactsStruct? keyFacts,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (keyFacts == null) {
    return;
  }
  if (keyFacts.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && keyFacts.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final keyFactsData = getKeyFactsFirestoreData(keyFacts, forFieldValue);
  final nestedData = keyFactsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = keyFacts.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getKeyFactsFirestoreData(
  KeyFactsStruct? keyFacts, [
  bool forFieldValue = false,
]) {
  if (keyFacts == null) {
    return {};
  }
  final firestoreData = mapToFirestore(keyFacts.toMap());

  // Add any Firestore field values
  keyFacts.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getKeyFactsListFirestoreData(
  List<KeyFactsStruct>? keyFactss,
) =>
    keyFactss?.map((e) => getKeyFactsFirestoreData(e, true)).toList() ?? [];
