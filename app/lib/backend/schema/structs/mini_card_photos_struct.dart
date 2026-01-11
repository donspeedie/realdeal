// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MiniCardPhotosStruct extends FFFirebaseStruct {
  MiniCardPhotosStruct({
    String? url,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _url = url,
        super(firestoreUtilData);

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

  static MiniCardPhotosStruct fromMap(Map<String, dynamic> data) =>
      MiniCardPhotosStruct(
        url: data['url'] as String?,
      );

  static MiniCardPhotosStruct? maybeFromMap(dynamic data) => data is Map
      ? MiniCardPhotosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'url': _url,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
      }.withoutNulls;

  static MiniCardPhotosStruct fromSerializableMap(Map<String, dynamic> data) =>
      MiniCardPhotosStruct(
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MiniCardPhotosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MiniCardPhotosStruct && url == other.url;
  }

  @override
  int get hashCode => const ListEquality().hash([url]);
}

MiniCardPhotosStruct createMiniCardPhotosStruct({
  String? url,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MiniCardPhotosStruct(
      url: url,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MiniCardPhotosStruct? updateMiniCardPhotosStruct(
  MiniCardPhotosStruct? miniCardPhotos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    miniCardPhotos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMiniCardPhotosStructData(
  Map<String, dynamic> firestoreData,
  MiniCardPhotosStruct? miniCardPhotos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (miniCardPhotos == null) {
    return;
  }
  if (miniCardPhotos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && miniCardPhotos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final miniCardPhotosData =
      getMiniCardPhotosFirestoreData(miniCardPhotos, forFieldValue);
  final nestedData =
      miniCardPhotosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = miniCardPhotos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMiniCardPhotosFirestoreData(
  MiniCardPhotosStruct? miniCardPhotos, [
  bool forFieldValue = false,
]) {
  if (miniCardPhotos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(miniCardPhotos.toMap());

  // Add any Firestore field values
  miniCardPhotos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMiniCardPhotosListFirestoreData(
  List<MiniCardPhotosStruct>? miniCardPhotoss,
) =>
    miniCardPhotoss
        ?.map((e) => getMiniCardPhotosFirestoreData(e, true))
        .toList() ??
    [];
