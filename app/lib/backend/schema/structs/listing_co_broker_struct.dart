// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ListingCoBrokerStruct extends FFFirebaseStruct {
  ListingCoBrokerStruct({
    bool? isRedfin,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _isRedfin = isRedfin,
        super(firestoreUtilData);

  // "isRedfin" field.
  bool? _isRedfin;
  bool get isRedfin => _isRedfin ?? false;
  set isRedfin(bool? val) => _isRedfin = val;

  bool hasIsRedfin() => _isRedfin != null;

  static ListingCoBrokerStruct fromMap(Map<String, dynamic> data) =>
      ListingCoBrokerStruct(
        isRedfin: data['isRedfin'] as bool?,
      );

  static ListingCoBrokerStruct? maybeFromMap(dynamic data) => data is Map
      ? ListingCoBrokerStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'isRedfin': _isRedfin,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isRedfin': serializeParam(
          _isRedfin,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ListingCoBrokerStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingCoBrokerStruct(
        isRedfin: deserializeParam(
          data['isRedfin'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ListingCoBrokerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ListingCoBrokerStruct && isRedfin == other.isRedfin;
  }

  @override
  int get hashCode => const ListEquality().hash([isRedfin]);
}

ListingCoBrokerStruct createListingCoBrokerStruct({
  bool? isRedfin,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ListingCoBrokerStruct(
      isRedfin: isRedfin,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ListingCoBrokerStruct? updateListingCoBrokerStruct(
  ListingCoBrokerStruct? listingCoBroker, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    listingCoBroker
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addListingCoBrokerStructData(
  Map<String, dynamic> firestoreData,
  ListingCoBrokerStruct? listingCoBroker,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (listingCoBroker == null) {
    return;
  }
  if (listingCoBroker.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && listingCoBroker.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final listingCoBrokerData =
      getListingCoBrokerFirestoreData(listingCoBroker, forFieldValue);
  final nestedData =
      listingCoBrokerData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = listingCoBroker.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getListingCoBrokerFirestoreData(
  ListingCoBrokerStruct? listingCoBroker, [
  bool forFieldValue = false,
]) {
  if (listingCoBroker == null) {
    return {};
  }
  final firestoreData = mapToFirestore(listingCoBroker.toMap());

  // Add any Firestore field values
  listingCoBroker.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getListingCoBrokerListFirestoreData(
  List<ListingCoBrokerStruct>? listingCoBrokers,
) =>
    listingCoBrokers
        ?.map((e) => getListingCoBrokerFirestoreData(e, true))
        .toList() ??
    [];
