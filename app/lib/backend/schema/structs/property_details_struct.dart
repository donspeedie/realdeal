// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropertyDetailsStruct extends FFFirebaseStruct {
  PropertyDetailsStruct({
    String? description,
    LatlngStruct? latlng,
    List<RedfinSoldCompsStruct>? redfinSoldComps,
    List<RedfinForSaleCompsStruct>? redfinForSaleComps,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _description = description,
        _latlng = latlng,
        _redfinSoldComps = redfinSoldComps,
        _redfinForSaleComps = redfinForSaleComps,
        super(firestoreUtilData);

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "latlng" field.
  LatlngStruct? _latlng;
  LatlngStruct get latlng => _latlng ?? LatlngStruct();
  set latlng(LatlngStruct? val) => _latlng = val;

  void updateLatlng(Function(LatlngStruct) updateFn) {
    updateFn(_latlng ??= LatlngStruct());
  }

  bool hasLatlng() => _latlng != null;

  // "redfinSoldComps" field.
  List<RedfinSoldCompsStruct>? _redfinSoldComps;
  List<RedfinSoldCompsStruct> get redfinSoldComps =>
      _redfinSoldComps ?? const [];
  set redfinSoldComps(List<RedfinSoldCompsStruct>? val) =>
      _redfinSoldComps = val;

  void updateRedfinSoldComps(Function(List<RedfinSoldCompsStruct>) updateFn) {
    updateFn(_redfinSoldComps ??= []);
  }

  bool hasRedfinSoldComps() => _redfinSoldComps != null;

  // "redfinForSaleComps" field.
  List<RedfinForSaleCompsStruct>? _redfinForSaleComps;
  List<RedfinForSaleCompsStruct> get redfinForSaleComps =>
      _redfinForSaleComps ?? const [];
  set redfinForSaleComps(List<RedfinForSaleCompsStruct>? val) =>
      _redfinForSaleComps = val;

  void updateRedfinForSaleComps(
      Function(List<RedfinForSaleCompsStruct>) updateFn) {
    updateFn(_redfinForSaleComps ??= []);
  }

  bool hasRedfinForSaleComps() => _redfinForSaleComps != null;

  static PropertyDetailsStruct fromMap(Map<String, dynamic> data) =>
      PropertyDetailsStruct(
        description: data['description'] as String?,
        latlng: data['latlng'] is LatlngStruct
            ? data['latlng']
            : LatlngStruct.maybeFromMap(data['latlng']),
        redfinSoldComps: getStructList(
          data['redfinSoldComps'],
          RedfinSoldCompsStruct.fromMap,
        ),
        redfinForSaleComps: getStructList(
          data['redfinForSaleComps'],
          RedfinForSaleCompsStruct.fromMap,
        ),
      );

  static PropertyDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? PropertyDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'description': _description,
        'latlng': _latlng?.toMap(),
        'redfinSoldComps': _redfinSoldComps?.map((e) => e.toMap()).toList(),
        'redfinForSaleComps':
            _redfinForSaleComps?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'latlng': serializeParam(
          _latlng,
          ParamType.DataStruct,
        ),
        'redfinSoldComps': serializeParam(
          _redfinSoldComps,
          ParamType.DataStruct,
          isList: true,
        ),
        'redfinForSaleComps': serializeParam(
          _redfinForSaleComps,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static PropertyDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PropertyDetailsStruct(
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        latlng: deserializeStructParam(
          data['latlng'],
          ParamType.DataStruct,
          false,
          structBuilder: LatlngStruct.fromSerializableMap,
        ),
        redfinSoldComps: deserializeStructParam<RedfinSoldCompsStruct>(
          data['redfinSoldComps'],
          ParamType.DataStruct,
          true,
          structBuilder: RedfinSoldCompsStruct.fromSerializableMap,
        ),
        redfinForSaleComps: deserializeStructParam<RedfinForSaleCompsStruct>(
          data['redfinForSaleComps'],
          ParamType.DataStruct,
          true,
          structBuilder: RedfinForSaleCompsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PropertyDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PropertyDetailsStruct &&
        description == other.description &&
        latlng == other.latlng &&
        listEquality.equals(redfinSoldComps, other.redfinSoldComps) &&
        listEquality.equals(redfinForSaleComps, other.redfinForSaleComps);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([description, latlng, redfinSoldComps, redfinForSaleComps]);
}

PropertyDetailsStruct createPropertyDetailsStruct({
  String? description,
  LatlngStruct? latlng,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PropertyDetailsStruct(
      description: description,
      latlng: latlng ?? (clearUnsetFields ? LatlngStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PropertyDetailsStruct? updatePropertyDetailsStruct(
  PropertyDetailsStruct? propertyDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    propertyDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPropertyDetailsStructData(
  Map<String, dynamic> firestoreData,
  PropertyDetailsStruct? propertyDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (propertyDetails == null) {
    return;
  }
  if (propertyDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && propertyDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final propertyDetailsData =
      getPropertyDetailsFirestoreData(propertyDetails, forFieldValue);
  final nestedData =
      propertyDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = propertyDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPropertyDetailsFirestoreData(
  PropertyDetailsStruct? propertyDetails, [
  bool forFieldValue = false,
]) {
  if (propertyDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(propertyDetails.toMap());

  // Handle nested data for "latlng" field.
  addLatlngStructData(
    firestoreData,
    propertyDetails.hasLatlng() ? propertyDetails.latlng : null,
    'latlng',
    forFieldValue,
  );

  // Add any Firestore field values
  propertyDetails.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPropertyDetailsListFirestoreData(
  List<PropertyDetailsStruct>? propertyDetailss,
) =>
    propertyDetailss
        ?.map((e) => getPropertyDetailsFirestoreData(e, true))
        .toList() ??
    [];
