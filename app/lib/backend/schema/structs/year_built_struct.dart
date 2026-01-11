// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class YearBuiltStruct extends FFFirebaseStruct {
  YearBuiltStruct({
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

  static YearBuiltStruct fromMap(Map<String, dynamic> data) => YearBuiltStruct(
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static YearBuiltStruct? maybeFromMap(dynamic data) => data is Map
      ? YearBuiltStruct.fromMap(data.cast<String, dynamic>())
      : null;

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

  static YearBuiltStruct fromSerializableMap(Map<String, dynamic> data) =>
      YearBuiltStruct(
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
  String toString() => 'YearBuiltStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is YearBuiltStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

YearBuiltStruct createYearBuiltStruct({
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    YearBuiltStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

YearBuiltStruct? updateYearBuiltStruct(
  YearBuiltStruct? yearBuilt, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    yearBuilt
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addYearBuiltStructData(
  Map<String, dynamic> firestoreData,
  YearBuiltStruct? yearBuilt,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (yearBuilt == null) {
    return;
  }
  if (yearBuilt.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && yearBuilt.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final yearBuiltData = getYearBuiltFirestoreData(yearBuilt, forFieldValue);
  final nestedData = yearBuiltData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = yearBuilt.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getYearBuiltFirestoreData(
  YearBuiltStruct? yearBuilt, [
  bool forFieldValue = false,
]) {
  if (yearBuilt == null) {
    return {};
  }
  final firestoreData = mapToFirestore(yearBuilt.toMap());

  // Add any Firestore field values
  yearBuilt.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getYearBuiltListFirestoreData(
  List<YearBuiltStruct>? yearBuilts,
) =>
    yearBuilts?.map((e) => getYearBuiltFirestoreData(e, true)).toList() ?? [];
