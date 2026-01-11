// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PriceRedfinStruct extends FFFirebaseStruct {
  PriceRedfinStruct({
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

  static PriceRedfinStruct fromMap(Map<String, dynamic> data) =>
      PriceRedfinStruct(
        level: castToType<int>(data['level']),
        value: castToType<double>(data['value']),
      );

  static PriceRedfinStruct? maybeFromMap(dynamic data) => data is Map
      ? PriceRedfinStruct.fromMap(data.cast<String, dynamic>())
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

  static PriceRedfinStruct fromSerializableMap(Map<String, dynamic> data) =>
      PriceRedfinStruct(
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
  String toString() => 'PriceRedfinStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PriceRedfinStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

PriceRedfinStruct createPriceRedfinStruct({
  int? level,
  double? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PriceRedfinStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PriceRedfinStruct? updatePriceRedfinStruct(
  PriceRedfinStruct? priceRedfin, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    priceRedfin
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPriceRedfinStructData(
  Map<String, dynamic> firestoreData,
  PriceRedfinStruct? priceRedfin,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (priceRedfin == null) {
    return;
  }
  if (priceRedfin.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && priceRedfin.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final priceRedfinData =
      getPriceRedfinFirestoreData(priceRedfin, forFieldValue);
  final nestedData =
      priceRedfinData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = priceRedfin.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPriceRedfinFirestoreData(
  PriceRedfinStruct? priceRedfin, [
  bool forFieldValue = false,
]) {
  if (priceRedfin == null) {
    return {};
  }
  final firestoreData = mapToFirestore(priceRedfin.toMap());

  // Add any Firestore field values
  priceRedfin.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPriceRedfinListFirestoreData(
  List<PriceRedfinStruct>? priceRedfins,
) =>
    priceRedfins?.map((e) => getPriceRedfinFirestoreData(e, true)).toList() ??
    [];
