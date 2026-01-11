// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PostalCodeStruct extends FFFirebaseStruct {
  PostalCodeStruct({
    int? level,
    String? value,
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
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static PostalCodeStruct fromMap(Map<String, dynamic> data) =>
      PostalCodeStruct(
        level: castToType<int>(data['level']),
        value: data['value'] as String?,
      );

  static PostalCodeStruct? maybeFromMap(dynamic data) => data is Map
      ? PostalCodeStruct.fromMap(data.cast<String, dynamic>())
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
          ParamType.String,
        ),
      }.withoutNulls;

  static PostalCodeStruct fromSerializableMap(Map<String, dynamic> data) =>
      PostalCodeStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PostalCodeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PostalCodeStruct &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([level, value]);
}

PostalCodeStruct createPostalCodeStruct({
  int? level,
  String? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PostalCodeStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PostalCodeStruct? updatePostalCodeStruct(
  PostalCodeStruct? postalCode, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    postalCode
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPostalCodeStructData(
  Map<String, dynamic> firestoreData,
  PostalCodeStruct? postalCode,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (postalCode == null) {
    return;
  }
  if (postalCode.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && postalCode.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final postalCodeData = getPostalCodeFirestoreData(postalCode, forFieldValue);
  final nestedData = postalCodeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = postalCode.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPostalCodeFirestoreData(
  PostalCodeStruct? postalCode, [
  bool forFieldValue = false,
]) {
  if (postalCode == null) {
    return {};
  }
  final firestoreData = mapToFirestore(postalCode.toMap());

  // Add any Firestore field values
  postalCode.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPostalCodeListFirestoreData(
  List<PostalCodeStruct>? postalCodes,
) =>
    postalCodes?.map((e) => getPostalCodeFirestoreData(e, true)).toList() ?? [];
