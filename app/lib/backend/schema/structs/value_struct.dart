// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ValueStruct extends FFFirebaseStruct {
  ValueStruct({
    double? latitude,
    double? longitude,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _latitude = latitude,
        _longitude = longitude,
        super(firestoreUtilData);

  // "latitude" field.
  double? _latitude;
  double get latitude => _latitude ?? 0.0;
  set latitude(double? val) => _latitude = val;

  void incrementLatitude(double amount) => latitude = latitude + amount;

  bool hasLatitude() => _latitude != null;

  // "longitude" field.
  double? _longitude;
  double get longitude => _longitude ?? 0.0;
  set longitude(double? val) => _longitude = val;

  void incrementLongitude(double amount) => longitude = longitude + amount;

  bool hasLongitude() => _longitude != null;

  static ValueStruct fromMap(Map<String, dynamic> data) => ValueStruct(
        latitude: castToType<double>(data['latitude']),
        longitude: castToType<double>(data['longitude']),
      );

  static ValueStruct? maybeFromMap(dynamic data) =>
      data is Map ? ValueStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'latitude': _latitude,
        'longitude': _longitude,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'latitude': serializeParam(
          _latitude,
          ParamType.double,
        ),
        'longitude': serializeParam(
          _longitude,
          ParamType.double,
        ),
      }.withoutNulls;

  static ValueStruct fromSerializableMap(Map<String, dynamic> data) =>
      ValueStruct(
        latitude: deserializeParam(
          data['latitude'],
          ParamType.double,
          false,
        ),
        longitude: deserializeParam(
          data['longitude'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'ValueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ValueStruct &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode => const ListEquality().hash([latitude, longitude]);
}

ValueStruct createValueStruct({
  double? latitude,
  double? longitude,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ValueStruct(
      latitude: latitude,
      longitude: longitude,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ValueStruct? updateValueStruct(
  ValueStruct? value, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    value
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addValueStructData(
  Map<String, dynamic> firestoreData,
  ValueStruct? value,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (value == null) {
    return;
  }
  if (value.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && value.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final valueData = getValueFirestoreData(value, forFieldValue);
  final nestedData = valueData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = value.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getValueFirestoreData(
  ValueStruct? value, [
  bool forFieldValue = false,
]) {
  if (value == null) {
    return {};
  }
  final firestoreData = mapToFirestore(value.toMap());

  // Add any Firestore field values
  value.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getValueListFirestoreData(
  List<ValueStruct>? values,
) =>
    values?.map((e) => getValueFirestoreData(e, true)).toList() ?? [];
