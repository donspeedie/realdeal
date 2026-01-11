// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PhotosStruct extends FFFirebaseStruct {
  PhotosStruct({
    List<String>? items,
    int? level,
    String? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _items = items,
        _level = level,
        _value = value,
        super(firestoreUtilData);

  // "items" field.
  List<String>? _items;
  List<String> get items => _items ?? const [];
  set items(List<String>? val) => _items = val;

  void updateItems(Function(List<String>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

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

  static PhotosStruct fromMap(Map<String, dynamic> data) => PhotosStruct(
        items: getDataList(data['items']),
        level: castToType<int>(data['level']),
        value: data['value'] as String?,
      );

  static PhotosStruct? maybeFromMap(dynamic data) =>
      data is Map ? PhotosStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'items': _items,
        'level': _level,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'items': serializeParam(
          _items,
          ParamType.String,
          isList: true,
        ),
        'level': serializeParam(
          _level,
          ParamType.int,
        ),
        'value': serializeParam(
          _value,
          ParamType.String,
        ),
      }.withoutNulls;

  static PhotosStruct fromSerializableMap(Map<String, dynamic> data) =>
      PhotosStruct(
        items: deserializeParam<String>(
          data['items'],
          ParamType.String,
          true,
        ),
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
  String toString() => 'PhotosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PhotosStruct &&
        listEquality.equals(items, other.items) &&
        level == other.level &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([items, level, value]);
}

PhotosStruct createPhotosStruct({
  int? level,
  String? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PhotosStruct(
      level: level,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PhotosStruct? updatePhotosStruct(
  PhotosStruct? photos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    photos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPhotosStructData(
  Map<String, dynamic> firestoreData,
  PhotosStruct? photos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (photos == null) {
    return;
  }
  if (photos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && photos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final photosData = getPhotosFirestoreData(photos, forFieldValue);
  final nestedData = photosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = photos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPhotosFirestoreData(
  PhotosStruct? photos, [
  bool forFieldValue = false,
]) {
  if (photos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(photos.toMap());

  // Add any Firestore field values
  photos.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPhotosListFirestoreData(
  List<PhotosStruct>? photoss,
) =>
    photoss?.map((e) => getPhotosFirestoreData(e, true)).toList() ?? [];
