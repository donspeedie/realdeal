// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MlsIdStruct extends FFFirebaseStruct {
  MlsIdStruct({
    String? label,
    String? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _label = label,
        _value = value,
        super(firestoreUtilData);

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "value" field.
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static MlsIdStruct fromMap(Map<String, dynamic> data) => MlsIdStruct(
        label: data['label'] as String?,
        value: data['value'] as String?,
      );

  static MlsIdStruct? maybeFromMap(dynamic data) =>
      data is Map ? MlsIdStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.String,
        ),
      }.withoutNulls;

  static MlsIdStruct fromSerializableMap(Map<String, dynamic> data) =>
      MlsIdStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MlsIdStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MlsIdStruct && label == other.label && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([label, value]);
}

MlsIdStruct createMlsIdStruct({
  String? label,
  String? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MlsIdStruct(
      label: label,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MlsIdStruct? updateMlsIdStruct(
  MlsIdStruct? mlsId, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mlsId
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMlsIdStructData(
  Map<String, dynamic> firestoreData,
  MlsIdStruct? mlsId,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mlsId == null) {
    return;
  }
  if (mlsId.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mlsId.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mlsIdData = getMlsIdFirestoreData(mlsId, forFieldValue);
  final nestedData = mlsIdData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mlsId.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMlsIdFirestoreData(
  MlsIdStruct? mlsId, [
  bool forFieldValue = false,
]) {
  if (mlsId == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mlsId.toMap());

  // Add any Firestore field values
  mlsId.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMlsIdListFirestoreData(
  List<MlsIdStruct>? mlsIds,
) =>
    mlsIds?.map((e) => getMlsIdFirestoreData(e, true)).toList() ?? [];
