// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RedfinSoldCompsStruct extends FFFirebaseStruct {
  RedfinSoldCompsStruct({
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

  static RedfinSoldCompsStruct fromMap(Map<String, dynamic> data) =>
      RedfinSoldCompsStruct(
        latLong: data['latLong'] is LatLongStruct
            ? data['latLong']
            : LatLongStruct.maybeFromMap(data['latLong']),
      );

  static RedfinSoldCompsStruct? maybeFromMap(dynamic data) => data is Map
      ? RedfinSoldCompsStruct.fromMap(data.cast<String, dynamic>())
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

  static RedfinSoldCompsStruct fromSerializableMap(Map<String, dynamic> data) =>
      RedfinSoldCompsStruct(
        latLong: deserializeStructParam(
          data['latLong'],
          ParamType.DataStruct,
          false,
          structBuilder: LatLongStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RedfinSoldCompsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RedfinSoldCompsStruct && latLong == other.latLong;
  }

  @override
  int get hashCode => const ListEquality().hash([latLong]);
}

RedfinSoldCompsStruct createRedfinSoldCompsStruct({
  LatLongStruct? latLong,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RedfinSoldCompsStruct(
      latLong: latLong ?? (clearUnsetFields ? LatLongStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RedfinSoldCompsStruct? updateRedfinSoldCompsStruct(
  RedfinSoldCompsStruct? redfinSoldComps, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    redfinSoldComps
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRedfinSoldCompsStructData(
  Map<String, dynamic> firestoreData,
  RedfinSoldCompsStruct? redfinSoldComps,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (redfinSoldComps == null) {
    return;
  }
  if (redfinSoldComps.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && redfinSoldComps.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final redfinSoldCompsData =
      getRedfinSoldCompsFirestoreData(redfinSoldComps, forFieldValue);
  final nestedData =
      redfinSoldCompsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = redfinSoldComps.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRedfinSoldCompsFirestoreData(
  RedfinSoldCompsStruct? redfinSoldComps, [
  bool forFieldValue = false,
]) {
  if (redfinSoldComps == null) {
    return {};
  }
  final firestoreData = mapToFirestore(redfinSoldComps.toMap());

  // Handle nested data for "latLong" field.
  addLatLongStructData(
    firestoreData,
    redfinSoldComps.hasLatLong() ? redfinSoldComps.latLong : null,
    'latLong',
    forFieldValue,
  );

  // Add any Firestore field values
  redfinSoldComps.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRedfinSoldCompsListFirestoreData(
  List<RedfinSoldCompsStruct>? redfinSoldCompss,
) =>
    redfinSoldCompss
        ?.map((e) => getRedfinSoldCompsFirestoreData(e, true))
        .toList() ??
    [];
