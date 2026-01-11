// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class StreetLineStruct extends FFFirebaseStruct {
  StreetLineStruct({
    int? level,
    String? value,
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
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static StreetLineStruct fromMap(Map<String, dynamic> data) =>
      StreetLineStruct(
        level: castToType<int>(data['level']),
        value: data['value'] as String?,
      );

  static StreetLineStruct? maybeFromMap(dynamic data) => data is Map
      ? StreetLineStruct.fromMap(data.cast<String, dynamic>())
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
          ParamType.String,
        ),
      }.withoutNulls;

  static StreetLineStruct fromSerializableMap(Map<String, dynamic> data) =>
      StreetLineStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StreetLineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StreetLineStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

StreetLineStruct createStreetLineStruct({
  int? level,
  String? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StreetLineStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StreetLineStruct? updateStreetLineStruct(
  StreetLineStruct? streetLine, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    streetLine
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStreetLineStructData(
  Map<String, dynamic> firestoreData,
  StreetLineStruct? streetLine,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (streetLine == null) {
    return;
  }
  if (streetLine.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && streetLine.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final streetLineData = getStreetLineFirestoreData(streetLine, forFieldValue);
  final nestedData = streetLineData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = streetLine.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStreetLineFirestoreData(
  StreetLineStruct? streetLine, [
  bool forFieldValue = false,
]) {
  if (streetLine == null) {
    return {};
  }
  final firestoreData = mapToFirestore(streetLine.toMap());

  // Add any Firestore field values
  streetLine.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStreetLineListFirestoreData(
  List<StreetLineStruct>? streetLines,
) =>
    streetLines?.map((e) => getStreetLineFirestoreData(e, true)).toList() ?? [];
