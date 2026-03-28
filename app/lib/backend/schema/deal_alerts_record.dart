import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DealAlertsRecord extends FirestoreRecord {
  DealAlertsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "zpid" field.
  String? _zpid;
  String get zpid => _zpid ?? '';
  bool hasZpid() => _zpid != null;

  // "method" field.
  String? _method;
  String get method => _method ?? '';
  bool hasMethod() => _method != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "netReturn" field.
  int? _netReturn;
  int get netReturn => _netReturn ?? 0;
  bool hasNetReturn() => _netReturn != null;

  // "netROI" field.
  double? _netROI;
  double get netROI => _netROI ?? 0.0;
  bool hasNetROI() => _netROI != null;

  // "cashNeeded" field.
  int? _cashNeeded;
  int get cashNeeded => _cashNeeded ?? 0;
  bool hasCashNeeded() => _cashNeeded != null;

  // "imgSrc" field.
  String? _imgSrc;
  String get imgSrc => _imgSrc ?? '';
  bool hasImgSrc() => _imgSrc != null;

  // "detailUrl" field.
  String? _detailUrl;
  String get detailUrl => _detailUrl ?? '';
  bool hasDetailUrl() => _detailUrl != null;

  // "latlng" field.
  LatLng? _latlng;
  LatLng? get latlng => _latlng;
  bool hasLatlng() => _latlng != null;

  // "bedrooms" field.
  int? _bedrooms;
  int get bedrooms => _bedrooms ?? 0;
  bool hasBedrooms() => _bedrooms != null;

  // "bathrooms" field.
  int? _bathrooms;
  int get bathrooms => _bathrooms ?? 0;
  bool hasBathrooms() => _bathrooms != null;

  // "livingArea" field.
  int? _livingArea;
  int get livingArea => _livingArea ?? 0;
  bool hasLivingArea() => _livingArea != null;

  // "yearBuilt" field.
  int? _yearBuilt;
  int get yearBuilt => _yearBuilt ?? 0;
  bool hasYearBuilt() => _yearBuilt != null;

  // "zestimate" field.
  int? _zestimate;
  int get zestimate => _zestimate ?? 0;
  bool hasZestimate() => _zestimate != null;

  // "scanConfig" field.
  String? _scanConfig;
  String get scanConfig => _scanConfig ?? '';
  bool hasScanConfig() => _scanConfig != null;

  // "scannedAt" field.
  DateTime? _scannedAt;
  DateTime? get scannedAt => _scannedAt;
  bool hasScannedAt() => _scannedAt != null;

  // "totalCosts" field.
  int? _totalCosts;
  int get totalCosts => _totalCosts ?? 0;
  bool hasTotalCosts() => _totalCosts != null;

  // "impValue" field.
  int? _impValue;
  int get impValue => _impValue ?? 0;
  bool hasImpValue() => _impValue != null;

  // "futureValue" field.
  int? _futureValue;
  int get futureValue => _futureValue ?? 0;
  bool hasFutureValue() => _futureValue != null;

  // "downPayment" field.
  int? _downPayment;
  int get downPayment => _downPayment ?? 0;
  bool hasDownPayment() => _downPayment != null;

  // "loanAmount" field.
  int? _loanAmount;
  int get loanAmount => _loanAmount ?? 0;
  bool hasLoanAmount() => _loanAmount != null;

  // "sellingCosts" field.
  int? _sellingCosts;
  int get sellingCosts => _sellingCosts ?? 0;
  bool hasSellingCosts() => _sellingCosts != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "grossReturn" field.
  int? _grossReturn;
  int get grossReturn => _grossReturn ?? 0;
  bool hasGrossReturn() => _grossReturn != null;

  // "mortgage" field.
  int? _mortgage;
  int get mortgage => _mortgage ?? 0;
  bool hasMortgage() => _mortgage != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "lotAreaValue" field.
  double? _lotAreaValue;
  double get lotAreaValue => _lotAreaValue ?? 0.0;
  bool hasLotAreaValue() => _lotAreaValue != null;

  // "status" field — pipeline status: opportunity → reviewing → go | pass
  String? _status;
  String get status => _status ?? 'opportunity';
  bool hasStatus() => _status != null;

  // "statusUpdatedAt" field.
  DateTime? _statusUpdatedAt;
  DateTime? get statusUpdatedAt => _statusUpdatedAt;
  bool hasStatusUpdatedAt() => _statusUpdatedAt != null;

  // "enrichedAt" field.
  DateTime? _enrichedAt;
  DateTime? get enrichedAt => _enrichedAt;
  bool hasEnrichedAt() => _enrichedAt != null;

  // "score" field — lead score from bulk pipeline.
  int? _score;
  int get score => _score ?? 0;
  bool hasScore() => _score != null;

  // "recommendation" field — GO / PASS / REVIEW.
  String? _recommendation;
  String get recommendation => _recommendation ?? '';
  bool hasRecommendation() => _recommendation != null;

  // "score_tier" field — HOT / WARM / COOL / COLD.
  String? _scoreTier;
  String get scoreTier => _scoreTier ?? '';
  bool hasScoreTier() => _scoreTier != null;

  void _initializeFields() {
    _address = snapshotData['address'] as String?;
    _zpid = snapshotData['zpid']?.toString();
    _method = snapshotData['method'] as String?;
    _price = castToType<int>(snapshotData['price']);
    _netReturn = castToType<int>(snapshotData['netReturn']);
    _netROI = castToType<double>(snapshotData['netROI']);
    _cashNeeded = castToType<int>(snapshotData['cashNeeded']);
    _imgSrc = snapshotData['imgSrc'] as String?;
    _detailUrl = snapshotData['detailUrl'] as String?;
    _latlng = snapshotData['latlng'] as LatLng?;
    _bedrooms = castToType<int>(snapshotData['bedrooms']);
    _bathrooms = castToType<int>(snapshotData['bathrooms']);
    _livingArea = castToType<int>(snapshotData['livingArea']);
    _yearBuilt = castToType<int>(snapshotData['yearBuilt']);
    _zestimate = castToType<int>(snapshotData['zestimate']);
    _scanConfig = snapshotData['scanConfig'] as String?;
    _scannedAt = snapshotData['scannedAt'] as DateTime?;
    _totalCosts = castToType<int>(snapshotData['totalCosts']);
    _impValue = castToType<int>(snapshotData['impValue']);
    _futureValue = castToType<int>(snapshotData['futureValue']);
    _downPayment = castToType<int>(snapshotData['downPayment']);
    _loanAmount = castToType<int>(snapshotData['loanAmount']);
    _sellingCosts = castToType<int>(snapshotData['sellingCosts']);
    _description = snapshotData['description'] as String?;
    _grossReturn = castToType<int>(snapshotData['grossReturn']);
    _mortgage = castToType<int>(snapshotData['mortgage']);
    _duration = castToType<int>(snapshotData['duration']);
    _lotAreaValue = castToType<double>(snapshotData['lotAreaValue']);
    _status = snapshotData['status'] as String?;
    _statusUpdatedAt = snapshotData['statusUpdatedAt'] as DateTime?;
    _enrichedAt = snapshotData['enrichedAt'] as DateTime?;
    _score = castToType<int>(snapshotData['score']);
    _recommendation = snapshotData['recommendation'] as String?;
    _scoreTier = snapshotData['score_tier'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('dealAlerts');

  static Stream<DealAlertsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DealAlertsRecord.fromSnapshot(s));

  static Future<DealAlertsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DealAlertsRecord.fromSnapshot(s));

  static DealAlertsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DealAlertsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DealAlertsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DealAlertsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DealAlertsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DealAlertsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}
