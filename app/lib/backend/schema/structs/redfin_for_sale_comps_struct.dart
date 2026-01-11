// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RedfinForSaleCompsStruct extends FFFirebaseStruct {
  RedfinForSaleCompsStruct({
    LatLongStruct? latLong,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _latLong = latLong,
        super(firestoreUtilData);

  // "latLong" field.
  LatLongStruct? _latLong;
  LatLongStruct get latLong => _latLong ?? LatLongStruct();
  set latLong(LatLongStruct? val) => _latLong = val;

  void updateLatLong(Function(LatLongStruct) updateFn) {
    updateFn(_latLong ??= LatLongStruct());
  }

  bool hasLatLong() => _latLong != null;

  static RedfinForSaleCompsStruct fromMap(Map<String, dynamic> data) =>
      RedfinForSaleCompsStruct(
        latLong: data['latLong'] is LatLongStruct
            ? data['latLong']
            : LatLongStruct.maybeFromMap(data['latLong']),
      );

  static RedfinForSaleCompsStruct? maybeFromMap(dynamic data) => data is Map
      ? RedfinForSaleCompsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'latLong': _latLong?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'latLong': serializeParam(
          _latLong,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static RedfinForSaleCompsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RedfinForSaleCompsStruct(
        latLong: deserializeStructParam(
          data['latLong'],
          ParamType.DataStruct,
          false,
          structBuilder: LatLongStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RedfinForSaleCompsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RedfinForSaleCompsStruct && latLong == other.latLong;
  }

  @override
  int get hashCode => const ListEquality().hash([latLong]);
}

RedfinForSaleCompsStruct createRedfinForSaleCompsStruct({
  LatLongStruct? latLong,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RedfinForSaleCompsStruct(
      latLong: latLong ?? (clearUnsetFields ? LatLongStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RedfinForSaleCompsStruct? updateRedfinForSaleCompsStruct(
  RedfinForSaleCompsStruct? redfinForSaleComps, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    redfinForSaleComps
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRedfinForSaleCompsStructData(
  Map<String, dynamic> firestoreData,
  RedfinForSaleCompsStruct? redfinForSaleComps,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (redfinForSaleComps == null) {
    return;
  }
  if (redfinForSaleComps.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && redfinForSaleComps.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final redfinForSaleCompsData =
      getRedfinForSaleCompsFirestoreData(redfinForSaleComps, forFieldValue);
  final nestedData =
      redfinForSaleCompsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      redfinForSaleComps.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRedfinForSaleCompsFirestoreData(
  RedfinForSaleCompsStruct? redfinForSaleComps, [
  bool forFieldValue = false,
]) {
  if (redfinForSaleComps == null) {
    return {};
  }
  final firestoreData = mapToFirestore(redfinForSaleComps.toMap());

  // Handle nested data for "latLong" field.
  addLatLongStructData(
    firestoreData,
    redfinForSaleComps.hasLatLong() ? redfinForSaleComps.latLong : null,
    'latLong',
    forFieldValue,
  );

  // Add any Firestore field values
  redfinForSaleComps.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRedfinForSaleCompsListFirestoreData(
  List<RedfinForSaleCompsStruct>? redfinForSaleCompss,
) =>
    redfinForSaleCompss
        ?.map((e) => getRedfinForSaleCompsFirestoreData(e, true))
        .toList() ??
    [];
