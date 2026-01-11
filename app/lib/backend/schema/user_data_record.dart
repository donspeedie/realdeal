import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserDataRecord extends FirestoreRecord {
  UserDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "gImptRate" field.
  int? _gImptRate;
  int get gImptRate => _gImptRate ?? 0;
  bool hasGImptRate() => _gImptRate != null;

  // "aduImpRate" field.
  int? _aduImpRate;
  int get aduImpRate => _aduImpRate ?? 0;
  bool hasAduImpRate() => _aduImpRate != null;

  // "newBuildRate" field.
  int? _newBuildRate;
  int get newBuildRate => _newBuildRate ?? 0;
  bool hasNewBuildRate() => _newBuildRate != null;

  // "financingRate" field.
  double? _financingRate;
  double get financingRate => _financingRate ?? 0.0;
  bool hasFinancingRate() => _financingRate != null;

  // "mtgRate" field.
  double? _mtgRate;
  double get mtgRate => _mtgRate ?? 0.0;
  bool hasMtgRate() => _mtgRate != null;

  // "fnfImpRate" field.
  int? _fnfImpRate;
  int get fnfImpRate => _fnfImpRate ?? 0;
  bool hasFnfImpRate() => _fnfImpRate != null;

  // "dwnPmtRate" field.
  double? _dwnPmtRate;
  double get dwnPmtRate => _dwnPmtRate ?? 0.0;
  bool hasDwnPmtRate() => _dwnPmtRate != null;

  // "fnfImpFactor" field.
  double? _fnfImpFactor;
  double get fnfImpFactor => _fnfImpFactor ?? 0.0;
  bool hasFnfImpFactor() => _fnfImpFactor != null;

  // "taxInsRate" field.
  double? _taxInsRate;
  double get taxInsRate => _taxInsRate ?? 0.0;
  bool hasTaxInsRate() => _taxInsRate != null;

  // "salRate" field.
  double? _salRate;
  double get salRate => _salRate ?? 0.0;
  bool hasSalRate() => _salRate != null;

  // "twoBedAvgValue" field.
  int? _twoBedAvgValue;
  int get twoBedAvgValue => _twoBedAvgValue ?? 0;
  bool hasTwoBedAvgValue() => _twoBedAvgValue != null;

  // "newFutValSalperSFRate" field.
  int? _newFutValSalperSFRate;
  int get newFutValSalperSFRate => _newFutValSalperSFRate ?? 0;
  bool hasNewFutValSalperSFRate() => _newFutValSalperSFRate != null;

  // "oneBdrmMarketValue" field.
  int? _oneBdrmMarketValue;
  int get oneBdrmMarketValue => _oneBdrmMarketValue ?? 0;
  bool hasOneBdrmMarketValue() => _oneBdrmMarketValue != null;

  // "aduImpFactor" field.
  double? _aduImpFactor;
  double get aduImpFactor => _aduImpFactor ?? 0.0;
  bool hasAduImpFactor() => _aduImpFactor != null;

  // "aduOneBdrmCost" field.
  int? _aduOneBdrmCost;
  int get aduOneBdrmCost => _aduOneBdrmCost ?? 0;
  bool hasAduOneBdrmCost() => _aduOneBdrmCost != null;

  // "aduTwoBdrmCost" field.
  int? _aduTwoBdrmCost;
  int get aduTwoBdrmCost => _aduTwoBdrmCost ?? 0;
  bool hasAduTwoBdrmCost() => _aduTwoBdrmCost != null;

  // "newImpFactor" field.
  double? _newImpFactor;
  double get newImpFactor => _newImpFactor ?? 0.0;
  bool hasNewImpFactor() => _newImpFactor != null;

  // "propertyIns" field.
  int? _propertyIns;
  int get propertyIns => _propertyIns ?? 0;
  bool hasPropertyIns() => _propertyIns != null;

  // "propertyTaxes" field.
  int? _propertyTaxes;
  int get propertyTaxes => _propertyTaxes ?? 0;
  bool hasPropertyTaxes() => _propertyTaxes != null;

  // "permitsFees" field.
  int? _permitsFees;
  int get permitsFees => _permitsFees ?? 0;
  bool hasPermitsFees() => _permitsFees != null;

  // "fixnflipDuration" field.
  int? _fixnflipDuration;
  int get fixnflipDuration => _fixnflipDuration ?? 0;
  bool hasFixnflipDuration() => _fixnflipDuration != null;

  // "aduDuration" field.
  int? _aduDuration;
  int get aduDuration => _aduDuration ?? 0;
  bool hasAduDuration() => _aduDuration != null;

  // "newDuration" field.
  int? _newDuration;
  int get newDuration => _newDuration ?? 0;
  bool hasNewDuration() => _newDuration != null;

  // "loanFeesRate" field.
  double? _loanFeesRate;
  double get loanFeesRate => _loanFeesRate ?? 0.0;
  bool hasLoanFeesRate() => _loanFeesRate != null;

  // "vacanyRate" field.
  double? _vacanyRate;
  double get vacanyRate => _vacanyRate ?? 0.0;
  bool hasVacanyRate() => _vacanyRate != null;

  // "propertyManagementFeeRate" field.
  double? _propertyManagementFeeRate;
  double get propertyManagementFeeRate => _propertyManagementFeeRate ?? 0.0;
  bool hasPropertyManagementFeeRate() => _propertyManagementFeeRate != null;

  // "utilities" field.
  int? _utilities;
  int get utilities => _utilities ?? 0;
  bool hasUtilities() => _utilities != null;

  // "addOnImpValue" field.
  int? _addOnImpValue;
  int get addOnImpValue => _addOnImpValue ?? 0;
  bool hasAddOnImpValue() => _addOnImpValue != null;

  // "addOnImpFactor" field.
  double? _addOnImpFactor;
  double get addOnImpFactor => _addOnImpFactor ?? 0.0;
  bool hasAddOnImpFactor() => _addOnImpFactor != null;

  // "addOnSqftRate" field.
  int? _addOnSqftRate;
  int get addOnSqftRate => _addOnSqftRate ?? 0;
  bool hasAddOnSqftRate() => _addOnSqftRate != null;

  // "addOnArea" field.
  int? _addOnArea;
  int get addOnArea => _addOnArea ?? 0;
  bool hasAddOnArea() => _addOnArea != null;

  // "aduArea" field.
  int? _aduArea;
  int get aduArea => _aduArea ?? 0;
  bool hasAduArea() => _aduArea != null;

  // "addOnBeds" field.
  int? _addOnBeds;
  int get addOnBeds => _addOnBeds ?? 0;
  bool hasAddOnBeds() => _addOnBeds != null;

  // "addOnBaths" field.
  int? _addOnBaths;
  int get addOnBaths => _addOnBaths ?? 0;
  bool hasAddOnBaths() => _addOnBaths != null;

  // "aduBeds" field.
  int? _aduBeds;
  int get aduBeds => _aduBeds ?? 0;
  bool hasAduBeds() => _aduBeds != null;

  // "aduBaths" field.
  int? _aduBaths;
  int get aduBaths => _aduBaths ?? 0;
  bool hasAduBaths() => _aduBaths != null;

  // "newBeds" field.
  int? _newBeds;
  int get newBeds => _newBeds ?? 0;
  bool hasNewBeds() => _newBeds != null;

  // "newBaths" field.
  int? _newBaths;
  int get newBaths => _newBaths ?? 0;
  bool hasNewBaths() => _newBaths != null;

  // "newArea" field.
  int? _newArea;
  int get newArea => _newArea ?? 0;
  bool hasNewArea() => _newArea != null;

  // "addOnDuration" field.
  int? _addOnDuration;
  int get addOnDuration => _addOnDuration ?? 0;
  bool hasAddOnDuration() => _addOnDuration != null;

  // "maintenanceRate" field.
  int? _maintenanceRate;
  int get maintenanceRate => _maintenanceRate ?? 0;
  bool hasMaintenanceRate() => _maintenanceRate != null;

  // "operatingExpenseRate" field.
  int? _operatingExpenseRate;
  int get operatingExpenseRate => _operatingExpenseRate ?? 0;
  bool hasOperatingExpenseRate() => _operatingExpenseRate != null;

  // "additionalRentalIncome" field.
  int? _additionalRentalIncome;
  int get additionalRentalIncome => _additionalRentalIncome ?? 0;
  bool hasAdditionalRentalIncome() => _additionalRentalIncome != null;

  // "tokens" field.
  int? _tokens;
  int get tokens => _tokens ?? 0;
  bool hasTokens() => _tokens != null;

  // "stripeCustomerId" field.
  String? _stripeCustomerId;
  String get stripeCustomerId => _stripeCustomerId ?? '';
  bool hasStripeCustomerId() => _stripeCustomerId != null;

  // "minimumReturn" field.
  int? _minimumReturn;
  int get minimumReturn => _minimumReturn ?? 0;
  bool hasMinimumReturn() => _minimumReturn != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _gImptRate = castToType<int>(snapshotData['gImptRate']);
    _aduImpRate = castToType<int>(snapshotData['aduImpRate']);
    _newBuildRate = castToType<int>(snapshotData['newBuildRate']);
    _financingRate = castToType<double>(snapshotData['financingRate']);
    _mtgRate = castToType<double>(snapshotData['mtgRate']);
    _fnfImpRate = castToType<int>(snapshotData['fnfImpRate']);
    _dwnPmtRate = castToType<double>(snapshotData['dwnPmtRate']);
    _fnfImpFactor = castToType<double>(snapshotData['fnfImpFactor']);
    _taxInsRate = castToType<double>(snapshotData['taxInsRate']);
    _salRate = castToType<double>(snapshotData['salRate']);
    _twoBedAvgValue = castToType<int>(snapshotData['twoBedAvgValue']);
    _newFutValSalperSFRate =
        castToType<int>(snapshotData['newFutValSalperSFRate']);
    _oneBdrmMarketValue = castToType<int>(snapshotData['oneBdrmMarketValue']);
    _aduImpFactor = castToType<double>(snapshotData['aduImpFactor']);
    _aduOneBdrmCost = castToType<int>(snapshotData['aduOneBdrmCost']);
    _aduTwoBdrmCost = castToType<int>(snapshotData['aduTwoBdrmCost']);
    _newImpFactor = castToType<double>(snapshotData['newImpFactor']);
    _propertyIns = castToType<int>(snapshotData['propertyIns']);
    _propertyTaxes = castToType<int>(snapshotData['propertyTaxes']);
    _permitsFees = castToType<int>(snapshotData['permitsFees']);
    _fixnflipDuration = castToType<int>(snapshotData['fixnflipDuration']);
    _aduDuration = castToType<int>(snapshotData['aduDuration']);
    _newDuration = castToType<int>(snapshotData['newDuration']);
    _loanFeesRate = castToType<double>(snapshotData['loanFeesRate']);
    _vacanyRate = castToType<double>(snapshotData['vacanyRate']);
    _propertyManagementFeeRate =
        castToType<double>(snapshotData['propertyManagementFeeRate']);
    _utilities = castToType<int>(snapshotData['utilities']);
    _addOnImpValue = castToType<int>(snapshotData['addOnImpValue']);
    _addOnImpFactor = castToType<double>(snapshotData['addOnImpFactor']);
    _addOnSqftRate = castToType<int>(snapshotData['addOnSqftRate']);
    _addOnArea = castToType<int>(snapshotData['addOnArea']);
    _aduArea = castToType<int>(snapshotData['aduArea']);
    _addOnBeds = castToType<int>(snapshotData['addOnBeds']);
    _addOnBaths = castToType<int>(snapshotData['addOnBaths']);
    _aduBeds = castToType<int>(snapshotData['aduBeds']);
    _aduBaths = castToType<int>(snapshotData['aduBaths']);
    _newBeds = castToType<int>(snapshotData['newBeds']);
    _newBaths = castToType<int>(snapshotData['newBaths']);
    _newArea = castToType<int>(snapshotData['newArea']);
    _addOnDuration = castToType<int>(snapshotData['addOnDuration']);
    _maintenanceRate = castToType<int>(snapshotData['maintenanceRate']);
    _operatingExpenseRate =
        castToType<int>(snapshotData['operatingExpenseRate']);
    _additionalRentalIncome =
        castToType<int>(snapshotData['additionalRentalIncome']);
    _tokens = castToType<int>(snapshotData['tokens']);
    _stripeCustomerId = snapshotData['stripeCustomerId'] as String?;
    _minimumReturn = castToType<int>(snapshotData['minimumReturn']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('UserData');

  static Stream<UserDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserDataRecord.fromSnapshot(s));

  static Future<UserDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserDataRecord.fromSnapshot(s));

  static UserDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserDataRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  int? gImptRate,
  int? aduImpRate,
  int? newBuildRate,
  double? financingRate,
  double? mtgRate,
  int? fnfImpRate,
  double? dwnPmtRate,
  double? fnfImpFactor,
  double? taxInsRate,
  double? salRate,
  int? twoBedAvgValue,
  int? newFutValSalperSFRate,
  int? oneBdrmMarketValue,
  double? aduImpFactor,
  int? aduOneBdrmCost,
  int? aduTwoBdrmCost,
  double? newImpFactor,
  int? propertyIns,
  int? propertyTaxes,
  int? permitsFees,
  int? fixnflipDuration,
  int? aduDuration,
  int? newDuration,
  double? loanFeesRate,
  double? vacanyRate,
  double? propertyManagementFeeRate,
  int? utilities,
  int? addOnImpValue,
  double? addOnImpFactor,
  int? addOnSqftRate,
  int? addOnArea,
  int? aduArea,
  int? addOnBeds,
  int? addOnBaths,
  int? aduBeds,
  int? aduBaths,
  int? newBeds,
  int? newBaths,
  int? newArea,
  int? addOnDuration,
  int? maintenanceRate,
  int? operatingExpenseRate,
  int? additionalRentalIncome,
  int? tokens,
  String? stripeCustomerId,
  int? minimumReturn,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'gImptRate': gImptRate,
      'aduImpRate': aduImpRate,
      'newBuildRate': newBuildRate,
      'financingRate': financingRate,
      'mtgRate': mtgRate,
      'fnfImpRate': fnfImpRate,
      'dwnPmtRate': dwnPmtRate,
      'fnfImpFactor': fnfImpFactor,
      'taxInsRate': taxInsRate,
      'salRate': salRate,
      'twoBedAvgValue': twoBedAvgValue,
      'newFutValSalperSFRate': newFutValSalperSFRate,
      'oneBdrmMarketValue': oneBdrmMarketValue,
      'aduImpFactor': aduImpFactor,
      'aduOneBdrmCost': aduOneBdrmCost,
      'aduTwoBdrmCost': aduTwoBdrmCost,
      'newImpFactor': newImpFactor,
      'propertyIns': propertyIns,
      'propertyTaxes': propertyTaxes,
      'permitsFees': permitsFees,
      'fixnflipDuration': fixnflipDuration,
      'aduDuration': aduDuration,
      'newDuration': newDuration,
      'loanFeesRate': loanFeesRate,
      'vacanyRate': vacanyRate,
      'propertyManagementFeeRate': propertyManagementFeeRate,
      'utilities': utilities,
      'addOnImpValue': addOnImpValue,
      'addOnImpFactor': addOnImpFactor,
      'addOnSqftRate': addOnSqftRate,
      'addOnArea': addOnArea,
      'aduArea': aduArea,
      'addOnBeds': addOnBeds,
      'addOnBaths': addOnBaths,
      'aduBeds': aduBeds,
      'aduBaths': aduBaths,
      'newBeds': newBeds,
      'newBaths': newBaths,
      'newArea': newArea,
      'addOnDuration': addOnDuration,
      'maintenanceRate': maintenanceRate,
      'operatingExpenseRate': operatingExpenseRate,
      'additionalRentalIncome': additionalRentalIncome,
      'tokens': tokens,
      'stripeCustomerId': stripeCustomerId,
      'minimumReturn': minimumReturn,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserDataRecordDocumentEquality implements Equality<UserDataRecord> {
  const UserDataRecordDocumentEquality();

  @override
  bool equals(UserDataRecord? e1, UserDataRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.gImptRate == e2?.gImptRate &&
        e1?.aduImpRate == e2?.aduImpRate &&
        e1?.newBuildRate == e2?.newBuildRate &&
        e1?.financingRate == e2?.financingRate &&
        e1?.mtgRate == e2?.mtgRate &&
        e1?.fnfImpRate == e2?.fnfImpRate &&
        e1?.dwnPmtRate == e2?.dwnPmtRate &&
        e1?.fnfImpFactor == e2?.fnfImpFactor &&
        e1?.taxInsRate == e2?.taxInsRate &&
        e1?.salRate == e2?.salRate &&
        e1?.twoBedAvgValue == e2?.twoBedAvgValue &&
        e1?.newFutValSalperSFRate == e2?.newFutValSalperSFRate &&
        e1?.oneBdrmMarketValue == e2?.oneBdrmMarketValue &&
        e1?.aduImpFactor == e2?.aduImpFactor &&
        e1?.aduOneBdrmCost == e2?.aduOneBdrmCost &&
        e1?.aduTwoBdrmCost == e2?.aduTwoBdrmCost &&
        e1?.newImpFactor == e2?.newImpFactor &&
        e1?.propertyIns == e2?.propertyIns &&
        e1?.propertyTaxes == e2?.propertyTaxes &&
        e1?.permitsFees == e2?.permitsFees &&
        e1?.fixnflipDuration == e2?.fixnflipDuration &&
        e1?.aduDuration == e2?.aduDuration &&
        e1?.newDuration == e2?.newDuration &&
        e1?.loanFeesRate == e2?.loanFeesRate &&
        e1?.vacanyRate == e2?.vacanyRate &&
        e1?.propertyManagementFeeRate == e2?.propertyManagementFeeRate &&
        e1?.utilities == e2?.utilities &&
        e1?.addOnImpValue == e2?.addOnImpValue &&
        e1?.addOnImpFactor == e2?.addOnImpFactor &&
        e1?.addOnSqftRate == e2?.addOnSqftRate &&
        e1?.addOnArea == e2?.addOnArea &&
        e1?.aduArea == e2?.aduArea &&
        e1?.addOnBeds == e2?.addOnBeds &&
        e1?.addOnBaths == e2?.addOnBaths &&
        e1?.aduBeds == e2?.aduBeds &&
        e1?.aduBaths == e2?.aduBaths &&
        e1?.newBeds == e2?.newBeds &&
        e1?.newBaths == e2?.newBaths &&
        e1?.newArea == e2?.newArea &&
        e1?.addOnDuration == e2?.addOnDuration &&
        e1?.maintenanceRate == e2?.maintenanceRate &&
        e1?.operatingExpenseRate == e2?.operatingExpenseRate &&
        e1?.additionalRentalIncome == e2?.additionalRentalIncome &&
        e1?.tokens == e2?.tokens &&
        e1?.stripeCustomerId == e2?.stripeCustomerId &&
        e1?.minimumReturn == e2?.minimumReturn;
  }

  @override
  int hash(UserDataRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.gImptRate,
        e?.aduImpRate,
        e?.newBuildRate,
        e?.financingRate,
        e?.mtgRate,
        e?.fnfImpRate,
        e?.dwnPmtRate,
        e?.fnfImpFactor,
        e?.taxInsRate,
        e?.salRate,
        e?.twoBedAvgValue,
        e?.newFutValSalperSFRate,
        e?.oneBdrmMarketValue,
        e?.aduImpFactor,
        e?.aduOneBdrmCost,
        e?.aduTwoBdrmCost,
        e?.newImpFactor,
        e?.propertyIns,
        e?.propertyTaxes,
        e?.permitsFees,
        e?.fixnflipDuration,
        e?.aduDuration,
        e?.newDuration,
        e?.loanFeesRate,
        e?.vacanyRate,
        e?.propertyManagementFeeRate,
        e?.utilities,
        e?.addOnImpValue,
        e?.addOnImpFactor,
        e?.addOnSqftRate,
        e?.addOnArea,
        e?.aduArea,
        e?.addOnBeds,
        e?.addOnBaths,
        e?.aduBeds,
        e?.aduBaths,
        e?.newBeds,
        e?.newBaths,
        e?.newArea,
        e?.addOnDuration,
        e?.maintenanceRate,
        e?.operatingExpenseRate,
        e?.additionalRentalIncome,
        e?.tokens,
        e?.stripeCustomerId,
        e?.minimumReturn
      ]);

  @override
  bool isValidKey(Object? o) => o is UserDataRecord;
}
