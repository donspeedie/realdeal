// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class OriginalTimeOnRedfinStruct extends FFFirebaseStruct {
  OriginalTimeOnRedfinStruct({
    int? date,
    int? level,
    int? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _date = date,
        _level = level,
        _value = value,
        super(firestoreUtilData);

  // "date" field.
  int? _date;
  int get date => _date ?? 0;
  set date(int? val) => _date = val;

  void incrementDate(int amount) => date = date + amount;

  bool hasDate() => _date != null;

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

  static OriginalTimeOnRedfinStruct fromMap(Map<String, dynamic> data) =>
      OriginalTimeOnRedfinStruct(
        date: castToType<int>(data['date']),
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static OriginalTimeOnRedfinStruct? maybeFromMap(dynamic data) => data is Map
      ? OriginalTimeOnRedfinStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'date': _date,
        'level': _level,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'date': serializeParam(
          _date,
          ParamType.int,
        ),
        'level': serializeParam(
          _level,
          ParamType.int,
        ),
        'value': serializeParam(
          _value,
          ParamType.int,
        ),
      }.withoutNulls;

  static OriginalTimeOnRedfinStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      OriginalTimeOnRedfinStruct(
        date: deserializeParam(
          data['date'],
          ParamType.int,
          false,
        ),
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
  String toString() => 'OriginalTimeOnRedfinStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OriginalTimeOnRedfinStruct &&
        date == other.date &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([date, level, value]);
}

OriginalTimeOnRedfinStruct createOriginalTimeOnRedfinStruct({
  int? date,
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    OriginalTimeOnRedfinStruct(
      date: date,
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

OriginalTimeOnRedfinStruct? updateOriginalTimeOnRedfinStruct(
  OriginalTimeOnRedfinStruct? originalTimeOnRedfin, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    originalTimeOnRedfin
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addOriginalTimeOnRedfinStructData(
  Map<String, dynamic> firestoreData,
  OriginalTimeOnRedfinStruct? originalTimeOnRedfin,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (originalTimeOnRedfin == null) {
    return;
  }
  if (originalTimeOnRedfin.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && originalTimeOnRedfin.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final originalTimeOnRedfinData =
      getOriginalTimeOnRedfinFirestoreData(originalTimeOnRedfin, forFieldValue);
  final nestedData =
      originalTimeOnRedfinData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      originalTimeOnRedfin.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getOriginalTimeOnRedfinFirestoreData(
  OriginalTimeOnRedfinStruct? originalTimeOnRedfin, [
  bool forFieldValue = false,
]) {
  if (originalTimeOnRedfin == null) {
    return {};
  }
  final firestoreData = mapToFirestore(originalTimeOnRedfin.toMap());

  // Add any Firestore field values
  originalTimeOnRedfin.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getOriginalTimeOnRedfinListFirestoreData(
  List<OriginalTimeOnRedfinStruct>? originalTimeOnRedfins,
) =>
    originalTimeOnRedfins
        ?.map((e) => getOriginalTimeOnRedfinFirestoreData(e, true))
        .toList() ??
    [];
