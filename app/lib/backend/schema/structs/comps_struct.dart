// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Comps Data Type
class CompsStruct extends FFFirebaseStruct {
  CompsStruct({
    int? bedrooms,
    List<MiniCardPhotosStruct>? miniCardPhotos,
    int? price,
    int? livingArea,
    int? zpid,
    int? bathrooms,
    int? lotSize,
    double? latitude,
    double? longitude,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _bedrooms = bedrooms,
        _miniCardPhotos = miniCardPhotos,
        _price = price,
        _livingArea = livingArea,
        _zpid = zpid,
        _bathrooms = bathrooms,
        _lotSize = lotSize,
        _latitude = latitude,
        _longitude = longitude,
        super(firestoreUtilData);

  // "bedrooms" field.
  int? _bedrooms;
  int get bedrooms => _bedrooms ?? 0;
  set bedrooms(int? val) => _bedrooms = val;

  void incrementBedrooms(int amount) => bedrooms = bedrooms + amount;

  bool hasBedrooms() => _bedrooms != null;

  // "miniCardPhotos" field.
  List<MiniCardPhotosStruct>? _miniCardPhotos;
  List<MiniCardPhotosStruct> get miniCardPhotos => _miniCardPhotos ?? const [];
  set miniCardPhotos(List<MiniCardPhotosStruct>? val) => _miniCardPhotos = val;

  void updateMiniCardPhotos(Function(List<MiniCardPhotosStruct>) updateFn) {
    updateFn(_miniCardPhotos ??= []);
  }

  bool hasMiniCardPhotos() => _miniCardPhotos != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  set price(int? val) => _price = val;

  void incrementPrice(int amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "livingArea" field.
  int? _livingArea;
  int get livingArea => _livingArea ?? 0;
  set livingArea(int? val) => _livingArea = val;

  void incrementLivingArea(int amount) => livingArea = livingArea + amount;

  bool hasLivingArea() => _livingArea != null;

  // "zpid" field.
  int? _zpid;
  int get zpid => _zpid ?? 0;
  set zpid(int? val) => _zpid = val;

  void incrementZpid(int amount) => zpid = zpid + amount;

  bool hasZpid() => _zpid != null;

  // "bathrooms" field.
  int? _bathrooms;
  int get bathrooms => _bathrooms ?? 0;
  set bathrooms(int? val) => _bathrooms = val;

  void incrementBathrooms(int amount) => bathrooms = bathrooms + amount;

  bool hasBathrooms() => _bathrooms != null;

  // "lotSize" field.
  int? _lotSize;
  int get lotSize => _lotSize ?? 0;
  set lotSize(int? val) => _lotSize = val;

  void incrementLotSize(int amount) => lotSize = lotSize + amount;

  bool hasLotSize() => _lotSize != null;

  // "latitude" field.
  double? _latitude;
  double get latitude => _latitude ?? 0.0;
  set latitude(double? val) => _latitude = val;

  void incrementLatitude(double amount) => latitude = latitude + amount;

  bool hasLatitude() => _latitude != null;

  // "longitude" field.
  double? _longitude;
  double get longitude => _longitude ?? 0.0;
  set longitude(double? val) => _longitude = val;

  void incrementLongitude(double amount) => longitude = longitude + amount;

  bool hasLongitude() => _longitude != null;

  static CompsStruct fromMap(Map<String, dynamic> data) => CompsStruct(
        bedrooms: castToType<int>(data['bedrooms']),
        miniCardPhotos: getStructList(
          data['miniCardPhotos'],
          MiniCardPhotosStruct.fromMap,
        ),
        price: castToType<int>(data['price']),
        livingArea: castToType<int>(data['livingArea']),
        zpid: castToType<int>(data['zpid']),
        bathrooms: castToType<int>(data['bathrooms']),
        lotSize: castToType<int>(data['lotSize']),
        latitude: castToType<double>(data['latitude']),
        longitude: castToType<double>(data['longitude']),
      );

  static CompsStruct? maybeFromMap(dynamic data) =>
      data is Map ? CompsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'bedrooms': _bedrooms,
        'miniCardPhotos': _miniCardPhotos?.map((e) => e.toMap()).toList(),
        'price': _price,
        'livingArea': _livingArea,
        'zpid': _zpid,
        'bathrooms': _bathrooms,
        'lotSize': _lotSize,
        'latitude': _latitude,
        'longitude': _longitude,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'bedrooms': serializeParam(
          _bedrooms,
          ParamType.int,
        ),
        'miniCardPhotos': serializeParam(
          _miniCardPhotos,
          ParamType.DataStruct,
          isList: true,
        ),
        'price': serializeParam(
          _price,
          ParamType.int,
        ),
        'livingArea': serializeParam(
          _livingArea,
          ParamType.int,
        ),
        'zpid': serializeParam(
          _zpid,
          ParamType.int,
        ),
        'bathrooms': serializeParam(
          _bathrooms,
          ParamType.int,
        ),
        'lotSize': serializeParam(
          _lotSize,
          ParamType.int,
        ),
        'latitude': serializeParam(
          _latitude,
          ParamType.double,
        ),
        'longitude': serializeParam(
          _longitude,
          ParamType.double,
        ),
      }.withoutNulls;

  static CompsStruct fromSerializableMap(Map<String, dynamic> data) =>
      CompsStruct(
        bedrooms: deserializeParam(
          data['bedrooms'],
          ParamType.int,
          false,
        ),
        miniCardPhotos: deserializeStructParam<MiniCardPhotosStruct>(
          data['miniCardPhotos'],
          ParamType.DataStruct,
          true,
          structBuilder: MiniCardPhotosStruct.fromSerializableMap,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.int,
          false,
        ),
        livingArea: deserializeParam(
          data['livingArea'],
          ParamType.int,
          false,
        ),
        zpid: deserializeParam(
          data['zpid'],
          ParamType.int,
          false,
        ),
        bathrooms: deserializeParam(
          data['bathrooms'],
          ParamType.int,
          false,
        ),
        lotSize: deserializeParam(
          data['lotSize'],
          ParamType.int,
          false,
        ),
        latitude: deserializeParam(
          data['latitude'],
          ParamType.double,
          false,
        ),
        longitude: deserializeParam(
          data['longitude'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'CompsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CompsStruct &&
        bedrooms == other.bedrooms &&
        listEquality.equals(miniCardPhotos, other.miniCardPhotos) &&
        price == other.price &&
        livingArea == other.livingArea &&
        zpid == other.zpid &&
        bathrooms == other.bathrooms &&
        lotSize == other.lotSize &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode => const ListEquality().hash([
        bedrooms,
        miniCardPhotos,
        price,
        livingArea,
        zpid,
        bathrooms,
        lotSize,
        latitude,
        longitude
      ]);
}

CompsStruct createCompsStruct({
  int? bedrooms,
  int? price,
  int? livingArea,
  int? zpid,
  int? bathrooms,
  int? lotSize,
  double? latitude,
  double? longitude,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CompsStruct(
      bedrooms: bedrooms,
      price: price,
      livingArea: livingArea,
      zpid: zpid,
      bathrooms: bathrooms,
      lotSize: lotSize,
      latitude: latitude,
      longitude: longitude,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CompsStruct? updateCompsStruct(
  CompsStruct? comps, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    comps
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCompsStructData(
  Map<String, dynamic> firestoreData,
  CompsStruct? comps,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (comps == null) {
    return;
  }
  if (comps.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && comps.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final compsData = getCompsFirestoreData(comps, forFieldValue);
  final nestedData = compsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = comps.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCompsFirestoreData(
  CompsStruct? comps, [
  bool forFieldValue = false,
]) {
  if (comps == null) {
    return {};
  }
  final firestoreData = mapToFirestore(comps.toMap());

  // Add any Firestore field values
  comps.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCompsListFirestoreData(
  List<CompsStruct>? compss,
) =>
    compss?.map((e) => getCompsFirestoreData(e, true)).toList() ?? [];
