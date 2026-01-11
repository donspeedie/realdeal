// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LatlngStruct extends FFFirebaseStruct {
  LatlngStruct({
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

  static LatlngStruct fromMap(Map<String, dynamic> data) => LatlngStruct(
        latitude: castToType<double>(data['latitude']),
        longitude: castToType<double>(data['longitude']),
      );

  static LatlngStruct? maybeFromMap(dynamic data) =>
      data is Map ? LatlngStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static LatlngStruct fromSerializableMap(Map<String, dynamic> data) =>
      LatlngStruct(
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
  String toString() => 'LatlngStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LatlngStruct &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode => const ListEquality().hash([latitude, longitude]);
}

LatlngStruct createLatlngStruct({
  double? latitude,
  double? longitude,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LatlngStruct(
      latitude: latitude,
      longitude: longitude,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LatlngStruct? updateLatlngStruct(
  LatlngStruct? latlng, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    latlng
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLatlngStructData(
  Map<String, dynamic> firestoreData,
  LatlngStruct? latlng,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (latlng == null) {
    return;
  }
  if (latlng.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && latlng.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final latlngData = getLatlngFirestoreData(latlng, forFieldValue);
  final nestedData = latlngData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = latlng.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLatlngFirestoreData(
  LatlngStruct? latlng, [
  bool forFieldValue = false,
]) {
  if (latlng == null) {
    return {};
  }
  final firestoreData = mapToFirestore(latlng.toMap());

  // Add any Firestore field values
  latlng.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLatlngListFirestoreData(
  List<LatlngStruct>? latlngs,
) =>
    latlngs?.map((e) => getLatlngFirestoreData(e, true)).toList() ?? [];
