// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ListingBrokerStruct extends FFFirebaseStruct {
  ListingBrokerStruct({
    bool? isRedfin,
    String? name,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _isRedfin = isRedfin,
        _name = name,
        super(firestoreUtilData);

  // "isRedfin" field.
  bool? _isRedfin;
  bool get isRedfin => _isRedfin ?? false;
  set isRedfin(bool? val) => _isRedfin = val;

  bool hasIsRedfin() => _isRedfin != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  static ListingBrokerStruct fromMap(Map<String, dynamic> data) =>
      ListingBrokerStruct(
        isRedfin: data['isRedfin'] as bool?,
        name: data['name'] as String?,
      );

  static ListingBrokerStruct? maybeFromMap(dynamic data) => data is Map
      ? ListingBrokerStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'isRedfin': _isRedfin,
        'name': _name,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isRedfin': serializeParam(
          _isRedfin,
          ParamType.bool,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
      }.withoutNulls;

  static ListingBrokerStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingBrokerStruct(
        isRedfin: deserializeParam(
          data['isRedfin'],
          ParamType.bool,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ListingBrokerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ListingBrokerStruct &&
        isRedfin == other.isRedfin &&
        name == other.name;
  }

  @override
  int get hashCode => const ListEquality().hash([isRedfin, name]);
}

ListingBrokerStruct createListingBrokerStruct({
  bool? isRedfin,
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ListingBrokerStruct(
      isRedfin: isRedfin,
      name: name,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ListingBrokerStruct? updateListingBrokerStruct(
  ListingBrokerStruct? listingBroker, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    listingBroker
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addListingBrokerStructData(
  Map<String, dynamic> firestoreData,
  ListingBrokerStruct? listingBroker,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (listingBroker == null) {
    return;
  }
  if (listingBroker.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && listingBroker.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final listingBrokerData =
      getListingBrokerFirestoreData(listingBroker, forFieldValue);
  final nestedData =
      listingBrokerData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = listingBroker.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getListingBrokerFirestoreData(
  ListingBrokerStruct? listingBroker, [
  bool forFieldValue = false,
]) {
  if (listingBroker == null) {
    return {};
  }
  final firestoreData = mapToFirestore(listingBroker.toMap());

  // Add any Firestore field values
  listingBroker.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getListingBrokerListFirestoreData(
  List<ListingBrokerStruct>? listingBrokers,
) =>
    listingBrokers
        ?.map((e) => getListingBrokerFirestoreData(e, true))
        .toList() ??
    [];
