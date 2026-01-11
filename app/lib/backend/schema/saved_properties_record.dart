import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SavedPropertiesRecord extends FirestoreRecord {
  SavedPropertiesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "method" field.
  String? _method;
  String get method => _method ?? '';
  bool hasMethod() => _method != null;

  // "impValue" field.
  int? _impValue;
  int get impValue => _impValue ?? 0;
  bool hasImpValue() => _impValue != null;

  // "totalValue" field.
  int? _totalValue;
  int get totalValue => _totalValue ?? 0;
  bool hasTotalValue() => _totalValue != null;

  // "futureValue" field.
  int? _futureValue;
  int get futureValue => _futureValue ?? 0;
  bool hasFutureValue() => _futureValue != null;

  // "downPayment" field.
  int? _downPayment;
  int get downPayment => _downPayment ?? 0;
  bool hasDownPayment() => _downPayment != null;

  // "mortgage" field.
  int? _mortgage;
  int get mortgage => _mortgage ?? 0;
  bool hasMortgage() => _mortgage != null;

  // "sellingCosts" field.
  int? _sellingCosts;
  int get sellingCosts => _sellingCosts ?? 0;
  bool hasSellingCosts() => _sellingCosts != null;

  // "totalCosts" field.
  int? _totalCosts;
  int get totalCosts => _totalCosts ?? 0;
  bool hasTotalCosts() => _totalCosts != null;

  // "grossReturn" field.
  int? _grossReturn;
  int get grossReturn => _grossReturn ?? 0;
  bool hasGrossReturn() => _grossReturn != null;

  // "netReturn" field.
  int? _netReturn;
  int get netReturn => _netReturn ?? 0;
  bool hasNetReturn() => _netReturn != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "imgSrc" field.
  String? _imgSrc;
  String get imgSrc => _imgSrc ?? '';
  bool hasImgSrc() => _imgSrc != null;

  // "latlng" field.
  LatLng? _latlng;
  LatLng? get latlng => _latlng;
  bool hasLatlng() => _latlng != null;

  // "netRoi" field.
  double? _netRoi;
  double get netRoi => _netRoi ?? 0.0;
  bool hasNetRoi() => _netRoi != null;

  // "detailUrl" field.
  String? _detailUrl;
  String get detailUrl => _detailUrl ?? '';
  bool hasDetailUrl() => _detailUrl != null;

  // "bedrooms" field.
  int? _bedrooms;
  int get bedrooms => _bedrooms ?? 0;
  bool hasBedrooms() => _bedrooms != null;

  // "bathrooms" field.
  int? _bathrooms;
  int get bathrooms => _bathrooms ?? 0;
  bool hasBathrooms() => _bathrooms != null;

  // "daysonZillow" field.
  int? _daysonZillow;
  int get daysonZillow => _daysonZillow ?? 0;
  bool hasDaysonZillow() => _daysonZillow != null;

  // "rentZestimate" field.
  int? _rentZestimate;
  int get rentZestimate => _rentZestimate ?? 0;
  bool hasRentZestimate() => _rentZestimate != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "livingArea" field.
  int? _livingArea;
  int get livingArea => _livingArea ?? 0;
  bool hasLivingArea() => _livingArea != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "taxInsRate" field.
  double? _taxInsRate;
  double get taxInsRate => _taxInsRate ?? 0.0;
  bool hasTaxInsRate() => _taxInsRate != null;

  // "permitFees" field.
  int? _permitFees;
  int get permitFees => _permitFees ?? 0;
  bool hasPermitFees() => _permitFees != null;

  // "propertyTaxes" field.
  int? _propertyTaxes;
  int get propertyTaxes => _propertyTaxes ?? 0;
  bool hasPropertyTaxes() => _propertyTaxes != null;

  // "propertyIns" field.
  int? _propertyIns;
  int get propertyIns => _propertyIns ?? 0;
  bool hasPropertyIns() => _propertyIns != null;

  // "loanFees" field.
  int? _loanFees;
  int get loanFees => _loanFees ?? 0;
  bool hasLoanFees() => _loanFees != null;

  // "purchCloseDate" field.
  DateTime? _purchCloseDate;
  DateTime? get purchCloseDate => _purchCloseDate;
  bool hasPurchCloseDate() => _purchCloseDate != null;

  // "saleCloseDate" field.
  DateTime? _saleCloseDate;
  DateTime? get saleCloseDate => _saleCloseDate;
  bool hasSaleCloseDate() => _saleCloseDate != null;

  // "propertyTaxIns" field.
  int? _propertyTaxIns;
  int get propertyTaxIns => _propertyTaxIns ?? 0;
  bool hasPropertyTaxIns() => _propertyTaxIns != null;

  // "cashOnCashReturn" field.
  double? _cashOnCashReturn;
  double get cashOnCashReturn => _cashOnCashReturn ?? 0.0;
  bool hasCashOnCashReturn() => _cashOnCashReturn != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "proposedLivingArea" field.
  int? _proposedLivingArea;
  int get proposedLivingArea => _proposedLivingArea ?? 0;
  bool hasProposedLivingArea() => _proposedLivingArea != null;

  // "futureBeds" field.
  int? _futureBeds;
  int get futureBeds => _futureBeds ?? 0;
  bool hasFutureBeds() => _futureBeds != null;

  // "futureBaths" field.
  int? _futureBaths;
  int get futureBaths => _futureBaths ?? 0;
  bool hasFutureBaths() => _futureBaths != null;

  // "zestimate" field.
  int? _zestimate;
  int get zestimate => _zestimate ?? 0;
  bool hasZestimate() => _zestimate != null;

  // "yearBuilt" field.
  int? _yearBuilt;
  int get yearBuilt => _yearBuilt ?? 0;
  bool hasYearBuilt() => _yearBuilt != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "loanPayments" field.
  int? _loanPayments;
  int get loanPayments => _loanPayments ?? 0;
  bool hasLoanPayments() => _loanPayments != null;

  // "loanAmount" field.
  int? _loanAmount;
  int get loanAmount => _loanAmount ?? 0;
  bool hasLoanAmount() => _loanAmount != null;

  // "cashNeeded" field.
  int? _cashNeeded;
  int get cashNeeded => _cashNeeded ?? 0;
  bool hasCashNeeded() => _cashNeeded != null;

  // "lotAreaValue" field.
  double? _lotAreaValue;
  double get lotAreaValue => _lotAreaValue ?? 0.0;
  bool hasLotAreaValue() => _lotAreaValue != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "futureArea" field.
  int? _futureArea;
  int get futureArea => _futureArea ?? 0;
  bool hasFutureArea() => _futureArea != null;

  // "redfinSoldComps" field.
  List<RedfinHomeDataStruct>? _redfinSoldComps;
  List<RedfinHomeDataStruct> get redfinSoldComps =>
      _redfinSoldComps ?? const [];
  bool hasRedfinSoldComps() => _redfinSoldComps != null;

  // "redfinForSaleComps" field.
  List<RedfinHomeDataStruct>? _redfinForSaleComps;
  List<RedfinHomeDataStruct> get redfinForSaleComps =>
      _redfinForSaleComps ?? const [];
  bool hasRedfinForSaleComps() => _redfinForSaleComps != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "dscr" field.
  double? _dscr;
  double get dscr => _dscr ?? 0.0;
  bool hasDscr() => _dscr != null;

  // "groc" field.
  double? _groc;
  double get groc => _groc ?? 0.0;
  bool hasGroc() => _groc != null;

  // "avgCompTotalValue" field.
  double? _avgCompTotalValue;
  double get avgCompTotalValue => _avgCompTotalValue ?? 0.0;
  bool hasAvgCompTotalValue() => _avgCompTotalValue != null;

  // "calculateBedroomPriceAverages" field.
  int? _calculateBedroomPriceAverages;
  int get calculateBedroomPriceAverages => _calculateBedroomPriceAverages ?? 0;
  bool hasCalculateBedroomPriceAverages() =>
      _calculateBedroomPriceAverages != null;

  // "irr" field.
  double? _irr;
  double get irr => _irr ?? 0.0;
  bool hasIrr() => _irr != null;

  // "compsAvgPricePerBdrm" field.
  double? _compsAvgPricePerBdrm;
  double get compsAvgPricePerBdrm => _compsAvgPricePerBdrm ?? 0.0;
  bool hasCompsAvgPricePerBdrm() => _compsAvgPricePerBdrm != null;

  // "pricePerSqft" field.
  int? _pricePerSqft;

  /// for comps
  int get pricePerSqft => _pricePerSqft ?? 0;
  bool hasPricePerSqft() => _pricePerSqft != null;

  // "roe" field.
  double? _roe;
  double get roe => _roe ?? 0.0;
  bool hasRoe() => _roe != null;

  // "netRetnalIncome5yrs" field.
  int? _netRetnalIncome5yrs;
  int get netRetnalIncome5yrs => _netRetnalIncome5yrs ?? 0;
  bool hasNetRetnalIncome5yrs() => _netRetnalIncome5yrs != null;

  // "notesARV" field.
  String? _notesARV;
  String get notesARV => _notesARV ?? '';
  bool hasNotesARV() => _notesARV != null;

  // "avgCompPrice" field.
  int? _avgCompPrice;
  int get avgCompPrice => _avgCompPrice ?? 0;
  bool hasAvgCompPrice() => _avgCompPrice != null;

  // "totalReturn" field.
  int? _totalReturn;
  int get totalReturn => _totalReturn ?? 0;
  bool hasTotalReturn() => _totalReturn != null;

  void _initializeFields() {
    _method = snapshotData['method'] as String?;
    _impValue = castToType<int>(snapshotData['impValue']);
    _totalValue = castToType<int>(snapshotData['totalValue']);
    _futureValue = castToType<int>(snapshotData['futureValue']);
    _downPayment = castToType<int>(snapshotData['downPayment']);
    _mortgage = castToType<int>(snapshotData['mortgage']);
    _sellingCosts = castToType<int>(snapshotData['sellingCosts']);
    _totalCosts = castToType<int>(snapshotData['totalCosts']);
    _grossReturn = castToType<int>(snapshotData['grossReturn']);
    _netReturn = castToType<int>(snapshotData['netReturn']);
    _address = snapshotData['address'] as String?;
    _imgSrc = snapshotData['imgSrc'] as String?;
    _latlng = snapshotData['latlng'] as LatLng?;
    _netRoi = castToType<double>(snapshotData['netRoi']);
    _detailUrl = snapshotData['detailUrl'] as String?;
    _bedrooms = castToType<int>(snapshotData['bedrooms']);
    _bathrooms = castToType<int>(snapshotData['bathrooms']);
    _daysonZillow = castToType<int>(snapshotData['daysonZillow']);
    _rentZestimate = castToType<int>(snapshotData['rentZestimate']);
    _notes = snapshotData['notes'] as String?;
    _livingArea = castToType<int>(snapshotData['livingArea']);
    _price = castToType<int>(snapshotData['price']);
    _taxInsRate = castToType<double>(snapshotData['taxInsRate']);
    _permitFees = castToType<int>(snapshotData['permitFees']);
    _propertyTaxes = castToType<int>(snapshotData['propertyTaxes']);
    _propertyIns = castToType<int>(snapshotData['propertyIns']);
    _loanFees = castToType<int>(snapshotData['loanFees']);
    _purchCloseDate = snapshotData['purchCloseDate'] as DateTime?;
    _saleCloseDate = snapshotData['saleCloseDate'] as DateTime?;
    _propertyTaxIns = castToType<int>(snapshotData['propertyTaxIns']);
    _cashOnCashReturn = castToType<double>(snapshotData['cashOnCashReturn']);
    _duration = castToType<int>(snapshotData['duration']);
    _proposedLivingArea = castToType<int>(snapshotData['proposedLivingArea']);
    _futureBeds = castToType<int>(snapshotData['futureBeds']);
    _futureBaths = castToType<int>(snapshotData['futureBaths']);
    _zestimate = castToType<int>(snapshotData['zestimate']);
    _yearBuilt = castToType<int>(snapshotData['yearBuilt']);
    _description = snapshotData['description'] as String?;
    _loanPayments = castToType<int>(snapshotData['loanPayments']);
    _loanAmount = castToType<int>(snapshotData['loanAmount']);
    _cashNeeded = castToType<int>(snapshotData['cashNeeded']);
    _lotAreaValue = castToType<double>(snapshotData['lotAreaValue']);
    _id = snapshotData['id'] as String?;
    _futureArea = castToType<int>(snapshotData['futureArea']);
    _redfinSoldComps = getStructList(
      snapshotData['redfinSoldComps'],
      RedfinHomeDataStruct.fromMap,
    );
    _redfinForSaleComps = getStructList(
      snapshotData['redfinForSaleComps'],
      RedfinHomeDataStruct.fromMap,
    );
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _dscr = castToType<double>(snapshotData['dscr']);
    _groc = castToType<double>(snapshotData['groc']);
    _avgCompTotalValue = castToType<double>(snapshotData['avgCompTotalValue']);
    _calculateBedroomPriceAverages =
        castToType<int>(snapshotData['calculateBedroomPriceAverages']);
    _irr = castToType<double>(snapshotData['irr']);
    _compsAvgPricePerBdrm =
        castToType<double>(snapshotData['compsAvgPricePerBdrm']);
    _pricePerSqft = castToType<int>(snapshotData['pricePerSqft']);
    _roe = castToType<double>(snapshotData['roe']);
    _netRetnalIncome5yrs = castToType<int>(snapshotData['netRetnalIncome5yrs']);
    _notesARV = snapshotData['notesARV'] as String?;
    _avgCompPrice = castToType<int>(snapshotData['avgCompPrice']);
    _totalReturn = castToType<int>(snapshotData['totalReturn']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('savedProperties');

  static Stream<SavedPropertiesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SavedPropertiesRecord.fromSnapshot(s));

  static Future<SavedPropertiesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SavedPropertiesRecord.fromSnapshot(s));

  static SavedPropertiesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SavedPropertiesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SavedPropertiesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SavedPropertiesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SavedPropertiesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SavedPropertiesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSavedPropertiesRecordData({
  String? method,
  int? impValue,
  int? totalValue,
  int? futureValue,
  int? downPayment,
  int? mortgage,
  int? sellingCosts,
  int? totalCosts,
  int? grossReturn,
  int? netReturn,
  String? address,
  String? imgSrc,
  LatLng? latlng,
  double? netRoi,
  String? detailUrl,
  int? bedrooms,
  int? bathrooms,
  int? daysonZillow,
  int? rentZestimate,
  String? notes,
  int? livingArea,
  int? price,
  double? taxInsRate,
  int? permitFees,
  int? propertyTaxes,
  int? propertyIns,
  int? loanFees,
  DateTime? purchCloseDate,
  DateTime? saleCloseDate,
  int? propertyTaxIns,
  double? cashOnCashReturn,
  int? duration,
  int? proposedLivingArea,
  int? futureBeds,
  int? futureBaths,
  int? zestimate,
  int? yearBuilt,
  String? description,
  int? loanPayments,
  int? loanAmount,
  int? cashNeeded,
  double? lotAreaValue,
  String? id,
  int? futureArea,
  DocumentReference? userRef,
  double? dscr,
  double? groc,
  double? avgCompTotalValue,
  int? calculateBedroomPriceAverages,
  double? irr,
  double? compsAvgPricePerBdrm,
  int? pricePerSqft,
  double? roe,
  int? netRetnalIncome5yrs,
  String? notesARV,
  int? avgCompPrice,
  int? totalReturn,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'method': method,
      'impValue': impValue,
      'totalValue': totalValue,
      'futureValue': futureValue,
      'downPayment': downPayment,
      'mortgage': mortgage,
      'sellingCosts': sellingCosts,
      'totalCosts': totalCosts,
      'grossReturn': grossReturn,
      'netReturn': netReturn,
      'address': address,
      'imgSrc': imgSrc,
      'latlng': latlng,
      'netRoi': netRoi,
      'detailUrl': detailUrl,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'daysonZillow': daysonZillow,
      'rentZestimate': rentZestimate,
      'notes': notes,
      'livingArea': livingArea,
      'price': price,
      'taxInsRate': taxInsRate,
      'permitFees': permitFees,
      'propertyTaxes': propertyTaxes,
      'propertyIns': propertyIns,
      'loanFees': loanFees,
      'purchCloseDate': purchCloseDate,
      'saleCloseDate': saleCloseDate,
      'propertyTaxIns': propertyTaxIns,
      'cashOnCashReturn': cashOnCashReturn,
      'duration': duration,
      'proposedLivingArea': proposedLivingArea,
      'futureBeds': futureBeds,
      'futureBaths': futureBaths,
      'zestimate': zestimate,
      'yearBuilt': yearBuilt,
      'description': description,
      'loanPayments': loanPayments,
      'loanAmount': loanAmount,
      'cashNeeded': cashNeeded,
      'lotAreaValue': lotAreaValue,
      'id': id,
      'futureArea': futureArea,
      'userRef': userRef,
      'dscr': dscr,
      'groc': groc,
      'avgCompTotalValue': avgCompTotalValue,
      'calculateBedroomPriceAverages': calculateBedroomPriceAverages,
      'irr': irr,
      'compsAvgPricePerBdrm': compsAvgPricePerBdrm,
      'pricePerSqft': pricePerSqft,
      'roe': roe,
      'netRetnalIncome5yrs': netRetnalIncome5yrs,
      'notesARV': notesARV,
      'avgCompPrice': avgCompPrice,
      'totalReturn': totalReturn,
    }.withoutNulls,
  );

  return firestoreData;
}

class SavedPropertiesRecordDocumentEquality
    implements Equality<SavedPropertiesRecord> {
  const SavedPropertiesRecordDocumentEquality();

  @override
  bool equals(SavedPropertiesRecord? e1, SavedPropertiesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.method == e2?.method &&
        e1?.impValue == e2?.impValue &&
        e1?.totalValue == e2?.totalValue &&
        e1?.futureValue == e2?.futureValue &&
        e1?.downPayment == e2?.downPayment &&
        e1?.mortgage == e2?.mortgage &&
        e1?.sellingCosts == e2?.sellingCosts &&
        e1?.totalCosts == e2?.totalCosts &&
        e1?.grossReturn == e2?.grossReturn &&
        e1?.netReturn == e2?.netReturn &&
        e1?.address == e2?.address &&
        e1?.imgSrc == e2?.imgSrc &&
        e1?.latlng == e2?.latlng &&
        e1?.netRoi == e2?.netRoi &&
        e1?.detailUrl == e2?.detailUrl &&
        e1?.bedrooms == e2?.bedrooms &&
        e1?.bathrooms == e2?.bathrooms &&
        e1?.daysonZillow == e2?.daysonZillow &&
        e1?.rentZestimate == e2?.rentZestimate &&
        e1?.notes == e2?.notes &&
        e1?.livingArea == e2?.livingArea &&
        e1?.price == e2?.price &&
        e1?.taxInsRate == e2?.taxInsRate &&
        e1?.permitFees == e2?.permitFees &&
        e1?.propertyTaxes == e2?.propertyTaxes &&
        e1?.propertyIns == e2?.propertyIns &&
        e1?.loanFees == e2?.loanFees &&
        e1?.purchCloseDate == e2?.purchCloseDate &&
        e1?.saleCloseDate == e2?.saleCloseDate &&
        e1?.propertyTaxIns == e2?.propertyTaxIns &&
        e1?.cashOnCashReturn == e2?.cashOnCashReturn &&
        e1?.duration == e2?.duration &&
        e1?.proposedLivingArea == e2?.proposedLivingArea &&
        e1?.futureBeds == e2?.futureBeds &&
        e1?.futureBaths == e2?.futureBaths &&
        e1?.zestimate == e2?.zestimate &&
        e1?.yearBuilt == e2?.yearBuilt &&
        e1?.description == e2?.description &&
        e1?.loanPayments == e2?.loanPayments &&
        e1?.loanAmount == e2?.loanAmount &&
        e1?.cashNeeded == e2?.cashNeeded &&
        e1?.lotAreaValue == e2?.lotAreaValue &&
        e1?.id == e2?.id &&
        e1?.futureArea == e2?.futureArea &&
        listEquality.equals(e1?.redfinSoldComps, e2?.redfinSoldComps) &&
        listEquality.equals(e1?.redfinForSaleComps, e2?.redfinForSaleComps) &&
        e1?.userRef == e2?.userRef &&
        e1?.dscr == e2?.dscr &&
        e1?.groc == e2?.groc &&
        e1?.avgCompTotalValue == e2?.avgCompTotalValue &&
        e1?.calculateBedroomPriceAverages ==
            e2?.calculateBedroomPriceAverages &&
        e1?.irr == e2?.irr &&
        e1?.compsAvgPricePerBdrm == e2?.compsAvgPricePerBdrm &&
        e1?.pricePerSqft == e2?.pricePerSqft &&
        e1?.roe == e2?.roe &&
        e1?.netRetnalIncome5yrs == e2?.netRetnalIncome5yrs &&
        e1?.notesARV == e2?.notesARV &&
        e1?.avgCompPrice == e2?.avgCompPrice &&
        e1?.totalReturn == e2?.totalReturn;
  }

  @override
  int hash(SavedPropertiesRecord? e) => const ListEquality().hash([
        e?.method,
        e?.impValue,
        e?.totalValue,
        e?.futureValue,
        e?.downPayment,
        e?.mortgage,
        e?.sellingCosts,
        e?.totalCosts,
        e?.grossReturn,
        e?.netReturn,
        e?.address,
        e?.imgSrc,
        e?.latlng,
        e?.netRoi,
        e?.detailUrl,
        e?.bedrooms,
        e?.bathrooms,
        e?.daysonZillow,
        e?.rentZestimate,
        e?.notes,
        e?.livingArea,
        e?.price,
        e?.taxInsRate,
        e?.permitFees,
        e?.propertyTaxes,
        e?.propertyIns,
        e?.loanFees,
        e?.purchCloseDate,
        e?.saleCloseDate,
        e?.propertyTaxIns,
        e?.cashOnCashReturn,
        e?.duration,
        e?.proposedLivingArea,
        e?.futureBeds,
        e?.futureBaths,
        e?.zestimate,
        e?.yearBuilt,
        e?.description,
        e?.loanPayments,
        e?.loanAmount,
        e?.cashNeeded,
        e?.lotAreaValue,
        e?.id,
        e?.futureArea,
        e?.redfinSoldComps,
        e?.redfinForSaleComps,
        e?.userRef,
        e?.dscr,
        e?.groc,
        e?.avgCompTotalValue,
        e?.calculateBedroomPriceAverages,
        e?.irr,
        e?.compsAvgPricePerBdrm,
        e?.pricePerSqft,
        e?.roe,
        e?.netRetnalIncome5yrs,
        e?.notesARV,
        e?.avgCompPrice,
        e?.totalReturn
      ]);

  @override
  bool isValidKey(Object? o) => o is SavedPropertiesRecord;
}
