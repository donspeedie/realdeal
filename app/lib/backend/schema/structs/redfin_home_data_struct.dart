// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RedfinHomeDataStruct extends FFFirebaseStruct {
  RedfinHomeDataStruct({
    List<String>? additionalPhotosInfo,
    double? baths,
    int? beds,
    int? businessMarketId,
    String? city,
    String? countryCode,
    int? dataSourceId,
    DomStruct? dom,
    int? fullBaths,
    bool? has3DTour,
    bool? hasInsight,
    bool? hasVideoTour,
    bool? hasVirtualTour,
    bool? hideSalePrice,
    HoaStruct? hoa,
    bool? isHoaFrequencyKnown,
    bool? isHot,
    bool? isNewConstruction,
    bool? isRedfin,
    bool? isShortlisted,
    bool? isViewedListing,
    List<KeyFactsStruct>? keyFacts,
    LatLongStruct? latLong,
    ListingBrokerStruct? listingBroker,
    ListingCoBrokerStruct? listingCoBroker,
    int? listingId,
    String? listingRemarks,
    int? listingType,
    LocationStruct? location,
    LotSizeStruct? lotSize,
    int? marketId,
    MlsIdStruct? mlsId,
    String? mlsStatus,
    int? openHouseEnd,
    String? openHouseEventName,
    int? openHouseStart,
    String? openHouseStartFormatted,
    OriginalTimeOnRedfinStruct? originalTimeOnRedfin,
    int? partialBaths,
    PhotosRedfinStruct? photos,
    PostalCodeStruct? postalCode,
    PriceRedfinStruct? price,
    PricePerSqFtStruct? pricePerSqFt,
    int? primaryPhotoDisplayLevel,
    int? propertyId,
    int? propertyType,
    int? remarksAccessLevel,
    List<SashesStruct>? sashes,
    int? searchStatus,
    SellingBrokerStruct? sellingBroker,
    bool? showAddressOnMap,
    bool? showDatasourceLogo,
    bool? showMlsId,
    int? soldDate,
    SqFtStruct? sqFt,
    String? state,
    double? stories,
    StreetLineStruct? streetLine,
    TimeOnRedfinStruct? timeOnRedfin,
    String? timeZone,
    int? uiPropertyType,
    UnitNumberStruct? unitNumber,
    String? url,
    YearBuiltStruct? yearBuilt,
    String? zip,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _additionalPhotosInfo = additionalPhotosInfo,
        _baths = baths,
        _beds = beds,
        _businessMarketId = businessMarketId,
        _city = city,
        _countryCode = countryCode,
        _dataSourceId = dataSourceId,
        _dom = dom,
        _fullBaths = fullBaths,
        _has3DTour = has3DTour,
        _hasInsight = hasInsight,
        _hasVideoTour = hasVideoTour,
        _hasVirtualTour = hasVirtualTour,
        _hideSalePrice = hideSalePrice,
        _hoa = hoa,
        _isHoaFrequencyKnown = isHoaFrequencyKnown,
        _isHot = isHot,
        _isNewConstruction = isNewConstruction,
        _isRedfin = isRedfin,
        _isShortlisted = isShortlisted,
        _isViewedListing = isViewedListing,
        _keyFacts = keyFacts,
        _latLong = latLong,
        _listingBroker = listingBroker,
        _listingCoBroker = listingCoBroker,
        _listingId = listingId,
        _listingRemarks = listingRemarks,
        _listingType = listingType,
        _location = location,
        _lotSize = lotSize,
        _marketId = marketId,
        _mlsId = mlsId,
        _mlsStatus = mlsStatus,
        _openHouseEnd = openHouseEnd,
        _openHouseEventName = openHouseEventName,
        _openHouseStart = openHouseStart,
        _openHouseStartFormatted = openHouseStartFormatted,
        _originalTimeOnRedfin = originalTimeOnRedfin,
        _partialBaths = partialBaths,
        _photos = photos,
        _postalCode = postalCode,
        _price = price,
        _pricePerSqFt = pricePerSqFt,
        _primaryPhotoDisplayLevel = primaryPhotoDisplayLevel,
        _propertyId = propertyId,
        _propertyType = propertyType,
        _remarksAccessLevel = remarksAccessLevel,
        _sashes = sashes,
        _searchStatus = searchStatus,
        _sellingBroker = sellingBroker,
        _showAddressOnMap = showAddressOnMap,
        _showDatasourceLogo = showDatasourceLogo,
        _showMlsId = showMlsId,
        _soldDate = soldDate,
        _sqFt = sqFt,
        _state = state,
        _stories = stories,
        _streetLine = streetLine,
        _timeOnRedfin = timeOnRedfin,
        _timeZone = timeZone,
        _uiPropertyType = uiPropertyType,
        _unitNumber = unitNumber,
        _url = url,
        _yearBuilt = yearBuilt,
        _zip = zip,
        super(firestoreUtilData);

  // "additionalPhotosInfo" field.
  List<String>? _additionalPhotosInfo;
  List<String> get additionalPhotosInfo => _additionalPhotosInfo ?? const [];
  set additionalPhotosInfo(List<String>? val) => _additionalPhotosInfo = val;

  void updateAdditionalPhotosInfo(Function(List<String>) updateFn) {
    updateFn(_additionalPhotosInfo ??= []);
  }

  bool hasAdditionalPhotosInfo() => _additionalPhotosInfo != null;

  // "baths" field.
  double? _baths;
  double get baths => _baths ?? 0.0;
  set baths(double? val) => _baths = val;

  void incrementBaths(double amount) => baths = baths + amount;

  bool hasBaths() => _baths != null;

  // "beds" field.
  int? _beds;
  int get beds => _beds ?? 0;
  set beds(int? val) => _beds = val;

  void incrementBeds(int amount) => beds = beds + amount;

  bool hasBeds() => _beds != null;

  // "businessMarketId" field.
  int? _businessMarketId;
  int get businessMarketId => _businessMarketId ?? 0;
  set businessMarketId(int? val) => _businessMarketId = val;

  void incrementBusinessMarketId(int amount) =>
      businessMarketId = businessMarketId + amount;

  bool hasBusinessMarketId() => _businessMarketId != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "countryCode" field.
  String? _countryCode;
  String get countryCode => _countryCode ?? '';
  set countryCode(String? val) => _countryCode = val;

  bool hasCountryCode() => _countryCode != null;

  // "dataSourceId" field.
  int? _dataSourceId;
  int get dataSourceId => _dataSourceId ?? 0;
  set dataSourceId(int? val) => _dataSourceId = val;

  void incrementDataSourceId(int amount) =>
      dataSourceId = dataSourceId + amount;

  bool hasDataSourceId() => _dataSourceId != null;

  // "dom" field.
  DomStruct? _dom;
  DomStruct get dom => _dom ?? DomStruct();
  set dom(DomStruct? val) => _dom = val;

  void updateDom(Function(DomStruct) updateFn) {
    updateFn(_dom ??= DomStruct());
  }

  bool hasDom() => _dom != null;

  // "fullBaths" field.
  int? _fullBaths;
  int get fullBaths => _fullBaths ?? 0;
  set fullBaths(int? val) => _fullBaths = val;

  void incrementFullBaths(int amount) => fullBaths = fullBaths + amount;

  bool hasFullBaths() => _fullBaths != null;

  // "has3DTour" field.
  bool? _has3DTour;
  bool get has3DTour => _has3DTour ?? false;
  set has3DTour(bool? val) => _has3DTour = val;

  bool hasHas3DTour() => _has3DTour != null;

  // "hasInsight" field.
  bool? _hasInsight;
  bool get hasInsight => _hasInsight ?? false;
  set hasInsight(bool? val) => _hasInsight = val;

  bool hasHasInsight() => _hasInsight != null;

  // "hasVideoTour" field.
  bool? _hasVideoTour;
  bool get hasVideoTour => _hasVideoTour ?? false;
  set hasVideoTour(bool? val) => _hasVideoTour = val;

  bool hasHasVideoTour() => _hasVideoTour != null;

  // "hasVirtualTour" field.
  bool? _hasVirtualTour;
  bool get hasVirtualTour => _hasVirtualTour ?? false;
  set hasVirtualTour(bool? val) => _hasVirtualTour = val;

  bool hasHasVirtualTour() => _hasVirtualTour != null;

  // "hideSalePrice" field.
  bool? _hideSalePrice;
  bool get hideSalePrice => _hideSalePrice ?? false;
  set hideSalePrice(bool? val) => _hideSalePrice = val;

  bool hasHideSalePrice() => _hideSalePrice != null;

  // "hoa" field.
  HoaStruct? _hoa;
  HoaStruct get hoa => _hoa ?? HoaStruct();
  set hoa(HoaStruct? val) => _hoa = val;

  void updateHoa(Function(HoaStruct) updateFn) {
    updateFn(_hoa ??= HoaStruct());
  }

  bool hasHoa() => _hoa != null;

  // "isHoaFrequencyKnown" field.
  bool? _isHoaFrequencyKnown;
  bool get isHoaFrequencyKnown => _isHoaFrequencyKnown ?? false;
  set isHoaFrequencyKnown(bool? val) => _isHoaFrequencyKnown = val;

  bool hasIsHoaFrequencyKnown() => _isHoaFrequencyKnown != null;

  // "isHot" field.
  bool? _isHot;
  bool get isHot => _isHot ?? false;
  set isHot(bool? val) => _isHot = val;

  bool hasIsHot() => _isHot != null;

  // "isNewConstruction" field.
  bool? _isNewConstruction;
  bool get isNewConstruction => _isNewConstruction ?? false;
  set isNewConstruction(bool? val) => _isNewConstruction = val;

  bool hasIsNewConstruction() => _isNewConstruction != null;

  // "isRedfin" field.
  bool? _isRedfin;
  bool get isRedfin => _isRedfin ?? false;
  set isRedfin(bool? val) => _isRedfin = val;

  bool hasIsRedfin() => _isRedfin != null;

  // "isShortlisted" field.
  bool? _isShortlisted;
  bool get isShortlisted => _isShortlisted ?? false;
  set isShortlisted(bool? val) => _isShortlisted = val;

  bool hasIsShortlisted() => _isShortlisted != null;

  // "isViewedListing" field.
  bool? _isViewedListing;
  bool get isViewedListing => _isViewedListing ?? false;
  set isViewedListing(bool? val) => _isViewedListing = val;

  bool hasIsViewedListing() => _isViewedListing != null;

  // "keyFacts" field.
  List<KeyFactsStruct>? _keyFacts;
  List<KeyFactsStruct> get keyFacts => _keyFacts ?? const [];
  set keyFacts(List<KeyFactsStruct>? val) => _keyFacts = val;

  void updateKeyFacts(Function(List<KeyFactsStruct>) updateFn) {
    updateFn(_keyFacts ??= []);
  }

  bool hasKeyFacts() => _keyFacts != null;

  // "latLong" field.
  LatLongStruct? _latLong;
  LatLongStruct get latLong => _latLong ?? LatLongStruct();
  set latLong(LatLongStruct? val) => _latLong = val;

  void updateLatLong(Function(LatLongStruct) updateFn) {
    updateFn(_latLong ??= LatLongStruct());
  }

  bool hasLatLong() => _latLong != null;

  // "listingBroker" field.
  ListingBrokerStruct? _listingBroker;
  ListingBrokerStruct get listingBroker =>
      _listingBroker ?? ListingBrokerStruct();
  set listingBroker(ListingBrokerStruct? val) => _listingBroker = val;

  void updateListingBroker(Function(ListingBrokerStruct) updateFn) {
    updateFn(_listingBroker ??= ListingBrokerStruct());
  }

  bool hasListingBroker() => _listingBroker != null;

  // "listingCoBroker" field.
  ListingCoBrokerStruct? _listingCoBroker;
  ListingCoBrokerStruct get listingCoBroker =>
      _listingCoBroker ?? ListingCoBrokerStruct();
  set listingCoBroker(ListingCoBrokerStruct? val) => _listingCoBroker = val;

  void updateListingCoBroker(Function(ListingCoBrokerStruct) updateFn) {
    updateFn(_listingCoBroker ??= ListingCoBrokerStruct());
  }

  bool hasListingCoBroker() => _listingCoBroker != null;

  // "listingId" field.
  int? _listingId;
  int get listingId => _listingId ?? 0;
  set listingId(int? val) => _listingId = val;

  void incrementListingId(int amount) => listingId = listingId + amount;

  bool hasListingId() => _listingId != null;

  // "listingRemarks" field.
  String? _listingRemarks;
  String get listingRemarks => _listingRemarks ?? '';
  set listingRemarks(String? val) => _listingRemarks = val;

  bool hasListingRemarks() => _listingRemarks != null;

  // "listingType" field.
  int? _listingType;
  int get listingType => _listingType ?? 0;
  set listingType(int? val) => _listingType = val;

  void incrementListingType(int amount) => listingType = listingType + amount;

  bool hasListingType() => _listingType != null;

  // "location" field.
  LocationStruct? _location;
  LocationStruct get location => _location ?? LocationStruct();
  set location(LocationStruct? val) => _location = val;

  void updateLocation(Function(LocationStruct) updateFn) {
    updateFn(_location ??= LocationStruct());
  }

  bool hasLocation() => _location != null;

  // "lotSize" field.
  LotSizeStruct? _lotSize;
  LotSizeStruct get lotSize => _lotSize ?? LotSizeStruct();
  set lotSize(LotSizeStruct? val) => _lotSize = val;

  void updateLotSize(Function(LotSizeStruct) updateFn) {
    updateFn(_lotSize ??= LotSizeStruct());
  }

  bool hasLotSize() => _lotSize != null;

  // "marketId" field.
  int? _marketId;
  int get marketId => _marketId ?? 0;
  set marketId(int? val) => _marketId = val;

  void incrementMarketId(int amount) => marketId = marketId + amount;

  bool hasMarketId() => _marketId != null;

  // "mlsId" field.
  MlsIdStruct? _mlsId;
  MlsIdStruct get mlsId => _mlsId ?? MlsIdStruct();
  set mlsId(MlsIdStruct? val) => _mlsId = val;

  void updateMlsId(Function(MlsIdStruct) updateFn) {
    updateFn(_mlsId ??= MlsIdStruct());
  }

  bool hasMlsId() => _mlsId != null;

  // "mlsStatus" field.
  String? _mlsStatus;
  String get mlsStatus => _mlsStatus ?? '';
  set mlsStatus(String? val) => _mlsStatus = val;

  bool hasMlsStatus() => _mlsStatus != null;

  // "openHouseEnd" field.
  int? _openHouseEnd;
  int get openHouseEnd => _openHouseEnd ?? 0;
  set openHouseEnd(int? val) => _openHouseEnd = val;

  void incrementOpenHouseEnd(int amount) =>
      openHouseEnd = openHouseEnd + amount;

  bool hasOpenHouseEnd() => _openHouseEnd != null;

  // "openHouseEventName" field.
  String? _openHouseEventName;
  String get openHouseEventName => _openHouseEventName ?? '';
  set openHouseEventName(String? val) => _openHouseEventName = val;

  bool hasOpenHouseEventName() => _openHouseEventName != null;

  // "openHouseStart" field.
  int? _openHouseStart;
  int get openHouseStart => _openHouseStart ?? 0;
  set openHouseStart(int? val) => _openHouseStart = val;

  void incrementOpenHouseStart(int amount) =>
      openHouseStart = openHouseStart + amount;

  bool hasOpenHouseStart() => _openHouseStart != null;

  // "openHouseStartFormatted" field.
  String? _openHouseStartFormatted;
  String get openHouseStartFormatted => _openHouseStartFormatted ?? '';
  set openHouseStartFormatted(String? val) => _openHouseStartFormatted = val;

  bool hasOpenHouseStartFormatted() => _openHouseStartFormatted != null;

  // "originalTimeOnRedfin" field.
  OriginalTimeOnRedfinStruct? _originalTimeOnRedfin;
  OriginalTimeOnRedfinStruct get originalTimeOnRedfin =>
      _originalTimeOnRedfin ?? OriginalTimeOnRedfinStruct();
  set originalTimeOnRedfin(OriginalTimeOnRedfinStruct? val) =>
      _originalTimeOnRedfin = val;

  void updateOriginalTimeOnRedfin(
      Function(OriginalTimeOnRedfinStruct) updateFn) {
    updateFn(_originalTimeOnRedfin ??= OriginalTimeOnRedfinStruct());
  }

  bool hasOriginalTimeOnRedfin() => _originalTimeOnRedfin != null;

  // "partialBaths" field.
  int? _partialBaths;
  int get partialBaths => _partialBaths ?? 0;
  set partialBaths(int? val) => _partialBaths = val;

  void incrementPartialBaths(int amount) =>
      partialBaths = partialBaths + amount;

  bool hasPartialBaths() => _partialBaths != null;

  // "photos" field.
  PhotosRedfinStruct? _photos;
  PhotosRedfinStruct get photos => _photos ?? PhotosRedfinStruct();
  set photos(PhotosRedfinStruct? val) => _photos = val;

  void updatePhotos(Function(PhotosRedfinStruct) updateFn) {
    updateFn(_photos ??= PhotosRedfinStruct());
  }

  bool hasPhotos() => _photos != null;

  // "postalCode" field.
  PostalCodeStruct? _postalCode;
  PostalCodeStruct get postalCode => _postalCode ?? PostalCodeStruct();
  set postalCode(PostalCodeStruct? val) => _postalCode = val;

  void updatePostalCode(Function(PostalCodeStruct) updateFn) {
    updateFn(_postalCode ??= PostalCodeStruct());
  }

  bool hasPostalCode() => _postalCode != null;

  // "price" field.
  PriceRedfinStruct? _price;
  PriceRedfinStruct get price => _price ?? PriceRedfinStruct();
  set price(PriceRedfinStruct? val) => _price = val;

  void updatePrice(Function(PriceRedfinStruct) updateFn) {
    updateFn(_price ??= PriceRedfinStruct());
  }

  bool hasPrice() => _price != null;

  // "pricePerSqFt" field.
  PricePerSqFtStruct? _pricePerSqFt;
  PricePerSqFtStruct get pricePerSqFt => _pricePerSqFt ?? PricePerSqFtStruct();
  set pricePerSqFt(PricePerSqFtStruct? val) => _pricePerSqFt = val;

  void updatePricePerSqFt(Function(PricePerSqFtStruct) updateFn) {
    updateFn(_pricePerSqFt ??= PricePerSqFtStruct());
  }

  bool hasPricePerSqFt() => _pricePerSqFt != null;

  // "primaryPhotoDisplayLevel" field.
  int? _primaryPhotoDisplayLevel;
  int get primaryPhotoDisplayLevel => _primaryPhotoDisplayLevel ?? 0;
  set primaryPhotoDisplayLevel(int? val) => _primaryPhotoDisplayLevel = val;

  void incrementPrimaryPhotoDisplayLevel(int amount) =>
      primaryPhotoDisplayLevel = primaryPhotoDisplayLevel + amount;

  bool hasPrimaryPhotoDisplayLevel() => _primaryPhotoDisplayLevel != null;

  // "propertyId" field.
  int? _propertyId;
  int get propertyId => _propertyId ?? 0;
  set propertyId(int? val) => _propertyId = val;

  void incrementPropertyId(int amount) => propertyId = propertyId + amount;

  bool hasPropertyId() => _propertyId != null;

  // "propertyType" field.
  int? _propertyType;
  int get propertyType => _propertyType ?? 0;
  set propertyType(int? val) => _propertyType = val;

  void incrementPropertyType(int amount) =>
      propertyType = propertyType + amount;

  bool hasPropertyType() => _propertyType != null;

  // "remarksAccessLevel" field.
  int? _remarksAccessLevel;
  int get remarksAccessLevel => _remarksAccessLevel ?? 0;
  set remarksAccessLevel(int? val) => _remarksAccessLevel = val;

  void incrementRemarksAccessLevel(int amount) =>
      remarksAccessLevel = remarksAccessLevel + amount;

  bool hasRemarksAccessLevel() => _remarksAccessLevel != null;

  // "sashes" field.
  List<SashesStruct>? _sashes;
  List<SashesStruct> get sashes => _sashes ?? const [];
  set sashes(List<SashesStruct>? val) => _sashes = val;

  void updateSashes(Function(List<SashesStruct>) updateFn) {
    updateFn(_sashes ??= []);
  }

  bool hasSashes() => _sashes != null;

  // "searchStatus" field.
  int? _searchStatus;
  int get searchStatus => _searchStatus ?? 0;
  set searchStatus(int? val) => _searchStatus = val;

  void incrementSearchStatus(int amount) =>
      searchStatus = searchStatus + amount;

  bool hasSearchStatus() => _searchStatus != null;

  // "sellingBroker" field.
  SellingBrokerStruct? _sellingBroker;
  SellingBrokerStruct get sellingBroker =>
      _sellingBroker ?? SellingBrokerStruct();
  set sellingBroker(SellingBrokerStruct? val) => _sellingBroker = val;

  void updateSellingBroker(Function(SellingBrokerStruct) updateFn) {
    updateFn(_sellingBroker ??= SellingBrokerStruct());
  }

  bool hasSellingBroker() => _sellingBroker != null;

  // "showAddressOnMap" field.
  bool? _showAddressOnMap;
  bool get showAddressOnMap => _showAddressOnMap ?? false;
  set showAddressOnMap(bool? val) => _showAddressOnMap = val;

  bool hasShowAddressOnMap() => _showAddressOnMap != null;

  // "showDatasourceLogo" field.
  bool? _showDatasourceLogo;
  bool get showDatasourceLogo => _showDatasourceLogo ?? false;
  set showDatasourceLogo(bool? val) => _showDatasourceLogo = val;

  bool hasShowDatasourceLogo() => _showDatasourceLogo != null;

  // "showMlsId" field.
  bool? _showMlsId;
  bool get showMlsId => _showMlsId ?? false;
  set showMlsId(bool? val) => _showMlsId = val;

  bool hasShowMlsId() => _showMlsId != null;

  // "soldDate" field.
  int? _soldDate;
  int get soldDate => _soldDate ?? 0;
  set soldDate(int? val) => _soldDate = val;

  void incrementSoldDate(int amount) => soldDate = soldDate + amount;

  bool hasSoldDate() => _soldDate != null;

  // "sqFt" field.
  SqFtStruct? _sqFt;
  SqFtStruct get sqFt => _sqFt ?? SqFtStruct();
  set sqFt(SqFtStruct? val) => _sqFt = val;

  void updateSqFt(Function(SqFtStruct) updateFn) {
    updateFn(_sqFt ??= SqFtStruct());
  }

  bool hasSqFt() => _sqFt != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "stories" field.
  double? _stories;
  double get stories => _stories ?? 0.0;
  set stories(double? val) => _stories = val;

  void incrementStories(double amount) => stories = stories + amount;

  bool hasStories() => _stories != null;

  // "streetLine" field.
  StreetLineStruct? _streetLine;
  StreetLineStruct get streetLine => _streetLine ?? StreetLineStruct();
  set streetLine(StreetLineStruct? val) => _streetLine = val;

  void updateStreetLine(Function(StreetLineStruct) updateFn) {
    updateFn(_streetLine ??= StreetLineStruct());
  }

  bool hasStreetLine() => _streetLine != null;

  // "timeOnRedfin" field.
  TimeOnRedfinStruct? _timeOnRedfin;
  TimeOnRedfinStruct get timeOnRedfin => _timeOnRedfin ?? TimeOnRedfinStruct();
  set timeOnRedfin(TimeOnRedfinStruct? val) => _timeOnRedfin = val;

  void updateTimeOnRedfin(Function(TimeOnRedfinStruct) updateFn) {
    updateFn(_timeOnRedfin ??= TimeOnRedfinStruct());
  }

  bool hasTimeOnRedfin() => _timeOnRedfin != null;

  // "timeZone" field.
  String? _timeZone;
  String get timeZone => _timeZone ?? '';
  set timeZone(String? val) => _timeZone = val;

  bool hasTimeZone() => _timeZone != null;

  // "uiPropertyType" field.
  int? _uiPropertyType;
  int get uiPropertyType => _uiPropertyType ?? 0;
  set uiPropertyType(int? val) => _uiPropertyType = val;

  void incrementUiPropertyType(int amount) =>
      uiPropertyType = uiPropertyType + amount;

  bool hasUiPropertyType() => _uiPropertyType != null;

  // "unitNumber" field.
  UnitNumberStruct? _unitNumber;
  UnitNumberStruct get unitNumber => _unitNumber ?? UnitNumberStruct();
  set unitNumber(UnitNumberStruct? val) => _unitNumber = val;

  void updateUnitNumber(Function(UnitNumberStruct) updateFn) {
    updateFn(_unitNumber ??= UnitNumberStruct());
  }

  bool hasUnitNumber() => _unitNumber != null;

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

  // "yearBuilt" field.
  YearBuiltStruct? _yearBuilt;
  YearBuiltStruct get yearBuilt => _yearBuilt ?? YearBuiltStruct();
  set yearBuilt(YearBuiltStruct? val) => _yearBuilt = val;

  void updateYearBuilt(Function(YearBuiltStruct) updateFn) {
    updateFn(_yearBuilt ??= YearBuiltStruct());
  }

  bool hasYearBuilt() => _yearBuilt != null;

  // "zip" field.
  String? _zip;
  String get zip => _zip ?? '';
  set zip(String? val) => _zip = val;

  bool hasZip() => _zip != null;

  static RedfinHomeDataStruct fromMap(Map<String, dynamic> data) =>
      RedfinHomeDataStruct(
        additionalPhotosInfo: getDataList(data['additionalPhotosInfo']),
        baths: castToType<double>(data['baths']),
        beds: castToType<int>(data['beds']),
        businessMarketId: castToType<int>(data['businessMarketId']),
        city: data['city'] as String?,
        countryCode: data['countryCode'] as String?,
        dataSourceId: castToType<int>(data['dataSourceId']),
        dom: data['dom'] is DomStruct
            ? data['dom']
            : DomStruct.maybeFromMap(data['dom']),
        fullBaths: castToType<int>(data['fullBaths']),
        has3DTour: data['has3DTour'] as bool?,
        hasInsight: data['hasInsight'] as bool?,
        hasVideoTour: data['hasVideoTour'] as bool?,
        hasVirtualTour: data['hasVirtualTour'] as bool?,
        hideSalePrice: data['hideSalePrice'] as bool?,
        hoa: data['hoa'] is HoaStruct
            ? data['hoa']
            : HoaStruct.maybeFromMap(data['hoa']),
        isHoaFrequencyKnown: data['isHoaFrequencyKnown'] as bool?,
        isHot: data['isHot'] as bool?,
        isNewConstruction: data['isNewConstruction'] as bool?,
        isRedfin: data['isRedfin'] as bool?,
        isShortlisted: data['isShortlisted'] as bool?,
        isViewedListing: data['isViewedListing'] as bool?,
        keyFacts: getStructList(
          data['keyFacts'],
          KeyFactsStruct.fromMap,
        ),
        latLong: data['latLong'] is LatLongStruct
            ? data['latLong']
            : LatLongStruct.maybeFromMap(data['latLong']),
        listingBroker: data['listingBroker'] is ListingBrokerStruct
            ? data['listingBroker']
            : ListingBrokerStruct.maybeFromMap(data['listingBroker']),
        listingCoBroker: data['listingCoBroker'] is ListingCoBrokerStruct
            ? data['listingCoBroker']
            : ListingCoBrokerStruct.maybeFromMap(data['listingCoBroker']),
        listingId: castToType<int>(data['listingId']),
        listingRemarks: data['listingRemarks'] as String?,
        listingType: castToType<int>(data['listingType']),
        location: data['location'] is LocationStruct
            ? data['location']
            : LocationStruct.maybeFromMap(data['location']),
        lotSize: data['lotSize'] is LotSizeStruct
            ? data['lotSize']
            : LotSizeStruct.maybeFromMap(data['lotSize']),
        marketId: castToType<int>(data['marketId']),
        mlsId: data['mlsId'] is MlsIdStruct
            ? data['mlsId']
            : MlsIdStruct.maybeFromMap(data['mlsId']),
        mlsStatus: data['mlsStatus'] as String?,
        openHouseEnd: castToType<int>(data['openHouseEnd']),
        openHouseEventName: data['openHouseEventName'] as String?,
        openHouseStart: castToType<int>(data['openHouseStart']),
        openHouseStartFormatted: data['openHouseStartFormatted'] as String?,
        originalTimeOnRedfin:
            data['originalTimeOnRedfin'] is OriginalTimeOnRedfinStruct
                ? data['originalTimeOnRedfin']
                : OriginalTimeOnRedfinStruct.maybeFromMap(
                    data['originalTimeOnRedfin']),
        partialBaths: castToType<int>(data['partialBaths']),
        photos: data['photos'] is PhotosRedfinStruct
            ? data['photos']
            : PhotosRedfinStruct.maybeFromMap(data['photos']),
        postalCode: data['postalCode'] is PostalCodeStruct
            ? data['postalCode']
            : PostalCodeStruct.maybeFromMap(data['postalCode']),
        price: data['price'] is PriceRedfinStruct
            ? data['price']
            : PriceRedfinStruct.maybeFromMap(data['price']),
        pricePerSqFt: data['pricePerSqFt'] is PricePerSqFtStruct
            ? data['pricePerSqFt']
            : PricePerSqFtStruct.maybeFromMap(data['pricePerSqFt']),
        primaryPhotoDisplayLevel:
            castToType<int>(data['primaryPhotoDisplayLevel']),
        propertyId: castToType<int>(data['propertyId']),
        propertyType: castToType<int>(data['propertyType']),
        remarksAccessLevel: castToType<int>(data['remarksAccessLevel']),
        sashes: getStructList(
          data['sashes'],
          SashesStruct.fromMap,
        ),
        searchStatus: castToType<int>(data['searchStatus']),
        sellingBroker: data['sellingBroker'] is SellingBrokerStruct
            ? data['sellingBroker']
            : SellingBrokerStruct.maybeFromMap(data['sellingBroker']),
        showAddressOnMap: data['showAddressOnMap'] as bool?,
        showDatasourceLogo: data['showDatasourceLogo'] as bool?,
        showMlsId: data['showMlsId'] as bool?,
        soldDate: castToType<int>(data['soldDate']),
        sqFt: data['sqFt'] is SqFtStruct
            ? data['sqFt']
            : SqFtStruct.maybeFromMap(data['sqFt']),
        state: data['state'] as String?,
        stories: castToType<double>(data['stories']),
        streetLine: data['streetLine'] is StreetLineStruct
            ? data['streetLine']
            : StreetLineStruct.maybeFromMap(data['streetLine']),
        timeOnRedfin: data['timeOnRedfin'] is TimeOnRedfinStruct
            ? data['timeOnRedfin']
            : TimeOnRedfinStruct.maybeFromMap(data['timeOnRedfin']),
        timeZone: data['timeZone'] as String?,
        uiPropertyType: castToType<int>(data['uiPropertyType']),
        unitNumber: data['unitNumber'] is UnitNumberStruct
            ? data['unitNumber']
            : UnitNumberStruct.maybeFromMap(data['unitNumber']),
        url: data['url'] as String?,
        yearBuilt: data['yearBuilt'] is YearBuiltStruct
            ? data['yearBuilt']
            : YearBuiltStruct.maybeFromMap(data['yearBuilt']),
        zip: data['zip'] as String?,
      );

  static RedfinHomeDataStruct? maybeFromMap(dynamic data) => data is Map
      ? RedfinHomeDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'additionalPhotosInfo': _additionalPhotosInfo,
        'baths': _baths,
        'beds': _beds,
        'businessMarketId': _businessMarketId,
        'city': _city,
        'countryCode': _countryCode,
        'dataSourceId': _dataSourceId,
        'dom': _dom?.toMap(),
        'fullBaths': _fullBaths,
        'has3DTour': _has3DTour,
        'hasInsight': _hasInsight,
        'hasVideoTour': _hasVideoTour,
        'hasVirtualTour': _hasVirtualTour,
        'hideSalePrice': _hideSalePrice,
        'hoa': _hoa?.toMap(),
        'isHoaFrequencyKnown': _isHoaFrequencyKnown,
        'isHot': _isHot,
        'isNewConstruction': _isNewConstruction,
        'isRedfin': _isRedfin,
        'isShortlisted': _isShortlisted,
        'isViewedListing': _isViewedListing,
        'keyFacts': _keyFacts?.map((e) => e.toMap()).toList(),
        'latLong': _latLong?.toMap(),
        'listingBroker': _listingBroker?.toMap(),
        'listingCoBroker': _listingCoBroker?.toMap(),
        'listingId': _listingId,
        'listingRemarks': _listingRemarks,
        'listingType': _listingType,
        'location': _location?.toMap(),
        'lotSize': _lotSize?.toMap(),
        'marketId': _marketId,
        'mlsId': _mlsId?.toMap(),
        'mlsStatus': _mlsStatus,
        'openHouseEnd': _openHouseEnd,
        'openHouseEventName': _openHouseEventName,
        'openHouseStart': _openHouseStart,
        'openHouseStartFormatted': _openHouseStartFormatted,
        'originalTimeOnRedfin': _originalTimeOnRedfin?.toMap(),
        'partialBaths': _partialBaths,
        'photos': _photos?.toMap(),
        'postalCode': _postalCode?.toMap(),
        'price': _price?.toMap(),
        'pricePerSqFt': _pricePerSqFt?.toMap(),
        'primaryPhotoDisplayLevel': _primaryPhotoDisplayLevel,
        'propertyId': _propertyId,
        'propertyType': _propertyType,
        'remarksAccessLevel': _remarksAccessLevel,
        'sashes': _sashes?.map((e) => e.toMap()).toList(),
        'searchStatus': _searchStatus,
        'sellingBroker': _sellingBroker?.toMap(),
        'showAddressOnMap': _showAddressOnMap,
        'showDatasourceLogo': _showDatasourceLogo,
        'showMlsId': _showMlsId,
        'soldDate': _soldDate,
        'sqFt': _sqFt?.toMap(),
        'state': _state,
        'stories': _stories,
        'streetLine': _streetLine?.toMap(),
        'timeOnRedfin': _timeOnRedfin?.toMap(),
        'timeZone': _timeZone,
        'uiPropertyType': _uiPropertyType,
        'unitNumber': _unitNumber?.toMap(),
        'url': _url,
        'yearBuilt': _yearBuilt?.toMap(),
        'zip': _zip,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'additionalPhotosInfo': serializeParam(
          _additionalPhotosInfo,
          ParamType.String,
          isList: true,
        ),
        'baths': serializeParam(
          _baths,
          ParamType.double,
        ),
        'beds': serializeParam(
          _beds,
          ParamType.int,
        ),
        'businessMarketId': serializeParam(
          _businessMarketId,
          ParamType.int,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'countryCode': serializeParam(
          _countryCode,
          ParamType.String,
        ),
        'dataSourceId': serializeParam(
          _dataSourceId,
          ParamType.int,
        ),
        'dom': serializeParam(
          _dom,
          ParamType.DataStruct,
        ),
        'fullBaths': serializeParam(
          _fullBaths,
          ParamType.int,
        ),
        'has3DTour': serializeParam(
          _has3DTour,
          ParamType.bool,
        ),
        'hasInsight': serializeParam(
          _hasInsight,
          ParamType.bool,
        ),
        'hasVideoTour': serializeParam(
          _hasVideoTour,
          ParamType.bool,
        ),
        'hasVirtualTour': serializeParam(
          _hasVirtualTour,
          ParamType.bool,
        ),
        'hideSalePrice': serializeParam(
          _hideSalePrice,
          ParamType.bool,
        ),
        'hoa': serializeParam(
          _hoa,
          ParamType.DataStruct,
        ),
        'isHoaFrequencyKnown': serializeParam(
          _isHoaFrequencyKnown,
          ParamType.bool,
        ),
        'isHot': serializeParam(
          _isHot,
          ParamType.bool,
        ),
        'isNewConstruction': serializeParam(
          _isNewConstruction,
          ParamType.bool,
        ),
        'isRedfin': serializeParam(
          _isRedfin,
          ParamType.bool,
        ),
        'isShortlisted': serializeParam(
          _isShortlisted,
          ParamType.bool,
        ),
        'isViewedListing': serializeParam(
          _isViewedListing,
          ParamType.bool,
        ),
        'keyFacts': serializeParam(
          _keyFacts,
          ParamType.DataStruct,
          isList: true,
        ),
        'latLong': serializeParam(
          _latLong,
          ParamType.DataStruct,
        ),
        'listingBroker': serializeParam(
          _listingBroker,
          ParamType.DataStruct,
        ),
        'listingCoBroker': serializeParam(
          _listingCoBroker,
          ParamType.DataStruct,
        ),
        'listingId': serializeParam(
          _listingId,
          ParamType.int,
        ),
        'listingRemarks': serializeParam(
          _listingRemarks,
          ParamType.String,
        ),
        'listingType': serializeParam(
          _listingType,
          ParamType.int,
        ),
        'location': serializeParam(
          _location,
          ParamType.DataStruct,
        ),
        'lotSize': serializeParam(
          _lotSize,
          ParamType.DataStruct,
        ),
        'marketId': serializeParam(
          _marketId,
          ParamType.int,
        ),
        'mlsId': serializeParam(
          _mlsId,
          ParamType.DataStruct,
        ),
        'mlsStatus': serializeParam(
          _mlsStatus,
          ParamType.String,
        ),
        'openHouseEnd': serializeParam(
          _openHouseEnd,
          ParamType.int,
        ),
        'openHouseEventName': serializeParam(
          _openHouseEventName,
          ParamType.String,
        ),
        'openHouseStart': serializeParam(
          _openHouseStart,
          ParamType.int,
        ),
        'openHouseStartFormatted': serializeParam(
          _openHouseStartFormatted,
          ParamType.String,
        ),
        'originalTimeOnRedfin': serializeParam(
          _originalTimeOnRedfin,
          ParamType.DataStruct,
        ),
        'partialBaths': serializeParam(
          _partialBaths,
          ParamType.int,
        ),
        'photos': serializeParam(
          _photos,
          ParamType.DataStruct,
        ),
        'postalCode': serializeParam(
          _postalCode,
          ParamType.DataStruct,
        ),
        'price': serializeParam(
          _price,
          ParamType.DataStruct,
        ),
        'pricePerSqFt': serializeParam(
          _pricePerSqFt,
          ParamType.DataStruct,
        ),
        'primaryPhotoDisplayLevel': serializeParam(
          _primaryPhotoDisplayLevel,
          ParamType.int,
        ),
        'propertyId': serializeParam(
          _propertyId,
          ParamType.int,
        ),
        'propertyType': serializeParam(
          _propertyType,
          ParamType.int,
        ),
        'remarksAccessLevel': serializeParam(
          _remarksAccessLevel,
          ParamType.int,
        ),
        'sashes': serializeParam(
          _sashes,
          ParamType.DataStruct,
          isList: true,
        ),
        'searchStatus': serializeParam(
          _searchStatus,
          ParamType.int,
        ),
        'sellingBroker': serializeParam(
          _sellingBroker,
          ParamType.DataStruct,
        ),
        'showAddressOnMap': serializeParam(
          _showAddressOnMap,
          ParamType.bool,
        ),
        'showDatasourceLogo': serializeParam(
          _showDatasourceLogo,
          ParamType.bool,
        ),
        'showMlsId': serializeParam(
          _showMlsId,
          ParamType.bool,
        ),
        'soldDate': serializeParam(
          _soldDate,
          ParamType.int,
        ),
        'sqFt': serializeParam(
          _sqFt,
          ParamType.DataStruct,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'stories': serializeParam(
          _stories,
          ParamType.double,
        ),
        'streetLine': serializeParam(
          _streetLine,
          ParamType.DataStruct,
        ),
        'timeOnRedfin': serializeParam(
          _timeOnRedfin,
          ParamType.DataStruct,
        ),
        'timeZone': serializeParam(
          _timeZone,
          ParamType.String,
        ),
        'uiPropertyType': serializeParam(
          _uiPropertyType,
          ParamType.int,
        ),
        'unitNumber': serializeParam(
          _unitNumber,
          ParamType.DataStruct,
        ),
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
        'yearBuilt': serializeParam(
          _yearBuilt,
          ParamType.DataStruct,
        ),
        'zip': serializeParam(
          _zip,
          ParamType.String,
        ),
      }.withoutNulls;

  static RedfinHomeDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      RedfinHomeDataStruct(
        additionalPhotosInfo: deserializeParam<String>(
          data['additionalPhotosInfo'],
          ParamType.String,
          true,
        ),
        baths: deserializeParam(
          data['baths'],
          ParamType.double,
          false,
        ),
        beds: deserializeParam(
          data['beds'],
          ParamType.int,
          false,
        ),
        businessMarketId: deserializeParam(
          data['businessMarketId'],
          ParamType.int,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        countryCode: deserializeParam(
          data['countryCode'],
          ParamType.String,
          false,
        ),
        dataSourceId: deserializeParam(
          data['dataSourceId'],
          ParamType.int,
          false,
        ),
        dom: deserializeStructParam(
          data['dom'],
          ParamType.DataStruct,
          false,
          structBuilder: DomStruct.fromSerializableMap,
        ),
        fullBaths: deserializeParam(
          data['fullBaths'],
          ParamType.int,
          false,
        ),
        has3DTour: deserializeParam(
          data['has3DTour'],
          ParamType.bool,
          false,
        ),
        hasInsight: deserializeParam(
          data['hasInsight'],
          ParamType.bool,
          false,
        ),
        hasVideoTour: deserializeParam(
          data['hasVideoTour'],
          ParamType.bool,
          false,
        ),
        hasVirtualTour: deserializeParam(
          data['hasVirtualTour'],
          ParamType.bool,
          false,
        ),
        hideSalePrice: deserializeParam(
          data['hideSalePrice'],
          ParamType.bool,
          false,
        ),
        hoa: deserializeStructParam(
          data['hoa'],
          ParamType.DataStruct,
          false,
          structBuilder: HoaStruct.fromSerializableMap,
        ),
        isHoaFrequencyKnown: deserializeParam(
          data['isHoaFrequencyKnown'],
          ParamType.bool,
          false,
        ),
        isHot: deserializeParam(
          data['isHot'],
          ParamType.bool,
          false,
        ),
        isNewConstruction: deserializeParam(
          data['isNewConstruction'],
          ParamType.bool,
          false,
        ),
        isRedfin: deserializeParam(
          data['isRedfin'],
          ParamType.bool,
          false,
        ),
        isShortlisted: deserializeParam(
          data['isShortlisted'],
          ParamType.bool,
          false,
        ),
        isViewedListing: deserializeParam(
          data['isViewedListing'],
          ParamType.bool,
          false,
        ),
        keyFacts: deserializeStructParam<KeyFactsStruct>(
          data['keyFacts'],
          ParamType.DataStruct,
          true,
          structBuilder: KeyFactsStruct.fromSerializableMap,
        ),
        latLong: deserializeStructParam(
          data['latLong'],
          ParamType.DataStruct,
          false,
          structBuilder: LatLongStruct.fromSerializableMap,
        ),
        listingBroker: deserializeStructParam(
          data['listingBroker'],
          ParamType.DataStruct,
          false,
          structBuilder: ListingBrokerStruct.fromSerializableMap,
        ),
        listingCoBroker: deserializeStructParam(
          data['listingCoBroker'],
          ParamType.DataStruct,
          false,
          structBuilder: ListingCoBrokerStruct.fromSerializableMap,
        ),
        listingId: deserializeParam(
          data['listingId'],
          ParamType.int,
          false,
        ),
        listingRemarks: deserializeParam(
          data['listingRemarks'],
          ParamType.String,
          false,
        ),
        listingType: deserializeParam(
          data['listingType'],
          ParamType.int,
          false,
        ),
        location: deserializeStructParam(
          data['location'],
          ParamType.DataStruct,
          false,
          structBuilder: LocationStruct.fromSerializableMap,
        ),
        lotSize: deserializeStructParam(
          data['lotSize'],
          ParamType.DataStruct,
          false,
          structBuilder: LotSizeStruct.fromSerializableMap,
        ),
        marketId: deserializeParam(
          data['marketId'],
          ParamType.int,
          false,
        ),
        mlsId: deserializeStructParam(
          data['mlsId'],
          ParamType.DataStruct,
          false,
          structBuilder: MlsIdStruct.fromSerializableMap,
        ),
        mlsStatus: deserializeParam(
          data['mlsStatus'],
          ParamType.String,
          false,
        ),
        openHouseEnd: deserializeParam(
          data['openHouseEnd'],
          ParamType.int,
          false,
        ),
        openHouseEventName: deserializeParam(
          data['openHouseEventName'],
          ParamType.String,
          false,
        ),
        openHouseStart: deserializeParam(
          data['openHouseStart'],
          ParamType.int,
          false,
        ),
        openHouseStartFormatted: deserializeParam(
          data['openHouseStartFormatted'],
          ParamType.String,
          false,
        ),
        originalTimeOnRedfin: deserializeStructParam(
          data['originalTimeOnRedfin'],
          ParamType.DataStruct,
          false,
          structBuilder: OriginalTimeOnRedfinStruct.fromSerializableMap,
        ),
        partialBaths: deserializeParam(
          data['partialBaths'],
          ParamType.int,
          false,
        ),
        photos: deserializeStructParam(
          data['photos'],
          ParamType.DataStruct,
          false,
          structBuilder: PhotosRedfinStruct.fromSerializableMap,
        ),
        postalCode: deserializeStructParam(
          data['postalCode'],
          ParamType.DataStruct,
          false,
          structBuilder: PostalCodeStruct.fromSerializableMap,
        ),
        price: deserializeStructParam(
          data['price'],
          ParamType.DataStruct,
          false,
          structBuilder: PriceRedfinStruct.fromSerializableMap,
        ),
        pricePerSqFt: deserializeStructParam(
          data['pricePerSqFt'],
          ParamType.DataStruct,
          false,
          structBuilder: PricePerSqFtStruct.fromSerializableMap,
        ),
        primaryPhotoDisplayLevel: deserializeParam(
          data['primaryPhotoDisplayLevel'],
          ParamType.int,
          false,
        ),
        propertyId: deserializeParam(
          data['propertyId'],
          ParamType.int,
          false,
        ),
        propertyType: deserializeParam(
          data['propertyType'],
          ParamType.int,
          false,
        ),
        remarksAccessLevel: deserializeParam(
          data['remarksAccessLevel'],
          ParamType.int,
          false,
        ),
        sashes: deserializeStructParam<SashesStruct>(
          data['sashes'],
          ParamType.DataStruct,
          true,
          structBuilder: SashesStruct.fromSerializableMap,
        ),
        searchStatus: deserializeParam(
          data['searchStatus'],
          ParamType.int,
          false,
        ),
        sellingBroker: deserializeStructParam(
          data['sellingBroker'],
          ParamType.DataStruct,
          false,
          structBuilder: SellingBrokerStruct.fromSerializableMap,
        ),
        showAddressOnMap: deserializeParam(
          data['showAddressOnMap'],
          ParamType.bool,
          false,
        ),
        showDatasourceLogo: deserializeParam(
          data['showDatasourceLogo'],
          ParamType.bool,
          false,
        ),
        showMlsId: deserializeParam(
          data['showMlsId'],
          ParamType.bool,
          false,
        ),
        soldDate: deserializeParam(
          data['soldDate'],
          ParamType.int,
          false,
        ),
        sqFt: deserializeStructParam(
          data['sqFt'],
          ParamType.DataStruct,
          false,
          structBuilder: SqFtStruct.fromSerializableMap,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        stories: deserializeParam(
          data['stories'],
          ParamType.double,
          false,
        ),
        streetLine: deserializeStructParam(
          data['streetLine'],
          ParamType.DataStruct,
          false,
          structBuilder: StreetLineStruct.fromSerializableMap,
        ),
        timeOnRedfin: deserializeStructParam(
          data['timeOnRedfin'],
          ParamType.DataStruct,
          false,
          structBuilder: TimeOnRedfinStruct.fromSerializableMap,
        ),
        timeZone: deserializeParam(
          data['timeZone'],
          ParamType.String,
          false,
        ),
        uiPropertyType: deserializeParam(
          data['uiPropertyType'],
          ParamType.int,
          false,
        ),
        unitNumber: deserializeStructParam(
          data['unitNumber'],
          ParamType.DataStruct,
          false,
          structBuilder: UnitNumberStruct.fromSerializableMap,
        ),
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
        yearBuilt: deserializeStructParam(
          data['yearBuilt'],
          ParamType.DataStruct,
          false,
          structBuilder: YearBuiltStruct.fromSerializableMap,
        ),
        zip: deserializeParam(
          data['zip'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RedfinHomeDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RedfinHomeDataStruct &&
        listEquality.equals(additionalPhotosInfo, other.additionalPhotosInfo) &&
        baths == other.baths &&
        beds == other.beds &&
        businessMarketId == other.businessMarketId &&
        city == other.city &&
        countryCode == other.countryCode &&
        dataSourceId == other.dataSourceId &&
        dom == other.dom &&
        fullBaths == other.fullBaths &&
        has3DTour == other.has3DTour &&
        hasInsight == other.hasInsight &&
        hasVideoTour == other.hasVideoTour &&
        hasVirtualTour == other.hasVirtualTour &&
        hideSalePrice == other.hideSalePrice &&
        hoa == other.hoa &&
        isHoaFrequencyKnown == other.isHoaFrequencyKnown &&
        isHot == other.isHot &&
        isNewConstruction == other.isNewConstruction &&
        isRedfin == other.isRedfin &&
        isShortlisted == other.isShortlisted &&
        isViewedListing == other.isViewedListing &&
        listEquality.equals(keyFacts, other.keyFacts) &&
        latLong == other.latLong &&
        listingBroker == other.listingBroker &&
        listingCoBroker == other.listingCoBroker &&
        listingId == other.listingId &&
        listingRemarks == other.listingRemarks &&
        listingType == other.listingType &&
        location == other.location &&
        lotSize == other.lotSize &&
        marketId == other.marketId &&
        mlsId == other.mlsId &&
        mlsStatus == other.mlsStatus &&
        openHouseEnd == other.openHouseEnd &&
        openHouseEventName == other.openHouseEventName &&
        openHouseStart == other.openHouseStart &&
        openHouseStartFormatted == other.openHouseStartFormatted &&
        originalTimeOnRedfin == other.originalTimeOnRedfin &&
        partialBaths == other.partialBaths &&
        photos == other.photos &&
        postalCode == other.postalCode &&
        price == other.price &&
        pricePerSqFt == other.pricePerSqFt &&
        primaryPhotoDisplayLevel == other.primaryPhotoDisplayLevel &&
        propertyId == other.propertyId &&
        propertyType == other.propertyType &&
        remarksAccessLevel == other.remarksAccessLevel &&
        listEquality.equals(sashes, other.sashes) &&
        searchStatus == other.searchStatus &&
        sellingBroker == other.sellingBroker &&
        showAddressOnMap == other.showAddressOnMap &&
        showDatasourceLogo == other.showDatasourceLogo &&
        showMlsId == other.showMlsId &&
        soldDate == other.soldDate &&
        sqFt == other.sqFt &&
        state == other.state &&
        stories == other.stories &&
        streetLine == other.streetLine &&
        timeOnRedfin == other.timeOnRedfin &&
        timeZone == other.timeZone &&
        uiPropertyType == other.uiPropertyType &&
        unitNumber == other.unitNumber &&
        url == other.url &&
        yearBuilt == other.yearBuilt &&
        zip == other.zip;
  }

  @override
  int get hashCode => const ListEquality().hash([
        additionalPhotosInfo,
        baths,
        beds,
        businessMarketId,
        city,
        countryCode,
        dataSourceId,
        dom,
        fullBaths,
        has3DTour,
        hasInsight,
        hasVideoTour,
        hasVirtualTour,
        hideSalePrice,
        hoa,
        isHoaFrequencyKnown,
        isHot,
        isNewConstruction,
        isRedfin,
        isShortlisted,
        isViewedListing,
        keyFacts,
        latLong,
        listingBroker,
        listingCoBroker,
        listingId,
        listingRemarks,
        listingType,
        location,
        lotSize,
        marketId,
        mlsId,
        mlsStatus,
        openHouseEnd,
        openHouseEventName,
        openHouseStart,
        openHouseStartFormatted,
        originalTimeOnRedfin,
        partialBaths,
        photos,
        postalCode,
        price,
        pricePerSqFt,
        primaryPhotoDisplayLevel,
        propertyId,
        propertyType,
        remarksAccessLevel,
        sashes,
        searchStatus,
        sellingBroker,
        showAddressOnMap,
        showDatasourceLogo,
        showMlsId,
        soldDate,
        sqFt,
        state,
        stories,
        streetLine,
        timeOnRedfin,
        timeZone,
        uiPropertyType,
        unitNumber,
        url,
        yearBuilt,
        zip
      ]);
}

RedfinHomeDataStruct createRedfinHomeDataStruct({
  double? baths,
  int? beds,
  int? businessMarketId,
  String? city,
  String? countryCode,
  int? dataSourceId,
  DomStruct? dom,
  int? fullBaths,
  bool? has3DTour,
  bool? hasInsight,
  bool? hasVideoTour,
  bool? hasVirtualTour,
  bool? hideSalePrice,
  HoaStruct? hoa,
  bool? isHoaFrequencyKnown,
  bool? isHot,
  bool? isNewConstruction,
  bool? isRedfin,
  bool? isShortlisted,
  bool? isViewedListing,
  LatLongStruct? latLong,
  ListingBrokerStruct? listingBroker,
  ListingCoBrokerStruct? listingCoBroker,
  int? listingId,
  String? listingRemarks,
  int? listingType,
  LocationStruct? location,
  LotSizeStruct? lotSize,
  int? marketId,
  MlsIdStruct? mlsId,
  String? mlsStatus,
  int? openHouseEnd,
  String? openHouseEventName,
  int? openHouseStart,
  String? openHouseStartFormatted,
  OriginalTimeOnRedfinStruct? originalTimeOnRedfin,
  int? partialBaths,
  PhotosRedfinStruct? photos,
  PostalCodeStruct? postalCode,
  PriceRedfinStruct? price,
  PricePerSqFtStruct? pricePerSqFt,
  int? primaryPhotoDisplayLevel,
  int? propertyId,
  int? propertyType,
  int? remarksAccessLevel,
  int? searchStatus,
  SellingBrokerStruct? sellingBroker,
  bool? showAddressOnMap,
  bool? showDatasourceLogo,
  bool? showMlsId,
  int? soldDate,
  SqFtStruct? sqFt,
  String? state,
  double? stories,
  StreetLineStruct? streetLine,
  TimeOnRedfinStruct? timeOnRedfin,
  String? timeZone,
  int? uiPropertyType,
  UnitNumberStruct? unitNumber,
  String? url,
  YearBuiltStruct? yearBuilt,
  String? zip,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RedfinHomeDataStruct(
      baths: baths,
      beds: beds,
      businessMarketId: businessMarketId,
      city: city,
      countryCode: countryCode,
      dataSourceId: dataSourceId,
      dom: dom ?? (clearUnsetFields ? DomStruct() : null),
      fullBaths: fullBaths,
      has3DTour: has3DTour,
      hasInsight: hasInsight,
      hasVideoTour: hasVideoTour,
      hasVirtualTour: hasVirtualTour,
      hideSalePrice: hideSalePrice,
      hoa: hoa ?? (clearUnsetFields ? HoaStruct() : null),
      isHoaFrequencyKnown: isHoaFrequencyKnown,
      isHot: isHot,
      isNewConstruction: isNewConstruction,
      isRedfin: isRedfin,
      isShortlisted: isShortlisted,
      isViewedListing: isViewedListing,
      latLong: latLong ?? (clearUnsetFields ? LatLongStruct() : null),
      listingBroker:
          listingBroker ?? (clearUnsetFields ? ListingBrokerStruct() : null),
      listingCoBroker: listingCoBroker ??
          (clearUnsetFields ? ListingCoBrokerStruct() : null),
      listingId: listingId,
      listingRemarks: listingRemarks,
      listingType: listingType,
      location: location ?? (clearUnsetFields ? LocationStruct() : null),
      lotSize: lotSize ?? (clearUnsetFields ? LotSizeStruct() : null),
      marketId: marketId,
      mlsId: mlsId ?? (clearUnsetFields ? MlsIdStruct() : null),
      mlsStatus: mlsStatus,
      openHouseEnd: openHouseEnd,
      openHouseEventName: openHouseEventName,
      openHouseStart: openHouseStart,
      openHouseStartFormatted: openHouseStartFormatted,
      originalTimeOnRedfin: originalTimeOnRedfin ??
          (clearUnsetFields ? OriginalTimeOnRedfinStruct() : null),
      partialBaths: partialBaths,
      photos: photos ?? (clearUnsetFields ? PhotosRedfinStruct() : null),
      postalCode: postalCode ?? (clearUnsetFields ? PostalCodeStruct() : null),
      price: price ?? (clearUnsetFields ? PriceRedfinStruct() : null),
      pricePerSqFt:
          pricePerSqFt ?? (clearUnsetFields ? PricePerSqFtStruct() : null),
      primaryPhotoDisplayLevel: primaryPhotoDisplayLevel,
      propertyId: propertyId,
      propertyType: propertyType,
      remarksAccessLevel: remarksAccessLevel,
      searchStatus: searchStatus,
      sellingBroker:
          sellingBroker ?? (clearUnsetFields ? SellingBrokerStruct() : null),
      showAddressOnMap: showAddressOnMap,
      showDatasourceLogo: showDatasourceLogo,
      showMlsId: showMlsId,
      soldDate: soldDate,
      sqFt: sqFt ?? (clearUnsetFields ? SqFtStruct() : null),
      state: state,
      stories: stories,
      streetLine: streetLine ?? (clearUnsetFields ? StreetLineStruct() : null),
      timeOnRedfin:
          timeOnRedfin ?? (clearUnsetFields ? TimeOnRedfinStruct() : null),
      timeZone: timeZone,
      uiPropertyType: uiPropertyType,
      unitNumber: unitNumber ?? (clearUnsetFields ? UnitNumberStruct() : null),
      url: url,
      yearBuilt: yearBuilt ?? (clearUnsetFields ? YearBuiltStruct() : null),
      zip: zip,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RedfinHomeDataStruct? updateRedfinHomeDataStruct(
  RedfinHomeDataStruct? redfinHomeData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    redfinHomeData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRedfinHomeDataStructData(
  Map<String, dynamic> firestoreData,
  RedfinHomeDataStruct? redfinHomeData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (redfinHomeData == null) {
    return;
  }
  if (redfinHomeData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && redfinHomeData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final redfinHomeDataData =
      getRedfinHomeDataFirestoreData(redfinHomeData, forFieldValue);
  final nestedData =
      redfinHomeDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = redfinHomeData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRedfinHomeDataFirestoreData(
  RedfinHomeDataStruct? redfinHomeData, [
  bool forFieldValue = false,
]) {
  if (redfinHomeData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(redfinHomeData.toMap());

  // Handle nested data for "dom" field.
  addDomStructData(
    firestoreData,
    redfinHomeData.hasDom() ? redfinHomeData.dom : null,
    'dom',
    forFieldValue,
  );

  // Handle nested data for "hoa" field.
  addHoaStructData(
    firestoreData,
    redfinHomeData.hasHoa() ? redfinHomeData.hoa : null,
    'hoa',
    forFieldValue,
  );

  // Handle nested data for "latLong" field.
  addLatLongStructData(
    firestoreData,
    redfinHomeData.hasLatLong() ? redfinHomeData.latLong : null,
    'latLong',
    forFieldValue,
  );

  // Handle nested data for "listingBroker" field.
  addListingBrokerStructData(
    firestoreData,
    redfinHomeData.hasListingBroker() ? redfinHomeData.listingBroker : null,
    'listingBroker',
    forFieldValue,
  );

  // Handle nested data for "listingCoBroker" field.
  addListingCoBrokerStructData(
    firestoreData,
    redfinHomeData.hasListingCoBroker() ? redfinHomeData.listingCoBroker : null,
    'listingCoBroker',
    forFieldValue,
  );

  // Handle nested data for "location" field.
  addLocationStructData(
    firestoreData,
    redfinHomeData.hasLocation() ? redfinHomeData.location : null,
    'location',
    forFieldValue,
  );

  // Handle nested data for "lotSize" field.
  addLotSizeStructData(
    firestoreData,
    redfinHomeData.hasLotSize() ? redfinHomeData.lotSize : null,
    'lotSize',
    forFieldValue,
  );

  // Handle nested data for "mlsId" field.
  addMlsIdStructData(
    firestoreData,
    redfinHomeData.hasMlsId() ? redfinHomeData.mlsId : null,
    'mlsId',
    forFieldValue,
  );

  // Handle nested data for "originalTimeOnRedfin" field.
  addOriginalTimeOnRedfinStructData(
    firestoreData,
    redfinHomeData.hasOriginalTimeOnRedfin()
        ? redfinHomeData.originalTimeOnRedfin
        : null,
    'originalTimeOnRedfin',
    forFieldValue,
  );

  // Handle nested data for "photos" field.
  addPhotosRedfinStructData(
    firestoreData,
    redfinHomeData.hasPhotos() ? redfinHomeData.photos : null,
    'photos',
    forFieldValue,
  );

  // Handle nested data for "postalCode" field.
  addPostalCodeStructData(
    firestoreData,
    redfinHomeData.hasPostalCode() ? redfinHomeData.postalCode : null,
    'postalCode',
    forFieldValue,
  );

  // Handle nested data for "price" field.
  addPriceRedfinStructData(
    firestoreData,
    redfinHomeData.hasPrice() ? redfinHomeData.price : null,
    'price',
    forFieldValue,
  );

  // Handle nested data for "pricePerSqFt" field.
  addPricePerSqFtStructData(
    firestoreData,
    redfinHomeData.hasPricePerSqFt() ? redfinHomeData.pricePerSqFt : null,
    'pricePerSqFt',
    forFieldValue,
  );

  // Handle nested data for "sellingBroker" field.
  addSellingBrokerStructData(
    firestoreData,
    redfinHomeData.hasSellingBroker() ? redfinHomeData.sellingBroker : null,
    'sellingBroker',
    forFieldValue,
  );

  // Handle nested data for "sqFt" field.
  addSqFtStructData(
    firestoreData,
    redfinHomeData.hasSqFt() ? redfinHomeData.sqFt : null,
    'sqFt',
    forFieldValue,
  );

  // Handle nested data for "streetLine" field.
  addStreetLineStructData(
    firestoreData,
    redfinHomeData.hasStreetLine() ? redfinHomeData.streetLine : null,
    'streetLine',
    forFieldValue,
  );

  // Handle nested data for "timeOnRedfin" field.
  addTimeOnRedfinStructData(
    firestoreData,
    redfinHomeData.hasTimeOnRedfin() ? redfinHomeData.timeOnRedfin : null,
    'timeOnRedfin',
    forFieldValue,
  );

  // Handle nested data for "unitNumber" field.
  addUnitNumberStructData(
    firestoreData,
    redfinHomeData.hasUnitNumber() ? redfinHomeData.unitNumber : null,
    'unitNumber',
    forFieldValue,
  );

  // Handle nested data for "yearBuilt" field.
  addYearBuiltStructData(
    firestoreData,
    redfinHomeData.hasYearBuilt() ? redfinHomeData.yearBuilt : null,
    'yearBuilt',
    forFieldValue,
  );

  // Add any Firestore field values
  redfinHomeData.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRedfinHomeDataListFirestoreData(
  List<RedfinHomeDataStruct>? redfinHomeDatas,
) =>
    redfinHomeDatas
        ?.map((e) => getRedfinHomeDataFirestoreData(e, true))
        .toList() ??
    [];
