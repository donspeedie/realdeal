// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PriceStruct extends FFFirebaseStruct {
  PriceStruct({
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

  static PriceStruct fromMap(Map<String, dynamic> data) => PriceStruct(
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static PriceStruct? maybeFromMap(dynamic data) =>
      data is Map ? PriceStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static PriceStruct fromSerializableMap(Map<String, dynamic> data) =>
      PriceStruct(
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
  String toString() => 'PriceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PriceStruct && level == other.level && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

PriceStruct createPriceStruct({
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PriceStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PriceStruct? updatePriceStruct(
  PriceStruct? price, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    price
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPriceStructData(
  Map<String, dynamic> firestoreData,
  PriceStruct? price,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (price == null) {
    return;
  }
  if (price.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && price.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final priceData = getPriceFirestoreData(price, forFieldValue);
  final nestedData = priceData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = price.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPriceFirestoreData(
  PriceStruct? price, [
  bool forFieldValue = false,
]) {
  if (price == null) {
    return {};
  }
  final firestoreData = mapToFirestore(price.toMap());

  // Add any Firestore field values
  price.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPriceListFirestoreData(
  List<PriceStruct>? prices,
) =>
    prices?.map((e) => getPriceFirestoreData(e, true)).toList() ?? [];
