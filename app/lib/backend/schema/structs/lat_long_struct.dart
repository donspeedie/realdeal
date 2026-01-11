// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LatLongStruct extends FFFirebaseStruct {
  LatLongStruct({
    ValueStruct? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _value = value,
        super(firestoreUtilData);

  // "value" field.
  ValueStruct? _value;
  ValueStruct get value => _value ?? ValueStruct();
  set value(ValueStruct? val) => _value = val;

  void updateValue(Function(ValueStruct) updateFn) {
    updateFn(_value ??= ValueStruct());
  }

  bool hasValue() => _value != null;

  static LatLongStruct fromMap(Map<String, dynamic> data) => LatLongStruct(
        value: data['value'] is ValueStruct
            ? data['value']
            : ValueStruct.maybeFromMap(data['value']),
      );

  static LatLongStruct? maybeFromMap(dynamic data) =>
      data is Map ? LatLongStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'value': _value?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'value': serializeParam(
          _value,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static LatLongStruct fromSerializableMap(Map<String, dynamic> data) =>
      LatLongStruct(
        value: deserializeStructParam(
          data['value'],
          ParamType.DataStruct,
          false,
          structBuilder: ValueStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'LatLongStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LatLongStruct && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([value]);
}

LatLongStruct createLatLongStruct({
  ValueStruct? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LatLongStruct(
      value: value ?? (clearUnsetFields ? ValueStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LatLongStruct? updateLatLongStruct(
  LatLongStruct? latLong, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    latLong
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLatLongStructData(
  Map<String, dynamic> firestoreData,
  LatLongStruct? latLong,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (latLong == null) {
    return;
  }
  if (latLong.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && latLong.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final latLongData = getLatLongFirestoreData(latLong, forFieldValue);
  final nestedData = latLongData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = latLong.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLatLongFirestoreData(
  LatLongStruct? latLong, [
  bool forFieldValue = false,
]) {
  if (latLong == null) {
    return {};
  }
  final firestoreData = mapToFirestore(latLong.toMap());

  // Handle nested data for "value" field.
  addValueStructData(
    firestoreData,
    latLong.hasValue() ? latLong.value : null,
    'value',
    forFieldValue,
  );

  // Add any Firestore field values
  latLong.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLatLongListFirestoreData(
  List<LatLongStruct>? latLongs,
) =>
    latLongs?.map((e) => getLatLongFirestoreData(e, true)).toList() ?? [];
