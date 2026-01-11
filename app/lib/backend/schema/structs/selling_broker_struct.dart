// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SellingBrokerStruct extends FFFirebaseStruct {
  SellingBrokerStruct({
    bool? isRedfin,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _isRedfin = isRedfin,
        super(firestoreUtilData);

  // "isRedfin" field.
  bool? _isRedfin;
  bool get isRedfin => _isRedfin ?? false;
  set isRedfin(bool? val) => _isRedfin = val;

  bool hasIsRedfin() => _isRedfin != null;

  static SellingBrokerStruct fromMap(Map<String, dynamic> data) =>
      SellingBrokerStruct(
        isRedfin: data['isRedfin'] as bool?,
      );

  static SellingBrokerStruct? maybeFromMap(dynamic data) => data is Map
      ? SellingBrokerStruct.fromMap(data.cast<String, dynamic>())
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

  static SellingBrokerStruct fromSerializableMap(Map<String, dynamic> data) =>
      SellingBrokerStruct(
        isRedfin: deserializeParam(
          data['isRedfin'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'SellingBrokerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SellingBrokerStruct && isRedfin == other.isRedfin;
  }

  @override
  int get hashCode => const ListEquality().hash([isRedfin]);
}

SellingBrokerStruct createSellingBrokerStruct({
  bool? isRedfin,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SellingBrokerStruct(
      isRedfin: isRedfin,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SellingBrokerStruct? updateSellingBrokerStruct(
  SellingBrokerStruct? sellingBroker, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sellingBroker
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSellingBrokerStructData(
  Map<String, dynamic> firestoreData,
  SellingBrokerStruct? sellingBroker,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sellingBroker == null) {
    return;
  }
  if (sellingBroker.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sellingBroker.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sellingBrokerData =
      getSellingBrokerFirestoreData(sellingBroker, forFieldValue);
  final nestedData =
      sellingBrokerData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sellingBroker.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSellingBrokerFirestoreData(
  SellingBrokerStruct? sellingBroker, [
  bool forFieldValue = false,
]) {
  if (sellingBroker == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sellingBroker.toMap());

  // Add any Firestore field values
  sellingBroker.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSellingBrokerListFirestoreData(
  List<SellingBrokerStruct>? sellingBrokers,
) =>
    sellingBrokers
        ?.map((e) => getSellingBrokerFirestoreData(e, true))
        .toList() ??
    [];
