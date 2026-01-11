// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LotSizeStruct extends FFFirebaseStruct {
  LotSizeStruct({
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

  static LotSizeStruct fromMap(Map<String, dynamic> data) => LotSizeStruct(
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static LotSizeStruct? maybeFromMap(dynamic data) =>
      data is Map ? LotSizeStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static LotSizeStruct fromSerializableMap(Map<String, dynamic> data) =>
      LotSizeStruct(
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
  String toString() => 'LotSizeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LotSizeStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

LotSizeStruct createLotSizeStruct({
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LotSizeStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LotSizeStruct? updateLotSizeStruct(
  LotSizeStruct? lotSize, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    lotSize
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLotSizeStructData(
  Map<String, dynamic> firestoreData,
  LotSizeStruct? lotSize,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (lotSize == null) {
    return;
  }
  if (lotSize.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && lotSize.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final lotSizeData = getLotSizeFirestoreData(lotSize, forFieldValue);
  final nestedData = lotSizeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = lotSize.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLotSizeFirestoreData(
  LotSizeStruct? lotSize, [
  bool forFieldValue = false,
]) {
  if (lotSize == null) {
    return {};
  }
  final firestoreData = mapToFirestore(lotSize.toMap());

  // Add any Firestore field values
  lotSize.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLotSizeListFirestoreData(
  List<LotSizeStruct>? lotSizes,
) =>
    lotSizes?.map((e) => getLotSizeFirestoreData(e, true)).toList() ?? [];
