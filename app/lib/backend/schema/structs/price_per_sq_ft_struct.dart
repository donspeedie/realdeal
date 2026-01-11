// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PricePerSqFtStruct extends FFFirebaseStruct {
  PricePerSqFtStruct({
    int? level,
    double? value,
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
  double? _value;
  double get value => _value ?? 0.0;
  set value(double? val) => _value = val;

  void incrementValue(double amount) => value = value + amount;

  bool hasValue() => _value != null;

  static PricePerSqFtStruct fromMap(Map<String, dynamic> data) =>
      PricePerSqFtStruct(
        level: castToType<int>(data['level']),
        value: castToType<double>(data['value']),
      );

  static PricePerSqFtStruct? maybeFromMap(dynamic data) => data is Map
      ? PricePerSqFtStruct.fromMap(data.cast<String, dynamic>())
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
          ParamType.double,
        ),
      }.withoutNulls;

  static PricePerSqFtStruct fromSerializableMap(Map<String, dynamic> data) =>
      PricePerSqFtStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PricePerSqFtStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PricePerSqFtStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

PricePerSqFtStruct createPricePerSqFtStruct({
  int? level,
  double? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PricePerSqFtStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PricePerSqFtStruct? updatePricePerSqFtStruct(
  PricePerSqFtStruct? pricePerSqFt, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    pricePerSqFt
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPricePerSqFtStructData(
  Map<String, dynamic> firestoreData,
  PricePerSqFtStruct? pricePerSqFt,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (pricePerSqFt == null) {
    return;
  }
  if (pricePerSqFt.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && pricePerSqFt.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final pricePerSqFtData =
      getPricePerSqFtFirestoreData(pricePerSqFt, forFieldValue);
  final nestedData =
      pricePerSqFtData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = pricePerSqFt.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPricePerSqFtFirestoreData(
  PricePerSqFtStruct? pricePerSqFt, [
  bool forFieldValue = false,
]) {
  if (pricePerSqFt == null) {
    return {};
  }
  final firestoreData = mapToFirestore(pricePerSqFt.toMap());

  // Add any Firestore field values
  pricePerSqFt.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPricePerSqFtListFirestoreData(
  List<PricePerSqFtStruct>? pricePerSqFts,
) =>
    pricePerSqFts?.map((e) => getPricePerSqFtFirestoreData(e, true)).toList() ??
    [];
