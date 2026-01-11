// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class HoaStruct extends FFFirebaseStruct {
  HoaStruct({
    int? level,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _level = level,
        super(firestoreUtilData);

  // "level" field.
  int? _level;
  int get level => _level ?? 0;
  set level(int? val) => _level = val;

  void incrementLevel(int amount) => level = level + amount;

  bool hasLevel() => _level != null;

  static HoaStruct fromMap(Map<String, dynamic> data) => HoaStruct(
        level: castToType<int>(data['level']),
      );

  static HoaStruct? maybeFromMap(dynamic data) =>
      data is Map ? HoaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'level': _level,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'level': serializeParam(
          _level,
          ParamType.int,
        ),
      }.withoutNulls;

  static HoaStruct fromSerializableMap(Map<String, dynamic> data) => HoaStruct(
        level: deserializeParam(
          data['level'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'HoaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HoaStruct && level == other.level;
  }

  @override
  int get hashCode => const ListEquality().hash([level]);
}

HoaStruct createHoaStruct({
  int? level,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    HoaStruct(
      level: level,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

HoaStruct? updateHoaStruct(
  HoaStruct? hoa, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    hoa
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addHoaStructData(
  Map<String, dynamic> firestoreData,
  HoaStruct? hoa,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (hoa == null) {
    return;
  }
  if (hoa.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && hoa.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final hoaData = getHoaFirestoreData(hoa, forFieldValue);
  final nestedData = hoaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = hoa.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getHoaFirestoreData(
  HoaStruct? hoa, [
  bool forFieldValue = false,
]) {
  if (hoa == null) {
    return {};
  }
  final firestoreData = mapToFirestore(hoa.toMap());

  // Add any Firestore field values
  hoa.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getHoaListFirestoreData(
  List<HoaStruct>? hoas,
) =>
    hoas?.map((e) => getHoaFirestoreData(e, true)).toList() ?? [];
