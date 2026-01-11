// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropsStruct extends FFFirebaseStruct {
  PropsStruct({
    List<int>? lvgArea,
    List<String>? dateSold,
    List<String>? propType,
    List<int>? lotAreaValue,
    List<String>? address,
    List<String>? priceChange,
    List<int>? zestimate,
    List<String>? imgSrc,
    List<int>? price,
    List<String>? detailUrl,
    List<int>? beds,
    List<String>? contingentListingType,
    List<double>? long,
    List<double>? lat,
    List<String>? listingStatus,
    List<String>? zpid,
    List<int>? rentZestimate,
    List<int>? daysOnZillow,
    List<String>? country,
    List<String>? lotAreaUnit,
    List<bool>? hasImage,
    List<int>? baths,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _lvgArea = lvgArea,
        _dateSold = dateSold,
        _propType = propType,
        _lotAreaValue = lotAreaValue,
        _address = address,
        _priceChange = priceChange,
        _zestimate = zestimate,
        _imgSrc = imgSrc,
        _price = price,
        _detailUrl = detailUrl,
        _beds = beds,
        _contingentListingType = contingentListingType,
        _long = long,
        _lat = lat,
        _listingStatus = listingStatus,
        _zpid = zpid,
        _rentZestimate = rentZestimate,
        _daysOnZillow = daysOnZillow,
        _country = country,
        _lotAreaUnit = lotAreaUnit,
        _hasImage = hasImage,
        _baths = baths,
        super(firestoreUtilData);

  // "lvgArea" field.
  List<int>? _lvgArea;
  List<int> get lvgArea => _lvgArea ?? const [];
  set lvgArea(List<int>? val) => _lvgArea = val;

  void updateLvgArea(Function(List<int>) updateFn) {
    updateFn(_lvgArea ??= []);
  }

  bool hasLvgArea() => _lvgArea != null;

  // "dateSold" field.
  List<String>? _dateSold;
  List<String> get dateSold => _dateSold ?? const [];
  set dateSold(List<String>? val) => _dateSold = val;

  void updateDateSold(Function(List<String>) updateFn) {
    updateFn(_dateSold ??= []);
  }

  bool hasDateSold() => _dateSold != null;

  // "propType" field.
  List<String>? _propType;
  List<String> get propType => _propType ?? const [];
  set propType(List<String>? val) => _propType = val;

  void updatePropType(Function(List<String>) updateFn) {
    updateFn(_propType ??= []);
  }

  bool hasPropType() => _propType != null;

  // "lotAreaValue" field.
  List<int>? _lotAreaValue;
  List<int> get lotAreaValue => _lotAreaValue ?? const [];
  set lotAreaValue(List<int>? val) => _lotAreaValue = val;

  void updateLotAreaValue(Function(List<int>) updateFn) {
    updateFn(_lotAreaValue ??= []);
  }

  bool hasLotAreaValue() => _lotAreaValue != null;

  // "address" field.
  List<String>? _address;
  List<String> get address => _address ?? const [];
  set address(List<String>? val) => _address = val;

  void updateAddress(Function(List<String>) updateFn) {
    updateFn(_address ??= []);
  }

  bool hasAddress() => _address != null;

  // "priceChange" field.
  List<String>? _priceChange;
  List<String> get priceChange => _priceChange ?? const [];
  set priceChange(List<String>? val) => _priceChange = val;

  void updatePriceChange(Function(List<String>) updateFn) {
    updateFn(_priceChange ??= []);
  }

  bool hasPriceChange() => _priceChange != null;

  // "zestimate" field.
  List<int>? _zestimate;
  List<int> get zestimate => _zestimate ?? const [];
  set zestimate(List<int>? val) => _zestimate = val;

  void updateZestimate(Function(List<int>) updateFn) {
    updateFn(_zestimate ??= []);
  }

  bool hasZestimate() => _zestimate != null;

  // "imgSrc" field.
  List<String>? _imgSrc;
  List<String> get imgSrc => _imgSrc ?? const [];
  set imgSrc(List<String>? val) => _imgSrc = val;

  void updateImgSrc(Function(List<String>) updateFn) {
    updateFn(_imgSrc ??= []);
  }

  bool hasImgSrc() => _imgSrc != null;

  // "price" field.
  List<int>? _price;
  List<int> get price => _price ?? const [];
  set price(List<int>? val) => _price = val;

  void updatePrice(Function(List<int>) updateFn) {
    updateFn(_price ??= []);
  }

  bool hasPrice() => _price != null;

  // "detailUrl" field.
  List<String>? _detailUrl;
  List<String> get detailUrl => _detailUrl ?? const [];
  set detailUrl(List<String>? val) => _detailUrl = val;

  void updateDetailUrl(Function(List<String>) updateFn) {
    updateFn(_detailUrl ??= []);
  }

  bool hasDetailUrl() => _detailUrl != null;

  // "beds" field.
  List<int>? _beds;
  List<int> get beds => _beds ?? const [];
  set beds(List<int>? val) => _beds = val;

  void updateBeds(Function(List<int>) updateFn) {
    updateFn(_beds ??= []);
  }

  bool hasBeds() => _beds != null;

  // "contingentListingType" field.
  List<String>? _contingentListingType;
  List<String> get contingentListingType => _contingentListingType ?? const [];
  set contingentListingType(List<String>? val) => _contingentListingType = val;

  void updateContingentListingType(Function(List<String>) updateFn) {
    updateFn(_contingentListingType ??= []);
  }

  bool hasContingentListingType() => _contingentListingType != null;

  // "long" field.
  List<double>? _long;
  List<double> get long => _long ?? const [];
  set long(List<double>? val) => _long = val;

  void updateLong(Function(List<double>) updateFn) {
    updateFn(_long ??= []);
  }

  bool hasLong() => _long != null;

  // "lat" field.
  List<double>? _lat;
  List<double> get lat => _lat ?? const [];
  set lat(List<double>? val) => _lat = val;

  void updateLat(Function(List<double>) updateFn) {
    updateFn(_lat ??= []);
  }

  bool hasLat() => _lat != null;

  // "listingStatus" field.
  List<String>? _listingStatus;
  List<String> get listingStatus => _listingStatus ?? const [];
  set listingStatus(List<String>? val) => _listingStatus = val;

  void updateListingStatus(Function(List<String>) updateFn) {
    updateFn(_listingStatus ??= []);
  }

  bool hasListingStatus() => _listingStatus != null;

  // "zpid" field.
  List<String>? _zpid;
  List<String> get zpid => _zpid ?? const [];
  set zpid(List<String>? val) => _zpid = val;

  void updateZpid(Function(List<String>) updateFn) {
    updateFn(_zpid ??= []);
  }

  bool hasZpid() => _zpid != null;

  // "rentZestimate" field.
  List<int>? _rentZestimate;
  List<int> get rentZestimate => _rentZestimate ?? const [];
  set rentZestimate(List<int>? val) => _rentZestimate = val;

  void updateRentZestimate(Function(List<int>) updateFn) {
    updateFn(_rentZestimate ??= []);
  }

  bool hasRentZestimate() => _rentZestimate != null;

  // "daysOnZillow" field.
  List<int>? _daysOnZillow;
  List<int> get daysOnZillow => _daysOnZillow ?? const [];
  set daysOnZillow(List<int>? val) => _daysOnZillow = val;

  void updateDaysOnZillow(Function(List<int>) updateFn) {
    updateFn(_daysOnZillow ??= []);
  }

  bool hasDaysOnZillow() => _daysOnZillow != null;

  // "country" field.
  List<String>? _country;
  List<String> get country => _country ?? const [];
  set country(List<String>? val) => _country = val;

  void updateCountry(Function(List<String>) updateFn) {
    updateFn(_country ??= []);
  }

  bool hasCountry() => _country != null;

  // "lotAreaUnit" field.
  List<String>? _lotAreaUnit;
  List<String> get lotAreaUnit => _lotAreaUnit ?? const [];
  set lotAreaUnit(List<String>? val) => _lotAreaUnit = val;

  void updateLotAreaUnit(Function(List<String>) updateFn) {
    updateFn(_lotAreaUnit ??= []);
  }

  bool hasLotAreaUnit() => _lotAreaUnit != null;

  // "hasImage" field.
  List<bool>? _hasImage;
  List<bool> get hasImage => _hasImage ?? const [];
  set hasImage(List<bool>? val) => _hasImage = val;

  void updateHasImage(Function(List<bool>) updateFn) {
    updateFn(_hasImage ??= []);
  }

  bool hasHasImage() => _hasImage != null;

  // "baths" field.
  List<int>? _baths;
  List<int> get baths => _baths ?? const [];
  set baths(List<int>? val) => _baths = val;

  void updateBaths(Function(List<int>) updateFn) {
    updateFn(_baths ??= []);
  }

  bool hasBaths() => _baths != null;

  static PropsStruct fromMap(Map<String, dynamic> data) => PropsStruct(
        lvgArea: getDataList(data['lvgArea']),
        dateSold: getDataList(data['dateSold']),
        propType: getDataList(data['propType']),
        lotAreaValue: getDataList(data['lotAreaValue']),
        address: getDataList(data['address']),
        priceChange: getDataList(data['priceChange']),
        zestimate: getDataList(data['zestimate']),
        imgSrc: getDataList(data['imgSrc']),
        price: getDataList(data['price']),
        detailUrl: getDataList(data['detailUrl']),
        beds: getDataList(data['beds']),
        contingentListingType: getDataList(data['contingentListingType']),
        long: getDataList(data['long']),
        lat: getDataList(data['lat']),
        listingStatus: getDataList(data['listingStatus']),
        zpid: getDataList(data['zpid']),
        rentZestimate: getDataList(data['rentZestimate']),
        daysOnZillow: getDataList(data['daysOnZillow']),
        country: getDataList(data['country']),
        lotAreaUnit: getDataList(data['lotAreaUnit']),
        hasImage: getDataList(data['hasImage']),
        baths: getDataList(data['baths']),
      );

  static PropsStruct? maybeFromMap(dynamic data) =>
      data is Map ? PropsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'lvgArea': _lvgArea,
        'dateSold': _dateSold,
        'propType': _propType,
        'lotAreaValue': _lotAreaValue,
        'address': _address,
        'priceChange': _priceChange,
        'zestimate': _zestimate,
        'imgSrc': _imgSrc,
        'price': _price,
        'detailUrl': _detailUrl,
        'beds': _beds,
        'contingentListingType': _contingentListingType,
        'long': _long,
        'lat': _lat,
        'listingStatus': _listingStatus,
        'zpid': _zpid,
        'rentZestimate': _rentZestimate,
        'daysOnZillow': _daysOnZillow,
        'country': _country,
        'lotAreaUnit': _lotAreaUnit,
        'hasImage': _hasImage,
        'baths': _baths,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'lvgArea': serializeParam(
          _lvgArea,
          ParamType.int,
          isList: true,
        ),
        'dateSold': serializeParam(
          _dateSold,
          ParamType.String,
          isList: true,
        ),
        'propType': serializeParam(
          _propType,
          ParamType.String,
          isList: true,
        ),
        'lotAreaValue': serializeParam(
          _lotAreaValue,
          ParamType.int,
          isList: true,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
          isList: true,
        ),
        'priceChange': serializeParam(
          _priceChange,
          ParamType.String,
          isList: true,
        ),
        'zestimate': serializeParam(
          _zestimate,
          ParamType.int,
          isList: true,
        ),
        'imgSrc': serializeParam(
          _imgSrc,
          ParamType.String,
          isList: true,
        ),
        'price': serializeParam(
          _price,
          ParamType.int,
          isList: true,
        ),
        'detailUrl': serializeParam(
          _detailUrl,
          ParamType.String,
          isList: true,
        ),
        'beds': serializeParam(
          _beds,
          ParamType.int,
          isList: true,
        ),
        'contingentListingType': serializeParam(
          _contingentListingType,
          ParamType.String,
          isList: true,
        ),
        'long': serializeParam(
          _long,
          ParamType.double,
          isList: true,
        ),
        'lat': serializeParam(
          _lat,
          ParamType.double,
          isList: true,
        ),
        'listingStatus': serializeParam(
          _listingStatus,
          ParamType.String,
          isList: true,
        ),
        'zpid': serializeParam(
          _zpid,
          ParamType.String,
          isList: true,
        ),
        'rentZestimate': serializeParam(
          _rentZestimate,
          ParamType.int,
          isList: true,
        ),
        'daysOnZillow': serializeParam(
          _daysOnZillow,
          ParamType.int,
          isList: true,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
          isList: true,
        ),
        'lotAreaUnit': serializeParam(
          _lotAreaUnit,
          ParamType.String,
          isList: true,
        ),
        'hasImage': serializeParam(
          _hasImage,
          ParamType.bool,
          isList: true,
        ),
        'baths': serializeParam(
          _baths,
          ParamType.int,
          isList: true,
        ),
      }.withoutNulls;

  static PropsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PropsStruct(
        lvgArea: deserializeParam<int>(
          data['lvgArea'],
          ParamType.int,
          true,
        ),
        dateSold: deserializeParam<String>(
          data['dateSold'],
          ParamType.String,
          true,
        ),
        propType: deserializeParam<String>(
          data['propType'],
          ParamType.String,
          true,
        ),
        lotAreaValue: deserializeParam<int>(
          data['lotAreaValue'],
          ParamType.int,
          true,
        ),
        address: deserializeParam<String>(
          data['address'],
          ParamType.String,
          true,
        ),
        priceChange: deserializeParam<String>(
          data['priceChange'],
          ParamType.String,
          true,
        ),
        zestimate: deserializeParam<int>(
          data['zestimate'],
          ParamType.int,
          true,
        ),
        imgSrc: deserializeParam<String>(
          data['imgSrc'],
          ParamType.String,
          true,
        ),
        price: deserializeParam<int>(
          data['price'],
          ParamType.int,
          true,
        ),
        detailUrl: deserializeParam<String>(
          data['detailUrl'],
          ParamType.String,
          true,
        ),
        beds: deserializeParam<int>(
          data['beds'],
          ParamType.int,
          true,
        ),
        contingentListingType: deserializeParam<String>(
          data['contingentListingType'],
          ParamType.String,
          true,
        ),
        long: deserializeParam<double>(
          data['long'],
          ParamType.double,
          true,
        ),
        lat: deserializeParam<double>(
          data['lat'],
          ParamType.double,
          true,
        ),
        listingStatus: deserializeParam<String>(
          data['listingStatus'],
          ParamType.String,
          true,
        ),
        zpid: deserializeParam<String>(
          data['zpid'],
          ParamType.String,
          true,
        ),
        rentZestimate: deserializeParam<int>(
          data['rentZestimate'],
          ParamType.int,
          true,
        ),
        daysOnZillow: deserializeParam<int>(
          data['daysOnZillow'],
          ParamType.int,
          true,
        ),
        country: deserializeParam<String>(
          data['country'],
          ParamType.String,
          true,
        ),
        lotAreaUnit: deserializeParam<String>(
          data['lotAreaUnit'],
          ParamType.String,
          true,
        ),
        hasImage: deserializeParam<bool>(
          data['hasImage'],
          ParamType.bool,
          true,
        ),
        baths: deserializeParam<int>(
          data['baths'],
          ParamType.int,
          true,
        ),
      );

  @override
  String toString() => 'PropsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PropsStruct &&
        listEquality.equals(lvgArea, other.lvgArea) &&
        listEquality.equals(dateSold, other.dateSold) &&
        listEquality.equals(propType, other.propType) &&
        listEquality.equals(lotAreaValue, other.lotAreaValue) &&
        listEquality.equals(address, other.address) &&
        listEquality.equals(priceChange, other.priceChange) &&
        listEquality.equals(zestimate, other.zestimate) &&
        listEquality.equals(imgSrc, other.imgSrc) &&
        listEquality.equals(price, other.price) &&
        listEquality.equals(detailUrl, other.detailUrl) &&
        listEquality.equals(beds, other.beds) &&
        listEquality.equals(
            contingentListingType, other.contingentListingType) &&
        listEquality.equals(long, other.long) &&
        listEquality.equals(lat, other.lat) &&
        listEquality.equals(listingStatus, other.listingStatus) &&
        listEquality.equals(zpid, other.zpid) &&
        listEquality.equals(rentZestimate, other.rentZestimate) &&
        listEquality.equals(daysOnZillow, other.daysOnZillow) &&
        listEquality.equals(country, other.country) &&
        listEquality.equals(lotAreaUnit, other.lotAreaUnit) &&
        listEquality.equals(hasImage, other.hasImage) &&
        listEquality.equals(baths, other.baths);
  }

  @override
  int get hashCode => const ListEquality().hash([
        lvgArea,
        dateSold,
        propType,
        lotAreaValue,
        address,
        priceChange,
        zestimate,
        imgSrc,
        price,
        detailUrl,
        beds,
        contingentListingType,
        long,
        lat,
        listingStatus,
        zpid,
        rentZestimate,
        daysOnZillow,
        country,
        lotAreaUnit,
        hasImage,
        baths
      ]);
}

PropsStruct createPropsStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PropsStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PropsStruct? updatePropsStruct(
  PropsStruct? props, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    props
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPropsStructData(
  Map<String, dynamic> firestoreData,
  PropsStruct? props,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (props == null) {
    return;
  }
  if (props.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && props.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final propsData = getPropsFirestoreData(props, forFieldValue);
  final nestedData = propsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = props.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPropsFirestoreData(
  PropsStruct? props, [
  bool forFieldValue = false,
]) {
  if (props == null) {
    return {};
  }
  final firestoreData = mapToFirestore(props.toMap());

  // Add any Firestore field values
  props.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPropsListFirestoreData(
  List<PropsStruct>? propss,
) =>
    propss?.map((e) => getPropsFirestoreData(e, true)).toList() ?? [];
