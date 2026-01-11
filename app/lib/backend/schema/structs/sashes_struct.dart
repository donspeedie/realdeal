// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SashesStruct extends FFFirebaseStruct {
  SashesStruct({
    bool? isActiveKeyListing,
    bool? isRedfin,
    String? lastSaleDate,
    String? lastSalePrice,
    String? openHouseText,
    int? sashType,
    String? sashTypeColor,
    int? sashTypeId,
    String? sashTypeName,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _isActiveKeyListing = isActiveKeyListing,
        _isRedfin = isRedfin,
        _lastSaleDate = lastSaleDate,
        _lastSalePrice = lastSalePrice,
        _openHouseText = openHouseText,
        _sashType = sashType,
        _sashTypeColor = sashTypeColor,
        _sashTypeId = sashTypeId,
        _sashTypeName = sashTypeName,
        super(firestoreUtilData);

  // "isActiveKeyListing" field.
  bool? _isActiveKeyListing;
  bool get isActiveKeyListing => _isActiveKeyListing ?? false;
  set isActiveKeyListing(bool? val) => _isActiveKeyListing = val;

  bool hasIsActiveKeyListing() => _isActiveKeyListing != null;

  // "isRedfin" field.
  bool? _isRedfin;
  bool get isRedfin => _isRedfin ?? false;
  set isRedfin(bool? val) => _isRedfin = val;

  bool hasIsRedfin() => _isRedfin != null;

  // "lastSaleDate" field.
  String? _lastSaleDate;
  String get lastSaleDate => _lastSaleDate ?? '';
  set lastSaleDate(String? val) => _lastSaleDate = val;

  bool hasLastSaleDate() => _lastSaleDate != null;

  // "lastSalePrice" field.
  String? _lastSalePrice;
  String get lastSalePrice => _lastSalePrice ?? '';
  set lastSalePrice(String? val) => _lastSalePrice = val;

  bool hasLastSalePrice() => _lastSalePrice != null;

  // "openHouseText" field.
  String? _openHouseText;
  String get openHouseText => _openHouseText ?? '';
  set openHouseText(String? val) => _openHouseText = val;

  bool hasOpenHouseText() => _openHouseText != null;

  // "sashType" field.
  int? _sashType;
  int get sashType => _sashType ?? 0;
  set sashType(int? val) => _sashType = val;

  void incrementSashType(int amount) => sashType = sashType + amount;

  bool hasSashType() => _sashType != null;

  // "sashTypeColor" field.
  String? _sashTypeColor;
  String get sashTypeColor => _sashTypeColor ?? '';
  set sashTypeColor(String? val) => _sashTypeColor = val;

  bool hasSashTypeColor() => _sashTypeColor != null;

  // "sashTypeId" field.
  int? _sashTypeId;
  int get sashTypeId => _sashTypeId ?? 0;
  set sashTypeId(int? val) => _sashTypeId = val;

  void incrementSashTypeId(int amount) => sashTypeId = sashTypeId + amount;

  bool hasSashTypeId() => _sashTypeId != null;

  // "sashTypeName" field.
  String? _sashTypeName;
  String get sashTypeName => _sashTypeName ?? '';
  set sashTypeName(String? val) => _sashTypeName = val;

  bool hasSashTypeName() => _sashTypeName != null;

  static SashesStruct fromMap(Map<String, dynamic> data) => SashesStruct(
        isActiveKeyListing: data['isActiveKeyListing'] as bool?,
        isRedfin: data['isRedfin'] as bool?,
        lastSaleDate: data['lastSaleDate'] as String?,
        lastSalePrice: data['lastSalePrice'] as String?,
        openHouseText: data['openHouseText'] as String?,
        sashType: castToType<int>(data['sashType']),
        sashTypeColor: data['sashTypeColor'] as String?,
        sashTypeId: castToType<int>(data['sashTypeId']),
        sashTypeName: data['sashTypeName'] as String?,
      );

  static SashesStruct? maybeFromMap(dynamic data) =>
      data is Map ? SashesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'isActiveKeyListing': _isActiveKeyListing,
        'isRedfin': _isRedfin,
        'lastSaleDate': _lastSaleDate,
        'lastSalePrice': _lastSalePrice,
        'openHouseText': _openHouseText,
        'sashType': _sashType,
        'sashTypeColor': _sashTypeColor,
        'sashTypeId': _sashTypeId,
        'sashTypeName': _sashTypeName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isActiveKeyListing': serializeParam(
          _isActiveKeyListing,
          ParamType.bool,
        ),
        'isRedfin': serializeParam(
          _isRedfin,
          ParamType.bool,
        ),
        'lastSaleDate': serializeParam(
          _lastSaleDate,
          ParamType.String,
        ),
        'lastSalePrice': serializeParam(
          _lastSalePrice,
          ParamType.String,
        ),
        'openHouseText': serializeParam(
          _openHouseText,
          ParamType.String,
        ),
        'sashType': serializeParam(
          _sashType,
          ParamType.int,
        ),
        'sashTypeColor': serializeParam(
          _sashTypeColor,
          ParamType.String,
        ),
        'sashTypeId': serializeParam(
          _sashTypeId,
          ParamType.int,
        ),
        'sashTypeName': serializeParam(
          _sashTypeName,
          ParamType.String,
        ),
      }.withoutNulls;

  static SashesStruct fromSerializableMap(Map<String, dynamic> data) =>
      SashesStruct(
        isActiveKeyListing: deserializeParam(
          data['isActiveKeyListing'],
          ParamType.bool,
          false,
        ),
        isRedfin: deserializeParam(
          data['isRedfin'],
          ParamType.bool,
          false,
        ),
        lastSaleDate: deserializeParam(
          data['lastSaleDate'],
          ParamType.String,
          false,
        ),
        lastSalePrice: deserializeParam(
          data['lastSalePrice'],
          ParamType.String,
          false,
        ),
        openHouseText: deserializeParam(
          data['openHouseText'],
          ParamType.String,
          false,
        ),
        sashType: deserializeParam(
          data['sashType'],
          ParamType.int,
          false,
        ),
        sashTypeColor: deserializeParam(
          data['sashTypeColor'],
          ParamType.String,
          false,
        ),
        sashTypeId: deserializeParam(
          data['sashTypeId'],
          ParamType.int,
          false,
        ),
        sashTypeName: deserializeParam(
          data['sashTypeName'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SashesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SashesStruct &&
        isActiveKeyListing == other.isActiveKeyListing &&
        isRedfin == other.isRedfin &&
        lastSaleDate == other.lastSaleDate &&
        lastSalePrice == other.lastSalePrice &&
        openHouseText == other.openHouseText &&
        sashType == other.sashType &&
        sashTypeColor == other.sashTypeColor &&
        sashTypeId == other.sashTypeId &&
        sashTypeName == other.sashTypeName;
  }

  @override
  int get hashCode => const ListEquality().hash([
        isActiveKeyListing,
        isRedfin,
        lastSaleDate,
        lastSalePrice,
        openHouseText,
        sashType,
        sashTypeColor,
        sashTypeId,
        sashTypeName
      ]);
}

SashesStruct createSashesStruct({
  bool? isActiveKeyListing,
  bool? isRedfin,
  String? lastSaleDate,
  String? lastSalePrice,
  String? openHouseText,
  int? sashType,
  String? sashTypeColor,
  int? sashTypeId,
  String? sashTypeName,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SashesStruct(
      isActiveKeyListing: isActiveKeyListing,
      isRedfin: isRedfin,
      lastSaleDate: lastSaleDate,
      lastSalePrice: lastSalePrice,
      openHouseText: openHouseText,
      sashType: sashType,
      sashTypeColor: sashTypeColor,
      sashTypeId: sashTypeId,
      sashTypeName: sashTypeName,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SashesStruct? updateSashesStruct(
  SashesStruct? sashes, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sashes
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSashesStructData(
  Map<String, dynamic> firestoreData,
  SashesStruct? sashes,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sashes == null) {
    return;
  }
  if (sashes.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sashes.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sashesData = getSashesFirestoreData(sashes, forFieldValue);
  final nestedData = sashesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sashes.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSashesFirestoreData(
  SashesStruct? sashes, [
  bool forFieldValue = false,
]) {
  if (sashes == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sashes.toMap());

  // Add any Firestore field values
  sashes.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSashesListFirestoreData(
  List<SashesStruct>? sashess,
) =>
    sashess?.map((e) => getSashesFirestoreData(e, true)).toList() ?? [];
