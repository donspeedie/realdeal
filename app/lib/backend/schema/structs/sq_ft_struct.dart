// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SqFtStruct extends FFFirebaseStruct {
  SqFtStruct({
    int? level,
    int? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _level = level,
        _value = value,
        super(firestoreUtilData);

  // "level" field.
  int? _level;
  int get level => _level ?? 0;
  set level(int? val) => _level = val;

  void incrementLevel(int amount) => level = level + amount;

  bool hasLevel() => _level != null;

  // "value" field.
  int? _value;
  int get value => _value ?? 0;
  set value(int? val) => _value = val;

  void incrementValue(int amount) => value = value + amount;

  bool hasValue() => _value != null;

  static SqFtStruct fromMap(Map<String, dynamic> data) => SqFtStruct(
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static SqFtStruct? maybeFromMap(dynamic data) =>
      data is Map ? SqFtStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'level': _level,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'level': serializeParam(
          _level,
          ParamType.int,
        ),
        'value': serializeParam(
          _value,
          ParamType.int,
        ),
      }.withoutNulls;

  static SqFtStruct fromSerializableMap(Map<String, dynamic> data) =>
      SqFtStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SqFtStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SqFtStruct && level == other.level && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

SqFtStruct createSqFtStruct({
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SqFtStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SqFtStruct? updateSqFtStruct(
  SqFtStruct? sqFt, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sqFt
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSqFtStructData(
  Map<String, dynamic> firestoreData,
  SqFtStruct? sqFt,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sqFt == null) {
    return;
  }
  if (sqFt.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && sqFt.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sqFtData = getSqFtFirestoreData(sqFt, forFieldValue);
  final nestedData = sqFtData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sqFt.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSqFtFirestoreData(
  SqFtStruct? sqFt, [
  bool forFieldValue = false,
]) {
  if (sqFt == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sqFt.toMap());

  // Add any Firestore field values
  sqFt.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSqFtListFirestoreData(
  List<SqFtStruct>? sqFts,
) =>
    sqFts?.map((e) => getSqFtFirestoreData(e, true)).toList() ?? [];
