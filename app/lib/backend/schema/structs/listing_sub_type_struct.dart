// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ListingSubTypeStruct extends FFFirebaseStruct {
  ListingSubTypeStruct({
    bool? isFSBA,
    bool? isOpenHouse,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _isFSBA = isFSBA,
        _isOpenHouse = isOpenHouse,
        super(firestoreUtilData);

  // "is_FSBA" field.
  bool? _isFSBA;
  bool get isFSBA => _isFSBA ?? false;
  set isFSBA(bool? val) => _isFSBA = val;

  bool hasIsFSBA() => _isFSBA != null;

  // "is_openHouse" field.
  bool? _isOpenHouse;
  bool get isOpenHouse => _isOpenHouse ?? false;
  set isOpenHouse(bool? val) => _isOpenHouse = val;

  bool hasIsOpenHouse() => _isOpenHouse != null;

  static ListingSubTypeStruct fromMap(Map<String, dynamic> data) =>
      ListingSubTypeStruct(
        isFSBA: data['is_FSBA'] as bool?,
        isOpenHouse: data['is_openHouse'] as bool?,
      );

  static ListingSubTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? ListingSubTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'is_FSBA': _isFSBA,
        'is_openHouse': _isOpenHouse,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'is_FSBA': serializeParam(
          _isFSBA,
          ParamType.bool,
        ),
        'is_openHouse': serializeParam(
          _isOpenHouse,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ListingSubTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingSubTypeStruct(
        isFSBA: deserializeParam(
          data['is_FSBA'],
          ParamType.bool,
          false,
        ),
        isOpenHouse: deserializeParam(
          data['is_openHouse'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ListingSubTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ListingSubTypeStruct &&
        isFSBA == other.isFSBA &&
        isOpenHouse == other.isOpenHouse;
  }

  @override
  int get hashCode => const ListEquality().hash([isFSBA, isOpenHouse]);
}

ListingSubTypeStruct createListingSubTypeStruct({
  bool? isFSBA,
  bool? isOpenHouse,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ListingSubTypeStruct(
      isFSBA: isFSBA,
      isOpenHouse: isOpenHouse,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ListingSubTypeStruct? updateListingSubTypeStruct(
  ListingSubTypeStruct? listingSubType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    listingSubType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addListingSubTypeStructData(
  Map<String, dynamic> firestoreData,
  ListingSubTypeStruct? listingSubType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (listingSubType == null) {
    return;
  }
  if (listingSubType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && listingSubType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final listingSubTypeData =
      getListingSubTypeFirestoreData(listingSubType, forFieldValue);
  final nestedData =
      listingSubTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = listingSubType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getListingSubTypeFirestoreData(
  ListingSubTypeStruct? listingSubType, [
  bool forFieldValue = false,
]) {
  if (listingSubType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(listingSubType.toMap());

  // Add any Firestore field values
  listingSubType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getListingSubTypeListFirestoreData(
  List<ListingSubTypeStruct>? listingSubTypes,
) =>
    listingSubTypes
        ?.map((e) => getListingSubTypeFirestoreData(e, true))
        .toList() ??
    [];
