import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  Local state fields for this page.
  /// This is the counter used in the For loop on the on Page Load actions
  int counter = 0;

  /// these are the property details that are fetched on page load from the
  /// respective API call
  List<dynamic> pptyDetails = [];
  void addToPptyDetails(dynamic item) => pptyDetails.add(item);
  void removeFromPptyDetails(dynamic item) => pptyDetails.remove(item);
  void removeAtIndexFromPptyDetails(int index) => pptyDetails.removeAt(index);
  void insertAtIndexInPptyDetails(int index, dynamic item) =>
      pptyDetails.insert(index, item);
  void updatePptyDetailsAtIndex(int index, Function(dynamic) updateFn) =>
      pptyDetails[index] = updateFn(pptyDetails[index]);

  /// this stores the values from the cloud function ReinvestCalcsComb this
  /// field is uesed on the onPageLoad actions
  List<dynamic> reInvestCalcsCombined = [];
  void addToReInvestCalcsCombined(dynamic item) =>
      reInvestCalcsCombined.add(item);
  void removeFromReInvestCalcsCombined(dynamic item) =>
      reInvestCalcsCombined.remove(item);
  void removeAtIndexFromReInvestCalcsCombined(int index) =>
      reInvestCalcsCombined.removeAt(index);
  void insertAtIndexInReInvestCalcsCombined(int index, dynamic item) =>
      reInvestCalcsCombined.insert(index, item);
  void updateReInvestCalcsCombinedAtIndex(
          int index, Function(dynamic) updateFn) =>
      reInvestCalcsCombined[index] = updateFn(reInvestCalcsCombined[index]);

  List<dynamic> selectedRows = [];
  void addToSelectedRows(dynamic item) => selectedRows.add(item);
  void removeFromSelectedRows(dynamic item) => selectedRows.remove(item);
  void removeAtIndexFromSelectedRows(int index) => selectedRows.removeAt(index);
  void insertAtIndexInSelectedRows(int index, dynamic item) =>
      selectedRows.insert(index, item);
  void updateSelectedRowsAtIndex(int index, Function(dynamic) updateFn) =>
      selectedRows[index] = updateFn(selectedRows[index]);

  /// Counter for upload is used to iterate through in the For loop used in the
  /// Save button on the properties displayed in the table on Search tab
  int counterForUpload = 0;

  /// this is a counter implemented in search field action for a For loop inside
  /// it.
  int searchCounter = 0;

  /// these are property details returned from the respective API endpoint when
  /// user searches for a property using the search bar
  List<dynamic> searchPptyDetails = [];
  void addToSearchPptyDetails(dynamic item) => searchPptyDetails.add(item);
  void removeFromSearchPptyDetails(dynamic item) =>
      searchPptyDetails.remove(item);
  void removeAtIndexFromSearchPptyDetails(int index) =>
      searchPptyDetails.removeAt(index);
  void insertAtIndexInSearchPptyDetails(int index, dynamic item) =>
      searchPptyDetails.insert(index, item);
  void updateSearchPptyDetailsAtIndex(int index, Function(dynamic) updateFn) =>
      searchPptyDetails[index] = updateFn(searchPptyDetails[index]);

  /// this stores the values from the cloud function ReinvestCalcsComb this
  /// field is uesed on the search button actions
  List<dynamic> searchReinvestCalcsComb = [];
  void addToSearchReinvestCalcsComb(dynamic item) =>
      searchReinvestCalcsComb.add(item);
  void removeFromSearchReinvestCalcsComb(dynamic item) =>
      searchReinvestCalcsComb.remove(item);
  void removeAtIndexFromSearchReinvestCalcsComb(int index) =>
      searchReinvestCalcsComb.removeAt(index);
  void insertAtIndexInSearchReinvestCalcsComb(int index, dynamic item) =>
      searchReinvestCalcsComb.insert(index, item);
  void updateSearchReinvestCalcsCombAtIndex(
          int index, Function(dynamic) updateFn) =>
      searchReinvestCalcsComb[index] = updateFn(searchReinvestCalcsComb[index]);

  /// This toggles the side bar
  bool toggleSidebarOn = true;

  int paginationCounter = 1;

  /// This value is used to show search property detail component
  dynamic selectedProperty;

  /// This value is used to show saved property detail component
  SavedPropertiesRecord? selectedFieldSavedProperty;

  /// This stores map coordinates so that the small maps can show the proper
  /// location
  LatLng? mapCoordinates;

  List<LatLng> compCoordinates = [];
  void addToCompCoordinates(LatLng item) => compCoordinates.add(item);
  void removeFromCompCoordinates(LatLng item) => compCoordinates.remove(item);
  void removeAtIndexFromCompCoordinates(int index) =>
      compCoordinates.removeAt(index);
  void insertAtIndexInCompCoordinates(int index, LatLng item) =>
      compCoordinates.insert(index, item);
  void updateCompCoordinatesAtIndex(int index, Function(LatLng) updateFn) =>
      compCoordinates[index] = updateFn(compCoordinates[index]);

  int totalPages = 1;

  int compsLoopCounter = 0;

  List<dynamic> houseComps = [];
  void addToHouseComps(dynamic item) => houseComps.add(item);
  void removeFromHouseComps(dynamic item) => houseComps.remove(item);
  void removeAtIndexFromHouseComps(int index) => houseComps.removeAt(index);
  void insertAtIndexInHouseComps(int index, dynamic item) =>
      houseComps.insert(index, item);
  void updateHouseCompsAtIndex(int index, Function(dynamic) updateFn) =>
      houseComps[index] = updateFn(houseComps[index]);

  dynamic calculationResults;

  bool isLoading = false;

  String errorMessage = ' error';

  bool searchMapView = false;

  bool savedPropertiesMapView = false;

  String selectedTab = 'search';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in search widget.
  SavedPropertiesRecord? existingSavedDocWalkthrough;
  // Stores action output result for [Backend Call - Read Document] action in search widget.
  UserDataRecord? userDoc;
  // Stores action output result for [Backend Call - API (CloudCalcs)] action in search widget.
  ApiCallResponse? cloudFunctionsII;
  // Stores action output result for [Backend Call - API (CloudCalcs)] action in search widget.
  ApiCallResponse? cloudFunctionsGuest;
  // State field(s) for minimumReturn widget.
  FocusNode? minimumReturnFocusNode;
  TextEditingController? minimumReturnTextController;
  String? Function(BuildContext, String?)? minimumReturnTextControllerValidator;
  // State field(s) for dwnPmtRate widget.
  FocusNode? dwnPmtRateFocusNode;
  TextEditingController? dwnPmtRateTextController;
  String? Function(BuildContext, String?)? dwnPmtRateTextControllerValidator;
  // State field(s) for financingRate widget.
  FocusNode? financingRateFocusNode;
  TextEditingController? financingRateTextController;
  String? Function(BuildContext, String?)? financingRateTextControllerValidator;
  // State field(s) for propertyIns widget.
  FocusNode? propertyInsFocusNode;
  TextEditingController? propertyInsTextController;
  String? Function(BuildContext, String?)? propertyInsTextControllerValidator;
  // State field(s) for propertyTaxes widget.
  FocusNode? propertyTaxesFocusNode;
  TextEditingController? propertyTaxesTextController;
  String? Function(BuildContext, String?)? propertyTaxesTextControllerValidator;
  // State field(s) for salRate widget.
  FocusNode? salRateFocusNode;
  TextEditingController? salRateTextController;
  String? Function(BuildContext, String?)? salRateTextControllerValidator;
  // State field(s) for oneBdrmMarketValue widget.
  FocusNode? oneBdrmMarketValueFocusNode;
  TextEditingController? oneBdrmMarketValueTextController;
  String? Function(BuildContext, String?)?
      oneBdrmMarketValueTextControllerValidator;
  // State field(s) for twoBedAvgValue widget.
  FocusNode? twoBedAvgValueFocusNode;
  TextEditingController? twoBedAvgValueTextController;
  String? Function(BuildContext, String?)?
      twoBedAvgValueTextControllerValidator;
  // State field(s) for aduTwoBdrmCost widget.
  FocusNode? aduTwoBdrmCostFocusNode;
  TextEditingController? aduTwoBdrmCostTextController;
  String? Function(BuildContext, String?)?
      aduTwoBdrmCostTextControllerValidator;
  // State field(s) for newFutValSalperSFRate widget.
  FocusNode? newFutValSalperSFRateFocusNode;
  TextEditingController? newFutValSalperSFRateTextController;
  String? Function(BuildContext, String?)?
      newFutValSalperSFRateTextControllerValidator;
  // State field(s) for fixnflipDuration widget.
  FocusNode? fixnflipDurationFocusNode;
  TextEditingController? fixnflipDurationTextController;
  String? Function(BuildContext, String?)?
      fixnflipDurationTextControllerValidator;
  // State field(s) for fnfImpFactor widget.
  FocusNode? fnfImpFactorFocusNode;
  TextEditingController? fnfImpFactorTextController;
  String? Function(BuildContext, String?)? fnfImpFactorTextControllerValidator;
  // State field(s) for fnfImpRate widget.
  FocusNode? fnfImpRateFocusNode;
  TextEditingController? fnfImpRateTextController;
  String? Function(BuildContext, String?)? fnfImpRateTextControllerValidator;
  // State field(s) for additionDuration widget.
  FocusNode? additionDurationFocusNode;
  TextEditingController? additionDurationTextController;
  String? Function(BuildContext, String?)?
      additionDurationTextControllerValidator;
  // State field(s) for addOnImpFactor widget.
  FocusNode? addOnImpFactorFocusNode;
  TextEditingController? addOnImpFactorTextController;
  String? Function(BuildContext, String?)?
      addOnImpFactorTextControllerValidator;
  // State field(s) for addOnSqftRate widget.
  FocusNode? addOnSqftRateFocusNode;
  TextEditingController? addOnSqftRateTextController;
  String? Function(BuildContext, String?)? addOnSqftRateTextControllerValidator;
  // State field(s) for aduDuration widget.
  FocusNode? aduDurationFocusNode;
  TextEditingController? aduDurationTextController;
  String? Function(BuildContext, String?)? aduDurationTextControllerValidator;
  // State field(s) for aduImpFactor widget.
  FocusNode? aduImpFactorFocusNode;
  TextEditingController? aduImpFactorTextController;
  String? Function(BuildContext, String?)? aduImpFactorTextControllerValidator;
  // State field(s) for aduImpRate widget.
  FocusNode? aduImpRateFocusNode;
  TextEditingController? aduImpRateTextController;
  String? Function(BuildContext, String?)? aduImpRateTextControllerValidator;
  // State field(s) for newDuration widget.
  FocusNode? newDurationFocusNode;
  TextEditingController? newDurationTextController;
  String? Function(BuildContext, String?)? newDurationTextControllerValidator;
  // State field(s) for newImpFactor widget.
  FocusNode? newImpFactorFocusNode;
  TextEditingController? newImpFactorTextController;
  String? Function(BuildContext, String?)? newImpFactorTextControllerValidator;
  // State field(s) for newBuildRate widget.
  FocusNode? newBuildRateFocusNode;
  TextEditingController? newBuildRateTextController;
  String? Function(BuildContext, String?)? newBuildRateTextControllerValidator;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController1;

  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode1;
  TextEditingController? searchFieldTextController1;
  String? Function(BuildContext, String?)? searchFieldTextController1Validator;
  // Stores action output result for [Backend Call - API (CloudCalcs)] action in SearchField widget.
  ApiCallResponse? cloudFunctionsSearch;
  // Stores action output result for [Backend Call - API (CloudCalcs)] action in SearchField widget.
  ApiCallResponse? cloudFunctionsSearchOnChange;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController24;
  String? Function(BuildContext, String?)? textController24Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController25;
  String? Function(BuildContext, String?)? textController25Validator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Firestore Query - Query a collection] action in VIEWButton widget.
  SavedPropertiesRecord? existingSavedDoc;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter1;
  final googleMapsController1 = Completer<GoogleMapController>();
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter2;
  final googleMapsController2 = Completer<GoogleMapController>();
  // Stores action output result for [Firestore Query - Query a collection] action in MainMap widget.
  SavedPropertiesRecord? existingSavedDocMap;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController2;

  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode2;
  TextEditingController? searchFieldTextController2;
  String? Function(BuildContext, String?)? searchFieldTextController2Validator;
  // Stores action output result for [Backend Call - API (CloudCalcs)] action in SearchField widget.
  ApiCallResponse? cloudFunctionsSearchMobile;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController27;
  String? Function(BuildContext, String?)? textController27Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController28;
  String? Function(BuildContext, String?)? textController28Validator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    minimumReturnFocusNode?.dispose();
    minimumReturnTextController?.dispose();

    dwnPmtRateFocusNode?.dispose();
    dwnPmtRateTextController?.dispose();

    financingRateFocusNode?.dispose();
    financingRateTextController?.dispose();

    propertyInsFocusNode?.dispose();
    propertyInsTextController?.dispose();

    propertyTaxesFocusNode?.dispose();
    propertyTaxesTextController?.dispose();

    salRateFocusNode?.dispose();
    salRateTextController?.dispose();

    oneBdrmMarketValueFocusNode?.dispose();
    oneBdrmMarketValueTextController?.dispose();

    twoBedAvgValueFocusNode?.dispose();
    twoBedAvgValueTextController?.dispose();

    aduTwoBdrmCostFocusNode?.dispose();
    aduTwoBdrmCostTextController?.dispose();

    newFutValSalperSFRateFocusNode?.dispose();
    newFutValSalperSFRateTextController?.dispose();

    fixnflipDurationFocusNode?.dispose();
    fixnflipDurationTextController?.dispose();

    fnfImpFactorFocusNode?.dispose();
    fnfImpFactorTextController?.dispose();

    fnfImpRateFocusNode?.dispose();
    fnfImpRateTextController?.dispose();

    additionDurationFocusNode?.dispose();
    additionDurationTextController?.dispose();

    addOnImpFactorFocusNode?.dispose();
    addOnImpFactorTextController?.dispose();

    addOnSqftRateFocusNode?.dispose();
    addOnSqftRateTextController?.dispose();

    aduDurationFocusNode?.dispose();
    aduDurationTextController?.dispose();

    aduImpFactorFocusNode?.dispose();
    aduImpFactorTextController?.dispose();

    aduImpRateFocusNode?.dispose();
    aduImpRateTextController?.dispose();

    newDurationFocusNode?.dispose();
    newDurationTextController?.dispose();

    newImpFactorFocusNode?.dispose();
    newImpFactorTextController?.dispose();

    newBuildRateFocusNode?.dispose();
    newBuildRateTextController?.dispose();

    expandableExpandableController1.dispose();
    searchFieldFocusNode1?.dispose();
    searchFieldTextController1?.dispose();

    textFieldFocusNode1?.dispose();
    textController24?.dispose();

    textFieldFocusNode2?.dispose();
    textController25?.dispose();

    tabBarController?.dispose();
    expandableExpandableController2.dispose();
    searchFieldFocusNode2?.dispose();
    searchFieldTextController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController27?.dispose();

    textFieldFocusNode4?.dispose();
    textController28?.dispose();
  }

  /// Action blocks.
  Future documentFromAPIData(
    BuildContext context, {
    required dynamic apiPropertyData,
  }) async {
    SavedPropertiesRecord? newSavedProperty;

    logFirebaseEvent('DocumentFromAPIData_backend_call');

    var savedPropertiesRecordReference =
        SavedPropertiesRecord.collection.doc('${currentUserUid}_${getJsonField(
      apiPropertyData,
      r'''$.zpid''',
    ).toString()}');
    await savedPropertiesRecordReference.set({
      ...createSavedPropertiesRecordData(
        method: getJsonField(
          apiPropertyData,
          r'''$.method''',
        ).toString(),
        impValue: getJsonField(
          apiPropertyData,
          r'''$.impValue''',
        ),
        totalValue: getJsonField(
          apiPropertyData,
          r'''$.totalValue''',
        ),
        futureValue: getJsonField(
          apiPropertyData,
          r'''$.futureValue''',
        ),
        downPayment: getJsonField(
          apiPropertyData,
          r'''$.downPayment''',
        ),
        mortgage: getJsonField(
          apiPropertyData,
          r'''$.mortgage''',
        ),
        sellingCosts: getJsonField(
          apiPropertyData,
          r'''$.sellingCosts''',
        ),
        totalCosts: getJsonField(
          apiPropertyData,
          r'''$.totalCosts''',
        ),
        grossReturn: getJsonField(
          apiPropertyData,
          r'''$.grossReturn''',
        ),
        netReturn: getJsonField(
          apiPropertyData,
          r'''$.netReturn''',
        ),
        address: getJsonField(
          apiPropertyData,
          r'''$.address''',
        ).toString(),
        imgSrc: getJsonField(
          apiPropertyData,
          r'''$.imgSrc''',
        ).toString(),
        latlng: functions.convertToLatLng(
            getJsonField(
              apiPropertyData,
              r'''$.latlng.latitude''',
            ),
            getJsonField(
              apiPropertyData,
              r'''$.latlng.longitude''',
            )),
        netRoi: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.netROI''',
          ),
          0.0,
        ),
        detailUrl: getJsonField(
          apiPropertyData,
          r'''$.detailUrl''',
        ).toString(),
        bedrooms: getJsonField(
          apiPropertyData,
          r'''$.bedrooms''',
        ),
        bathrooms: getJsonField(
          apiPropertyData,
          r'''$.bathrooms''',
        ),
        daysonZillow: getJsonField(
          apiPropertyData,
          r'''$.daysOnZillow''',
        ),
        rentZestimate: getJsonField(
          apiPropertyData,
          r'''$.rentZestimate''',
        ),
        notes: '',
        livingArea: getJsonField(
          apiPropertyData,
          r'''$.livingArea''',
        ),
        price: getJsonField(
          apiPropertyData,
          r'''$.price''',
        ),
        taxInsRate: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.propTaxIns''',
          ),
          0.0,
        ),
        permitFees: getJsonField(
          apiPropertyData,
          r'''$.permitsFees''',
        ),
        propertyTaxes: getJsonField(
          apiPropertyData,
          r'''$.propertyTaxes''',
        ),
        propertyIns: getJsonField(
          apiPropertyData,
          r'''$.propertyIns''',
        ),
        loanFees: getJsonField(
          apiPropertyData,
          r'''$.loanFees''',
        ),
        purchCloseDate: functions.convertToDateTime(getJsonField(
          apiPropertyData,
          r'''$.purchCloseDate''',
        )),
        saleCloseDate: functions.convertToDateTime(getJsonField(
          apiPropertyData,
          r'''$.saleCloseDate''',
        )),
        propertyTaxIns: valueOrDefault<int>(
          getJsonField(
            apiPropertyData,
            r'''$.propTaxIns''',
          ),
          0,
        ),
        cashOnCashReturn: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.cashOnCashReturn''',
          ),
          0.0,
        ),
        duration: getJsonField(
          apiPropertyData,
          r'''$.duration''',
        ),
        proposedLivingArea: getJsonField(
          apiPropertyData,
          r'''$.futureLivingArea''',
        ),
        futureBeds: getJsonField(
          apiPropertyData,
          r'''$.futureBeds''',
        ),
        futureBaths: getJsonField(
          apiPropertyData,
          r'''$.futureBaths''',
        ),
        zestimate: getJsonField(
          apiPropertyData,
          r'''$.zestimate''',
        ),
        yearBuilt: getJsonField(
          apiPropertyData,
          r'''$.yearBuilt''',
        ),
        description: getJsonField(
          apiPropertyData,
          r'''$.description''',
        ).toString(),
        loanPayments: getJsonField(
          apiPropertyData,
          r'''$.loanPayments''',
        ),
        loanAmount: getJsonField(
          apiPropertyData,
          r'''$.loanAmount''',
        ),
        id: getJsonField(
          apiPropertyData,
          r'''$.zpid''',
        ).toString(),
        futureArea: getJsonField(
          apiPropertyData,
          r'''$.futureLivingArea''',
        ),
        cashNeeded: valueOrDefault<int>(
          getJsonField(
            selectedProperty,
            r'''$.cashNeeded''',
          ),
          1,
        ),
        lotAreaValue: valueOrDefault<double>(
          getJsonField(
            selectedProperty,
            r'''$.lotAreaValue''',
          ),
          0.0,
        ),
        userRef: currentUserReference,
        dscr: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.dscr''',
          ),
          0.0,
        ),
        groc: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.groc''',
          ),
          0.0,
        ),
        avgCompTotalValue: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.avgCompTotalValue''',
          ),
          0.0,
        ),
        calculateBedroomPriceAverages: getJsonField(
          apiPropertyData,
          r'''$.avgDollarPerBdrm''',
        ),
        irr: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.irr''',
          ),
          0.0,
        ),
        compsAvgPricePerBdrm: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.avgDollarPerBdrm''',
          ),
          0.0,
        ),
        pricePerSqft: getJsonField(
          apiPropertyData,
          r'''$.pricePerSqft''',
        ),
        roe: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.roe''',
          ),
          0.0,
        ),
        avgCompPrice: getJsonField(
          apiPropertyData,
          r'''$.avgCompPrice''',
        ),
        netRetnalIncome5yrs: getJsonField(
          apiPropertyData,
          r'''$.netRentalIncome5yrs''',
        ),
        totalReturn: getJsonField(
          apiPropertyData,
          r'''$.totalReturn''',
        ),
        notesARV: '',
      ),
      ...mapToFirestore(
        {
          'redfinSoldComps': getRedfinHomeDataListFirestoreData(
            (getJsonField(
              selectedProperty,
              r'''$.redfinSoldComps''',
              true,
            )
                    ?.toList()
                    .map<RedfinHomeDataStruct?>(
                        RedfinHomeDataStruct.maybeFromMap)
                    .toList() as Iterable<RedfinHomeDataStruct?>)
                .withoutNulls,
          ),
          'redfinForSaleComps': getRedfinHomeDataListFirestoreData(
            (getJsonField(
              selectedProperty,
              r'''$.redfinForSaleComps''',
              true,
            )
                    ?.toList()
                    .map<RedfinHomeDataStruct?>(
                        RedfinHomeDataStruct.maybeFromMap)
                    .toList() as Iterable<RedfinHomeDataStruct?>)
                .withoutNulls,
          ),
        },
      ),
    });
    newSavedProperty = SavedPropertiesRecord.getDocumentFromData({
      ...createSavedPropertiesRecordData(
        method: getJsonField(
          apiPropertyData,
          r'''$.method''',
        ).toString(),
        impValue: getJsonField(
          apiPropertyData,
          r'''$.impValue''',
        ),
        totalValue: getJsonField(
          apiPropertyData,
          r'''$.totalValue''',
        ),
        futureValue: getJsonField(
          apiPropertyData,
          r'''$.futureValue''',
        ),
        downPayment: getJsonField(
          apiPropertyData,
          r'''$.downPayment''',
        ),
        mortgage: getJsonField(
          apiPropertyData,
          r'''$.mortgage''',
        ),
        sellingCosts: getJsonField(
          apiPropertyData,
          r'''$.sellingCosts''',
        ),
        totalCosts: getJsonField(
          apiPropertyData,
          r'''$.totalCosts''',
        ),
        grossReturn: getJsonField(
          apiPropertyData,
          r'''$.grossReturn''',
        ),
        netReturn: getJsonField(
          apiPropertyData,
          r'''$.netReturn''',
        ),
        address: getJsonField(
          apiPropertyData,
          r'''$.address''',
        ).toString(),
        imgSrc: getJsonField(
          apiPropertyData,
          r'''$.imgSrc''',
        ).toString(),
        latlng: functions.convertToLatLng(
            getJsonField(
              apiPropertyData,
              r'''$.latlng.latitude''',
            ),
            getJsonField(
              apiPropertyData,
              r'''$.latlng.longitude''',
            )),
        netRoi: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.netROI''',
          ),
          0.0,
        ),
        detailUrl: getJsonField(
          apiPropertyData,
          r'''$.detailUrl''',
        ).toString(),
        bedrooms: getJsonField(
          apiPropertyData,
          r'''$.bedrooms''',
        ),
        bathrooms: getJsonField(
          apiPropertyData,
          r'''$.bathrooms''',
        ),
        daysonZillow: getJsonField(
          apiPropertyData,
          r'''$.daysOnZillow''',
        ),
        rentZestimate: getJsonField(
          apiPropertyData,
          r'''$.rentZestimate''',
        ),
        notes: '',
        livingArea: getJsonField(
          apiPropertyData,
          r'''$.livingArea''',
        ),
        price: getJsonField(
          apiPropertyData,
          r'''$.price''',
        ),
        taxInsRate: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.propTaxIns''',
          ),
          0.0,
        ),
        permitFees: getJsonField(
          apiPropertyData,
          r'''$.permitsFees''',
        ),
        propertyTaxes: getJsonField(
          apiPropertyData,
          r'''$.propertyTaxes''',
        ),
        propertyIns: getJsonField(
          apiPropertyData,
          r'''$.propertyIns''',
        ),
        loanFees: getJsonField(
          apiPropertyData,
          r'''$.loanFees''',
        ),
        purchCloseDate: functions.convertToDateTime(getJsonField(
          apiPropertyData,
          r'''$.purchCloseDate''',
        )),
        saleCloseDate: functions.convertToDateTime(getJsonField(
          apiPropertyData,
          r'''$.saleCloseDate''',
        )),
        propertyTaxIns: valueOrDefault<int>(
          getJsonField(
            apiPropertyData,
            r'''$.propTaxIns''',
          ),
          0,
        ),
        cashOnCashReturn: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.cashOnCashReturn''',
          ),
          0.0,
        ),
        duration: getJsonField(
          apiPropertyData,
          r'''$.duration''',
        ),
        proposedLivingArea: getJsonField(
          apiPropertyData,
          r'''$.futureLivingArea''',
        ),
        futureBeds: getJsonField(
          apiPropertyData,
          r'''$.futureBeds''',
        ),
        futureBaths: getJsonField(
          apiPropertyData,
          r'''$.futureBaths''',
        ),
        zestimate: getJsonField(
          apiPropertyData,
          r'''$.zestimate''',
        ),
        yearBuilt: getJsonField(
          apiPropertyData,
          r'''$.yearBuilt''',
        ),
        description: getJsonField(
          apiPropertyData,
          r'''$.description''',
        ).toString(),
        loanPayments: getJsonField(
          apiPropertyData,
          r'''$.loanPayments''',
        ),
        loanAmount: getJsonField(
          apiPropertyData,
          r'''$.loanAmount''',
        ),
        id: getJsonField(
          apiPropertyData,
          r'''$.zpid''',
        ).toString(),
        futureArea: getJsonField(
          apiPropertyData,
          r'''$.futureLivingArea''',
        ),
        cashNeeded: valueOrDefault<int>(
          getJsonField(
            selectedProperty,
            r'''$.cashNeeded''',
          ),
          1,
        ),
        lotAreaValue: valueOrDefault<double>(
          getJsonField(
            selectedProperty,
            r'''$.lotAreaValue''',
          ),
          0.0,
        ),
        userRef: currentUserReference,
        dscr: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.dscr''',
          ),
          0.0,
        ),
        groc: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.groc''',
          ),
          0.0,
        ),
        avgCompTotalValue: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.avgCompTotalValue''',
          ),
          0.0,
        ),
        calculateBedroomPriceAverages: getJsonField(
          apiPropertyData,
          r'''$.avgDollarPerBdrm''',
        ),
        irr: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.irr''',
          ),
          0.0,
        ),
        compsAvgPricePerBdrm: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.avgDollarPerBdrm''',
          ),
          0.0,
        ),
        pricePerSqft: getJsonField(
          apiPropertyData,
          r'''$.pricePerSqft''',
        ),
        roe: valueOrDefault<double>(
          getJsonField(
            apiPropertyData,
            r'''$.roe''',
          ),
          0.0,
        ),
        avgCompPrice: getJsonField(
          apiPropertyData,
          r'''$.avgCompPrice''',
        ),
        netRetnalIncome5yrs: getJsonField(
          apiPropertyData,
          r'''$.netRentalIncome5yrs''',
        ),
        totalReturn: getJsonField(
          apiPropertyData,
          r'''$.totalReturn''',
        ),
        notesARV: '',
      ),
      ...mapToFirestore(
        {
          'redfinSoldComps': getRedfinHomeDataListFirestoreData(
            (getJsonField(
              selectedProperty,
              r'''$.redfinSoldComps''',
              true,
            )
                    ?.toList()
                    .map<RedfinHomeDataStruct?>(
                        RedfinHomeDataStruct.maybeFromMap)
                    .toList() as Iterable<RedfinHomeDataStruct?>)
                .withoutNulls,
          ),
          'redfinForSaleComps': getRedfinHomeDataListFirestoreData(
            (getJsonField(
              selectedProperty,
              r'''$.redfinForSaleComps''',
              true,
            )
                    ?.toList()
                    .map<RedfinHomeDataStruct?>(
                        RedfinHomeDataStruct.maybeFromMap)
                    .toList() as Iterable<RedfinHomeDataStruct?>)
                .withoutNulls,
          ),
        },
      ),
    }, savedPropertiesRecordReference);
    logFirebaseEvent('DocumentFromAPIData_update_page_state');
    selectedFieldSavedProperty = newSavedProperty;
    selectedProperty = null;
  }
}
