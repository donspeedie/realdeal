// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IrrAnalysisStruct extends FFFirebaseStruct {
  IrrAnalysisStruct({
    double? irr,
    List<int>? cashFlows,
    int? initialInvestment,
    double? totalCarryingCosts,
    int? finalCashFlow,
    int? holdingPeriodYears,
    int? totalMonths,
    String? method,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _irr = irr,
        _cashFlows = cashFlows,
        _initialInvestment = initialInvestment,
        _totalCarryingCosts = totalCarryingCosts,
        _finalCashFlow = finalCashFlow,
        _holdingPeriodYears = holdingPeriodYears,
        _totalMonths = totalMonths,
        _method = method,
        super(firestoreUtilData);

  // "irr" field.
  double? _irr;
  double get irr => _irr ?? 0.0;
  set irr(double? val) => _irr = val;

  void incrementIrr(double amount) => irr = irr + amount;

  bool hasIrr() => _irr != null;

  // "cashFlows" field.
  List<int>? _cashFlows;
  List<int> get cashFlows => _cashFlows ?? const [];
  set cashFlows(List<int>? val) => _cashFlows = val;

  void updateCashFlows(Function(List<int>) updateFn) {
    updateFn(_cashFlows ??= []);
  }

  bool hasCashFlows() => _cashFlows != null;

  // "initialInvestment" field.
  int? _initialInvestment;
  int get initialInvestment => _initialInvestment ?? 0;
  set initialInvestment(int? val) => _initialInvestment = val;

  void incrementInitialInvestment(int amount) =>
      initialInvestment = initialInvestment + amount;

  bool hasInitialInvestment() => _initialInvestment != null;

  // "totalCarryingCosts" field.
  double? _totalCarryingCosts;
  double get totalCarryingCosts => _totalCarryingCosts ?? 0.0;
  set totalCarryingCosts(double? val) => _totalCarryingCosts = val;

  void incrementTotalCarryingCosts(double amount) =>
      totalCarryingCosts = totalCarryingCosts + amount;

  bool hasTotalCarryingCosts() => _totalCarryingCosts != null;

  // "finalCashFlow" field.
  int? _finalCashFlow;
  int get finalCashFlow => _finalCashFlow ?? 0;
  set finalCashFlow(int? val) => _finalCashFlow = val;

  void incrementFinalCashFlow(int amount) =>
      finalCashFlow = finalCashFlow + amount;

  bool hasFinalCashFlow() => _finalCashFlow != null;

  // "holdingPeriodYears" field.
  int? _holdingPeriodYears;
  int get holdingPeriodYears => _holdingPeriodYears ?? 0;
  set holdingPeriodYears(int? val) => _holdingPeriodYears = val;

  void incrementHoldingPeriodYears(int amount) =>
      holdingPeriodYears = holdingPeriodYears + amount;

  bool hasHoldingPeriodYears() => _holdingPeriodYears != null;

  // "totalMonths" field.
  int? _totalMonths;
  int get totalMonths => _totalMonths ?? 0;
  set totalMonths(int? val) => _totalMonths = val;

  void incrementTotalMonths(int amount) => totalMonths = totalMonths + amount;

  bool hasTotalMonths() => _totalMonths != null;

  // "method" field.
  String? _method;
  String get method => _method ?? '';
  set method(String? val) => _method = val;

  bool hasMethod() => _method != null;

  static IrrAnalysisStruct fromMap(Map<String, dynamic> data) =>
      IrrAnalysisStruct(
        irr: castToType<double>(data['irr']),
        cashFlows: getDataList(data['cashFlows']),
        initialInvestment: castToType<int>(data['initialInvestment']),
        totalCarryingCosts: castToType<double>(data['totalCarryingCosts']),
        finalCashFlow: castToType<int>(data['finalCashFlow']),
        holdingPeriodYears: castToType<int>(data['holdingPeriodYears']),
        totalMonths: castToType<int>(data['totalMonths']),
        method: data['method'] as String?,
      );

  static IrrAnalysisStruct? maybeFromMap(dynamic data) => data is Map
      ? IrrAnalysisStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'irr': _irr,
        'cashFlows': _cashFlows,
        'initialInvestment': _initialInvestment,
        'totalCarryingCosts': _totalCarryingCosts,
        'finalCashFlow': _finalCashFlow,
        'holdingPeriodYears': _holdingPeriodYears,
        'totalMonths': _totalMonths,
        'method': _method,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'irr': serializeParam(
          _irr,
          ParamType.double,
        ),
        'cashFlows': serializeParam(
          _cashFlows,
          ParamType.int,
          isList: true,
        ),
        'initialInvestment': serializeParam(
          _initialInvestment,
          ParamType.int,
        ),
        'totalCarryingCosts': serializeParam(
          _totalCarryingCosts,
          ParamType.double,
        ),
        'finalCashFlow': serializeParam(
          _finalCashFlow,
          ParamType.int,
        ),
        'holdingPeriodYears': serializeParam(
          _holdingPeriodYears,
          ParamType.int,
        ),
        'totalMonths': serializeParam(
          _totalMonths,
          ParamType.int,
        ),
        'method': serializeParam(
          _method,
          ParamType.String,
        ),
      }.withoutNulls;

  static IrrAnalysisStruct fromSerializableMap(Map<String, dynamic> data) =>
      IrrAnalysisStruct(
        irr: deserializeParam(
          data['irr'],
          ParamType.double,
          false,
        ),
        cashFlows: deserializeParam<int>(
          data['cashFlows'],
          ParamType.int,
          true,
        ),
        initialInvestment: deserializeParam(
          data['initialInvestment'],
          ParamType.int,
          false,
        ),
        totalCarryingCosts: deserializeParam(
          data['totalCarryingCosts'],
          ParamType.double,
          false,
        ),
        finalCashFlow: deserializeParam(
          data['finalCashFlow'],
          ParamType.int,
          false,
        ),
        holdingPeriodYears: deserializeParam(
          data['holdingPeriodYears'],
          ParamType.int,
          false,
        ),
        totalMonths: deserializeParam(
          data['totalMonths'],
          ParamType.int,
          false,
        ),
        method: deserializeParam(
          data['method'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'IrrAnalysisStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is IrrAnalysisStruct &&
        irr == other.irr &&
        listEquality.equals(cashFlows, other.cashFlows) &&
        initialInvestment == other.initialInvestment &&
        totalCarryingCosts == other.totalCarryingCosts &&
        finalCashFlow == other.finalCashFlow &&
        holdingPeriodYears == other.holdingPeriodYears &&
        totalMonths == other.totalMonths &&
        method == other.method;
  }

  @override
  int get hashCode => const ListEquality().hash([
        irr,
        cashFlows,
        initialInvestment,
        totalCarryingCosts,
        finalCashFlow,
        holdingPeriodYears,
        totalMonths,
        method
      ]);
}

IrrAnalysisStruct createIrrAnalysisStruct({
  double? irr,
  int? initialInvestment,
  double? totalCarryingCosts,
  int? finalCashFlow,
  int? holdingPeriodYears,
  int? totalMonths,
  String? method,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    IrrAnalysisStruct(
      irr: irr,
      initialInvestment: initialInvestment,
      totalCarryingCosts: totalCarryingCosts,
      finalCashFlow: finalCashFlow,
      holdingPeriodYears: holdingPeriodYears,
      totalMonths: totalMonths,
      method: method,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

IrrAnalysisStruct? updateIrrAnalysisStruct(
  IrrAnalysisStruct? irrAnalysis, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    irrAnalysis
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addIrrAnalysisStructData(
  Map<String, dynamic> firestoreData,
  IrrAnalysisStruct? irrAnalysis,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (irrAnalysis == null) {
    return;
  }
  if (irrAnalysis.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && irrAnalysis.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final irrAnalysisData =
      getIrrAnalysisFirestoreData(irrAnalysis, forFieldValue);
  final nestedData =
      irrAnalysisData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = irrAnalysis.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getIrrAnalysisFirestoreData(
  IrrAnalysisStruct? irrAnalysis, [
  bool forFieldValue = false,
]) {
  if (irrAnalysis == null) {
    return {};
  }
  final firestoreData = mapToFirestore(irrAnalysis.toMap());

  // Add any Firestore field values
  irrAnalysis.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getIrrAnalysisListFirestoreData(
  List<IrrAnalysisStruct>? irrAnalysiss,
) =>
    irrAnalysiss?.map((e) => getIrrAnalysisFirestoreData(e, true)).toList() ??
    [];
