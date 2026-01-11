// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TimeOnRedfinStruct extends FFFirebaseStruct {
  TimeOnRedfinStruct({
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

  static TimeOnRedfinStruct fromMap(Map<String, dynamic> data) =>
      TimeOnRedfinStruct(
        date: castToType<int>(data['date']),
        level: castToType<int>(data['level']),
        value: castToType<int>(data['value']),
      );

  static TimeOnRedfinStruct? maybeFromMap(dynamic data) => data is Map
      ? TimeOnRedfinStruct.fromMap(data.cast<String, dynamic>())
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

  static TimeOnRedfinStruct fromSerializableMap(Map<String, dynamic> data) =>
      TimeOnRedfinStruct(
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
  String toString() => 'TimeOnRedfinStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TimeOnRedfinStruct &&
        date == other.date &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([date, level, value]);
}

TimeOnRedfinStruct createTimeOnRedfinStruct({
  int? date,
  int? level,
  int? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TimeOnRedfinStruct(
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

TimeOnRedfinStruct? updateTimeOnRedfinStruct(
  TimeOnRedfinStruct? timeOnRedfin, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    timeOnRedfin
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTimeOnRedfinStructData(
  Map<String, dynamic> firestoreData,
  TimeOnRedfinStruct? timeOnRedfin,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (timeOnRedfin == null) {
    return;
  }
  if (timeOnRedfin.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && timeOnRedfin.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final timeOnRedfinData =
      getTimeOnRedfinFirestoreData(timeOnRedfin, forFieldValue);
  final nestedData =
      timeOnRedfinData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = timeOnRedfin.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTimeOnRedfinFirestoreData(
  TimeOnRedfinStruct? timeOnRedfin, [
  bool forFieldValue = false,
]) {
  if (timeOnRedfin == null) {
    return {};
  }
  final firestoreData = mapToFirestore(timeOnRedfin.toMap());

  // Add any Firestore field values
  timeOnRedfin.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTimeOnRedfinListFirestoreData(
  List<TimeOnRedfinStruct>? timeOnRedfins,
) =>
    timeOnRedfins?.map((e) => getTimeOnRedfinFirestoreData(e, true)).toList() ??
    [];
