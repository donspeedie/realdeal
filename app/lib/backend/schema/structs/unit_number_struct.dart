// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class UnitNumberStruct extends FFFirebaseStruct {
  UnitNumberStruct({
    int? level,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _level = level,
        super(firestoreUtilData);

  // "level" field.
  int? _level;
  int get level => _level ?? 0;
  set level(int? val) => _level = val;

  void incrementLevel(int amount) => level = level + amount;

  bool hasLevel() => _level != null;

  static UnitNumberStruct fromMap(Map<String, dynamic> data) =>
      UnitNumberStruct(
        level: castToType<int>(data['level']),
      );

  static UnitNumberStruct? maybeFromMap(dynamic data) => data is Map
      ? UnitNumberStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'level': _level,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'level': serializeParam(
          _level,
          ParamType.int,
        ),
      }.withoutNulls;

  static UnitNumberStruct fromSerializableMap(Map<String, dynamic> data) =>
      UnitNumberStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'UnitNumberStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UnitNumberStruct && level == other.level;
  }

  @override
  int get hashCode => const ListEquality().hash([level]);
}

UnitNumberStruct createUnitNumberStruct({
  int? level,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UnitNumberStruct(
      level: level,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UnitNumberStruct? updateUnitNumberStruct(
  UnitNumberStruct? unitNumber, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    unitNumber
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUnitNumberStructData(
  Map<String, dynamic> firestoreData,
  UnitNumberStruct? unitNumber,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (unitNumber == null) {
    return;
  }
  if (unitNumber.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && unitNumber.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final unitNumberData = getUnitNumberFirestoreData(unitNumber, forFieldValue);
  final nestedData = unitNumberData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = unitNumber.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUnitNumberFirestoreData(
  UnitNumberStruct? unitNumber, [
  bool forFieldValue = false,
]) {
  if (unitNumber == null) {
    return {};
  }
  final firestoreData = mapToFirestore(unitNumber.toMap());

  // Add any Firestore field values
  unitNumber.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUnitNumberListFirestoreData(
  List<UnitNumberStruct>? unitNumbers,
) =>
    unitNumbers?.map((e) => getUnitNumberFirestoreData(e, true)).toList() ?? [];
