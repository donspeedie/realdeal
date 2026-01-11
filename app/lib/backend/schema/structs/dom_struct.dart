// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DomStruct extends FFFirebaseStruct {
  DomStruct({
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

  static DomStruct fromMap(Map<String, dynamic> data) => DomStruct(
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static DomStruct? maybeFromMap(dynamic data) =>
      data is Map ? DomStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static DomStruct fromSerializableMap(Map<String, dynamic> data) => DomStruct(
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
  String toString() => 'DomStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DomStruct && level == other.level && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

DomStruct createDomStruct({
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DomStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DomStruct? updateDomStruct(
  DomStruct? dom, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dom
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDomStructData(
  Map<String, dynamic> firestoreData,
  DomStruct? dom,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dom == null) {
    return;
  }
  if (dom.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && dom.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final domData = getDomFirestoreData(dom, forFieldValue);
  final nestedData = domData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dom.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDomFirestoreData(
  DomStruct? dom, [
  bool forFieldValue = false,
]) {
  if (dom == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dom.toMap());

  // Add any Firestore field values
  dom.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDomListFirestoreData(
  List<DomStruct>? doms,
) =>
    doms?.map((e) => getDomFirestoreData(e, true)).toList() ?? [];
