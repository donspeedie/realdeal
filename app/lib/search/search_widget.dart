import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/api_requests/api_streaming.dart';
import '/backend/backend.dart';
import '/components/auth_dialogue_widget.dart';
import '/components/buy_tokens_widget.dart';
import '/components/detail_component_search_non_editable_widget.dart';
import '/components/image_card_widget.dart';
import '/components/step1_dialogue_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'search';
  static String routePath = '/searchPpty';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  late SearchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'search'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('SEARCH_PAGE_search_ON_INIT_STATE');
      if (!isWeb) {
        logFirebaseEvent('search_request_permissions');
        await requestPermission(locationPermission);
      }
      logFirebaseEvent('search_alert_dialog');
      unawaited(
        () async {}(),
      );
      logFirebaseEvent('search_alert_dialog');
      showDialog(
        barrierColor: Color(0x34000000),
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            alignment: AlignmentDirectional(-1.0, 0.0)
                .resolve(Directionality.of(context)),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(dialogContext).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Step1DialogueWidget(
                loadProperty: () async {
                  logFirebaseEvent('_update_page_state');
                  _model.selectedProperty = null;
                  _model.selectedFieldSavedProperty = null;
                  safeSetState(() {});
                  if (loggedIn) {
                    logFirebaseEvent('_firestore_query');
                    _model.existingSavedDocWalkthrough =
                        await querySavedPropertiesRecordOnce(
                      queryBuilder: (savedPropertiesRecord) =>
                          savedPropertiesRecord
                              .where(
                                'userRef',
                                isEqualTo: currentUserReference,
                              )
                              .where(
                                'id',
                                isEqualTo: getJsonField(
                                  _model.selectedProperty,
                                  r'''$.zpid''',
                                ).toString(),
                              )
                              .where(
                                'method',
                                isEqualTo: getJsonField(
                                  _model.selectedProperty,
                                  r'''$.method''',
                                ).toString(),
                              ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    if (_model.existingSavedDocWalkthrough != null) {
                      logFirebaseEvent('_update_page_state');
                      _model.selectedProperty = null;
                      _model.selectedFieldSavedProperty =
                          _model.existingSavedDocWalkthrough;
                      _model.compCoordinates = functions
                          .convertListsToLatLng(
                              _model
                                  .existingSavedDocWalkthrough!.redfinSoldComps
                                  .map((e) => e.latLong.value.latitude)
                                  .toList()
                                  .toList(),
                              _model
                                  .existingSavedDocWalkthrough!.redfinSoldComps
                                  .map((e) => e.latLong.value.longitude)
                                  .toList()
                                  .toList())
                          .toList()
                          .cast<LatLng>();
                      _model.mapCoordinates =
                          _model.existingSavedDocWalkthrough?.latlng;
                      safeSetState(() {});
                    } else {
                      if (valueOrDefault(currentUserDocument?.tokens, 0) > 0) {
                        logFirebaseEvent('_backend_call');
                        unawaited(
                          () async {
                            await currentUserReference!.update({
                              ...mapToFirestore(
                                {
                                  'tokens': FieldValue.increment(-(1)),
                                },
                              ),
                            });
                          }(),
                        );
                        logFirebaseEvent('_update_page_state');
                        _model.selectedProperty =
                            _model.reInvestCalcsCombined.firstOrNull;
                        _model.selectedFieldSavedProperty = null;
                        safeSetState(() {});
                        logFirebaseEvent('_update_page_state');
                        _model.mapCoordinates = functions.convertToLatLng(
                            valueOrDefault<double>(
                              getJsonField(
                                _model.selectedProperty,
                                r'''$.latlng.latitude''',
                              ),
                              1.0,
                            ),
                            valueOrDefault<double>(
                              getJsonField(
                                _model.selectedProperty,
                                r'''$.latlng.longitude''',
                              ),
                              1.0,
                            ));
                        _model.compCoordinates = functions
                            .convertListsToLatLng(
                                PropertyDetailsStruct.maybeFromMap(
                                        _model.selectedProperty!)!
                                    .redfinSoldComps
                                    .map((e) => e.latLong.value.latitude)
                                    .toList()
                                    .toList(),
                                PropertyDetailsStruct.maybeFromMap(
                                        _model.selectedProperty!)!
                                    .redfinSoldComps
                                    .map((e) => e.latLong.value.longitude)
                                    .toList()
                                    .toList())
                            .toList()
                            .cast<LatLng>();
                        safeSetState(() {});
                        logFirebaseEvent('_action_block');
                        await _model.documentFromAPIData(
                          context,
                          apiPropertyData:
                              _model.reInvestCalcsCombined.firstOrNull,
                        );
                        logFirebaseEvent('_rebuild_page');
                        safeSetState(() {});
                      } else {
                        logFirebaseEvent('_show_snack_bar');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please purchase tokens to continue',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                      }
                    }
                  } else {
                    logFirebaseEvent('_alert_dialog');
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: AuthDialogueWidget(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          );
        },
      );

      if (loggedIn) {
        logFirebaseEvent('search_backend_call');
        _model.userDoc =
            await UserDataRecord.getDocumentOnce(currentUserReference!);
        logFirebaseEvent('search_backend_call');
        unawaited(
          () async {
            _model.cloudFunctionsII =
                await FirebaseCloudFunctionsGroup.cloudCalcsCall.call(
              location: 'Sacramento',
              minPrice: 1000,
              maxPrice: 750000,
              propertyType: 'SINGLE_FAMILY',
              daysOn: 7,
              lotSizeMin: 3000,
              dwnPmtRate: _model.userDoc?.dwnPmtRate,
              salRate: _model.userDoc?.salRate,
              financingRate: _model.userDoc?.financingRate,
              taxInsRate: _model.userDoc?.taxInsRate,
              fnfImpRate: _model.userDoc?.fnfImpRate,
              aduImpRate: _model.userDoc?.aduImpRate,
              newImpRate: _model.userDoc?.newBuildRate,
              fnfImpFactor: _model.userDoc?.fnfImpFactor,
              twoBedAvgValue: _model.userDoc?.twoBedAvgValue,
              twoBdrmAduCost: _model.userDoc?.aduTwoBdrmCost,
              newFutValSalperSFRate: _model.userDoc?.newFutValSalperSFRate,
              oneBdrmMarketValue: _model.userDoc?.oneBdrmMarketValue,
              loanFeesRate: _model.userDoc?.loanFeesRate,
              propertyIns: _model.userDoc?.propertyIns,
              propertyTaxes: _model.userDoc?.propertyTaxes,
              permitsFees: _model.userDoc?.permitsFees,
              fixnflipDuration: _model.userDoc?.fixnflipDuration,
              addOnDuration: _model.userDoc?.addOnDuration,
              aduDuration: _model.userDoc?.aduDuration,
              newDuration: _model.userDoc?.newDuration,
              newBuildRate: _model.userDoc?.newBuildRate,
              isInterestOnly: true,
              addOnSqftRate: _model.userDoc?.addOnSqftRate,
              addOnImpFactor: _model.userDoc?.addOnImpFactor,
              addOnBeds: _model.userDoc?.addOnBeds,
              addOnBaths: _model.userDoc?.addOnBaths,
              aduBeds: _model.userDoc?.aduBeds,
              aduBaths: _model.userDoc?.aduBaths,
              aduArea: _model.userDoc?.aduArea,
              newArea: _model.userDoc?.newArea,
              newBeds: _model.userDoc?.newBeds,
              newBaths: _model.userDoc?.newBaths,
              statusType: 'FOR_SALE',
              vacanyRate: _model.userDoc?.vacanyRate,
              utilities: _model.userDoc?.utilities,
              maintenanceRate: _model.userDoc?.maintenanceRate,
              propertyManagementFeeRate:
                  _model.userDoc?.propertyManagementFeeRate,
              operatingExpenseRate: _model.userDoc?.operatingExpenseRate,
              aduImpFactor: _model.userDoc?.aduImpFactor,
              newImpFactor: _model.userDoc?.newImpFactor,
              addOnRate: _model.userDoc?.addOnSqftRate,
              addOnArea: _model.userDoc?.addOnArea,
            );
            if (_model.cloudFunctionsII?.succeeded ?? true) {
              final streamSubscription = _model
                  .cloudFunctionsII?.streamedResponse?.stream
                  .transform(utf8.decoder)
                  .transform(const LineSplitter())
                  .transform(ServerSentEventLineTransformer())
                  .map((m) => ResponseStreamMessage(message: m))
                  .listen(
                (onMessageInput) async {
                  if (getJsonField(
                        onMessageInput.serverSentEvent.jsonData,
                        r'''$..price''',
                      ) !=
                      null) {
                    logFirebaseEvent('_update_page_state');
                    _model.addToReInvestCalcsCombined(
                        onMessageInput.serverSentEvent.jsonData);
                    safeSetState(() {});
                  }
                  if (_model.reInvestCalcsCombined.length == 1) {
                    logFirebaseEvent('_update_page_state');
                    _model.selectedProperty =
                        _model.reInvestCalcsCombined.firstOrNull;
                    safeSetState(() {});
                  }
                },
                onError: (onErrorInput) async {},
                onDone: () async {},
              );
              // Add the subscription to the active streaming response subscriptions
              // in API Manager so that it can be cancelled at a later time.
              ApiManager.instance.addActiveStreamingResponseSubscription(
                'test',
                streamSubscription,
              );
            }
          }(),
        );
      } else {
        logFirebaseEvent('search_backend_call');
        unawaited(
          () async {
            _model.cloudFunctionsGuest =
                await FirebaseCloudFunctionsGroup.cloudCalcsCall.call(
              location: 'Sacramento',
              minPrice: 1000,
              maxPrice: 750000,
              propertyType: 'SINGLE_FAMILY',
              daysOn: 7,
              lotSizeMin: 3000,
              dwnPmtRate: 0.1,
              salRate: 0.04,
              financingRate: 0.1,
              fnfImpRate: 2,
              fnfImpFactor: 1.06,
              twoBedAvgValue: 387500,
              twoBdrmAduCost: 245000,
              newFutValSalperSFRate: 350,
              oneBdrmMarketValue: 50000,
              propertyIns: 900,
              propertyTaxes: 4000,
              fixnflipDuration: 3,
              isInterestOnly: true,
              statusType: 'FOR_SALE',
            );
            if (_model.cloudFunctionsGuest?.succeeded ?? true) {
              final streamSubscription = _model
                  .cloudFunctionsGuest?.streamedResponse?.stream
                  .transform(utf8.decoder)
                  .transform(const LineSplitter())
                  .transform(ServerSentEventLineTransformer())
                  .map((m) => ResponseStreamMessage(message: m))
                  .listen(
                (onMessageInput) async {
                  if (getJsonField(
                        onMessageInput.serverSentEvent.jsonData,
                        r'''$..price''',
                      ) !=
                      null) {
                    logFirebaseEvent('_update_page_state');
                    _model.addToReInvestCalcsCombined(
                        onMessageInput.serverSentEvent.jsonData);
                    safeSetState(() {});
                  }
                  if (_model.reInvestCalcsCombined.length == 1) {
                    logFirebaseEvent('_update_page_state');
                    _model.selectedProperty =
                        _model.reInvestCalcsCombined.firstOrNull;
                    safeSetState(() {});
                  }
                },
                onError: (onErrorInput) async {},
                onDone: () async {},
              );
              // Add the subscription to the active streaming response subscriptions
              // in API Manager so that it can be cancelled at a later time.
              ApiManager.instance.addActiveStreamingResponseSubscription(
                'test',
                streamSubscription,
              );
            }
          }(),
        );
      }
    });

    _model.minimumReturnFocusNode ??= FocusNode();

    _model.dwnPmtRateFocusNode ??= FocusNode();

    _model.financingRateTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.financingRate, 0.0).toString());
    _model.financingRateFocusNode ??= FocusNode();

    _model.propertyInsTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.propertyIns, 0).toString());
    _model.propertyInsFocusNode ??= FocusNode();

    _model.propertyTaxesTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.propertyTaxes, 0).toString());
    _model.propertyTaxesFocusNode ??= FocusNode();

    _model.salRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.salRate, 0.0).toString());
    _model.salRateFocusNode ??= FocusNode();

    _model.oneBdrmMarketValueTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.oneBdrmMarketValue, 0)
            .toString());
    _model.oneBdrmMarketValueFocusNode ??= FocusNode();

    _model.twoBedAvgValueTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.twoBedAvgValue, 0).toString());
    _model.twoBedAvgValueFocusNode ??= FocusNode();

    _model.aduTwoBdrmCostTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.aduTwoBdrmCost, 0).toString());
    _model.aduTwoBdrmCostFocusNode ??= FocusNode();

    _model.newFutValSalperSFRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.newFutValSalperSFRate, 0)
            .toString());
    _model.newFutValSalperSFRateFocusNode ??= FocusNode();

    _model.fixnflipDurationTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.fixnflipDuration, 0)
            .toString());
    _model.fixnflipDurationFocusNode ??= FocusNode();

    _model.fnfImpFactorTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.fnfImpFactor, 0.0).toString());
    _model.fnfImpFactorFocusNode ??= FocusNode();

    _model.fnfImpRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.fnfImpRate, 0).toString());
    _model.fnfImpRateFocusNode ??= FocusNode();

    _model.additionDurationTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.addOnDuration, 0).toString());
    _model.additionDurationFocusNode ??= FocusNode();

    _model.addOnImpFactorTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      formatNumber(
        valueOrDefault(currentUserDocument?.addOnImpFactor, 0.0),
        formatType: FormatType.custom,
        format: ',###',
        locale: '',
      ),
      '1',
    ));
    _model.addOnImpFactorFocusNode ??= FocusNode();

    _model.addOnSqftRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.addOnSqftRate, 0).toString());
    _model.addOnSqftRateFocusNode ??= FocusNode();

    _model.aduDurationTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.aduDuration, 0).toString());
    _model.aduDurationFocusNode ??= FocusNode();

    _model.aduImpFactorTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.aduImpFactor, 0.0).toString());
    _model.aduImpFactorFocusNode ??= FocusNode();

    _model.aduImpRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.aduImpRate, 0).toString());
    _model.aduImpRateFocusNode ??= FocusNode();

    _model.newDurationTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.newDuration, 0).toString());
    _model.newDurationFocusNode ??= FocusNode();

    _model.newImpFactorTextController ??= TextEditingController(
        text:
            valueOrDefault(currentUserDocument?.newImpFactor, 0.0).toString());
    _model.newImpFactorFocusNode ??= FocusNode();

    _model.newBuildRateTextController ??= TextEditingController(
        text: valueOrDefault(currentUserDocument?.newBuildRate, 0).toString());
    _model.newBuildRateFocusNode ??= FocusNode();

    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: true);
    _model.searchFieldTextController1 ??= TextEditingController();
    _model.searchFieldFocusNode1 ??= FocusNode();

    _model.textController24 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController25 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.expandableExpandableController2 =
        ExpandableController(initialExpanded: false);
    _model.searchFieldTextController2 ??= TextEditingController();
    _model.searchFieldFocusNode2 ??= FocusNode();

    _model.textController27 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController28 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      logFirebaseEvent('SEARCH_PAGE_search_ON_DISPOSE');
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Title(
          title: 'getRealDeal.ai',
          color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              endDrawer: StreamBuilder<List<UserDataRecord>>(
                stream: queryUserDataRecord(
                  queryBuilder: (userDataRecord) => userDataRecord.where(
                    'uid',
                    isEqualTo: currentUserUid,
                    isNull: (currentUserUid) == null,
                  ),
                  singleRecord: true,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).secondary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<UserDataRecord> endDrawerUserDataRecordList =
                      snapshot.data!;
                  // Return an empty Container when the item does not exist.
                  if (snapshot.data!.isEmpty) {
                    return Container();
                  }
                  final endDrawerUserDataRecord =
                      endDrawerUserDataRecordList.isNotEmpty
                          ? endDrawerUserDataRecordList.first
                          : null;

                  return Drawer(
                    elevation: 16.0,
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      constraints: BoxConstraints(
                        maxWidth: 800.0,
                      ),
                      decoration: BoxDecoration(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'SEARCH_PAGE_LOGOUT_BTN_ON_TAP');
                                      logFirebaseEvent('Button_auth');
                                      GoRouter.of(context).prepareAuthEvent();
                                      await authManager.signOut();
                                      GoRouter.of(context)
                                          .clearRedirectLocation();

                                      context.goNamedAuth(
                                          SearchWidget.routeName,
                                          context.mounted);
                                    },
                                    text: 'Logout',
                                    icon: Icon(
                                      Icons.logout,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 8.0, 0.0),
                                    child: FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      icon: Icon(
                                        Icons.close,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'SEARCH_PAGE_close_ICN_ON_TAP');
                                        logFirebaseEvent('IconButton_drawer');
                                        if (scaffoldKey
                                                .currentState!.isDrawerOpen ||
                                            scaffoldKey.currentState!
                                                .isEndDrawerOpen) {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Minimum Return',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          width: 100.0,
                                          child: TextFormField(
                                            controller: _model
                                                    .minimumReturnTextController ??=
                                                TextEditingController(
                                              text: endDrawerUserDataRecord
                                                  ?.minimumReturn
                                                  .toString(),
                                            ),
                                            focusNode:
                                                _model.minimumReturnFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.minimumReturnTextController',
                                              Duration(milliseconds: 300),
                                              () async {
                                                logFirebaseEvent(
                                                    'SEARCH_minimumReturn_ON_TEXTFIELD_CHANGE');
                                                logFirebaseEvent(
                                                    'minimumReturn_backend_call');

                                                await currentUserReference!
                                                    .update(
                                                        createUserDataRecordData(
                                                  minimumReturn: int.tryParse(_model
                                                      .minimumReturnTextController
                                                      .text),
                                                ));
                                              },
                                            ),
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              hintText: 'TextField',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.dollarSign,
                                              ),
                                              suffixIcon: _model
                                                      .minimumReturnTextController!
                                                      .text
                                                      .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () async {
                                                        _model
                                                            .minimumReturnTextController
                                                            ?.clear();
                                                        logFirebaseEvent(
                                                            'SEARCH_minimumReturn_ON_TEXTFIELD_CHANGE');
                                                        logFirebaseEvent(
                                                            'minimumReturn_backend_call');

                                                        await currentUserReference!
                                                            .update(
                                                                createUserDataRecordData(
                                                          minimumReturn: int
                                                              .tryParse(_model
                                                                  .minimumReturnTextController
                                                                  .text),
                                                        ));
                                                        safeSetState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        size: 22,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                            textAlign: TextAlign.end,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model
                                                .minimumReturnTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]'))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'Base Rates',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Down Payment %',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          width: 100.0,
                                          child: TextFormField(
                                            controller: _model
                                                    .dwnPmtRateTextController ??=
                                                TextEditingController(
                                              text: endDrawerUserDataRecord
                                                  ?.dwnPmtRate
                                                  .toString(),
                                            ),
                                            focusNode:
                                                _model.dwnPmtRateFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.dwnPmtRateTextController',
                                              Duration(milliseconds: 300),
                                              () async {
                                                logFirebaseEvent(
                                                    'SEARCH_dwnPmtRate_ON_TEXTFIELD_CHANGE');
                                                logFirebaseEvent(
                                                    'dwnPmtRate_backend_call');

                                                await currentUserReference!
                                                    .update(
                                                        createUserDataRecordData(
                                                  dwnPmtRate: double.tryParse(
                                                      _model
                                                          .dwnPmtRateTextController
                                                          .text),
                                                ));
                                              },
                                            ),
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              hintText: 'TextField',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                            textAlign: TextAlign.end,
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model
                                                .dwnPmtRateTextControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Financing Rate',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 100.0,
                                            child: TextFormField(
                                              controller: _model
                                                  .financingRateTextController,
                                              focusNode:
                                                  _model.financingRateFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.financingRateTextController',
                                                Duration(milliseconds: 300),
                                                () async {
                                                  logFirebaseEvent(
                                                      'SEARCH_financingRate_ON_TEXTFIELD_CHANGE');
                                                  logFirebaseEvent(
                                                      'financingRate_backend_call');

                                                  await currentUserReference!
                                                      .update(
                                                          createUserDataRecordData(
                                                    financingRate:
                                                        double.tryParse(_model
                                                            .financingRateTextController
                                                            .text),
                                                  ));
                                                },
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                hintText: 'TextField',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                              textAlign: TextAlign.end,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              validator: _model
                                                  .financingRateTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ppty Insurance',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(),
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: AuthUserStreamWidget(
                                        builder: (context) => Container(
                                          width: 100.0,
                                          child: TextFormField(
                                            controller: _model
                                                .propertyInsTextController,
                                            focusNode:
                                                _model.propertyInsFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.propertyInsTextController',
                                              Duration(milliseconds: 300),
                                              () async {
                                                logFirebaseEvent(
                                                    'SEARCH_propertyIns_ON_TEXTFIELD_CHANGE');
                                                logFirebaseEvent(
                                                    'propertyIns_backend_call');

                                                await currentUserReference!
                                                    .update(
                                                        createUserDataRecordData(
                                                  propertyIns: int.tryParse(_model
                                                      .propertyInsTextController
                                                      .text),
                                                ));
                                              },
                                            ),
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              hintText: 'TextField',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                            textAlign: TextAlign.end,
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model
                                                .propertyInsTextControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ppty Taxes',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 100.0,
                                            child: TextFormField(
                                              controller: _model
                                                  .propertyTaxesTextController,
                                              focusNode:
                                                  _model.propertyTaxesFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.propertyTaxesTextController',
                                                Duration(milliseconds: 300),
                                                () async {
                                                  logFirebaseEvent(
                                                      'SEARCH_propertyTaxes_ON_TEXTFIELD_CHANGE');
                                                  logFirebaseEvent(
                                                      'propertyTaxes_backend_call');

                                                  await currentUserReference!
                                                      .update(
                                                          createUserDataRecordData(
                                                    propertyTaxes: int.tryParse(
                                                        _model
                                                            .propertyTaxesTextController
                                                            .text),
                                                  ));
                                                },
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                hintText: 'TextField',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                              textAlign: TextAlign.end,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              validator: _model
                                                  .propertyTaxesTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Sales Rate',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 100.0,
                                            child: TextFormField(
                                              controller:
                                                  _model.salRateTextController,
                                              focusNode:
                                                  _model.salRateFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.salRateTextController',
                                                Duration(milliseconds: 300),
                                                () async {
                                                  logFirebaseEvent(
                                                      'SEARCH_PAGE_salRate_ON_TEXTFIELD_CHANGE');
                                                  logFirebaseEvent(
                                                      'salRate_backend_call');

                                                  await currentUserReference!
                                                      .update(
                                                          createUserDataRecordData(
                                                    salRate: double.tryParse(
                                                        _model
                                                            .salRateTextController
                                                            .text),
                                                  ));
                                                },
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                hintText: 'TextField',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                              textAlign: TextAlign.end,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              validator: _model
                                                  .salRateTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'Market Rates',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '1 Bed Avg Value',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(),
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 100.0,
                                            child: TextFormField(
                                              controller: _model
                                                  .oneBdrmMarketValueTextController,
                                              focusNode: _model
                                                  .oneBdrmMarketValueFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.oneBdrmMarketValueTextController',
                                                Duration(milliseconds: 300),
                                                () async {
                                                  logFirebaseEvent(
                                                      'SEARCH_oneBdrmMarketValue_ON_TEXTFIELD_C');
                                                  logFirebaseEvent(
                                                      'oneBdrmMarketValue_backend_call');

                                                  await currentUserReference!
                                                      .update(
                                                          createUserDataRecordData(
                                                    oneBdrmMarketValue:
                                                        int.tryParse(_model
                                                            .oneBdrmMarketValueTextController
                                                            .text),
                                                  ));
                                                },
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                hintText: 'TextField',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                              textAlign: TextAlign.end,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              validator: _model
                                                  .oneBdrmMarketValueTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '2 Bed Avg Value',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 100.0,
                                            child: TextFormField(
                                              controller: _model
                                                  .twoBedAvgValueTextController,
                                              focusNode: _model
                                                  .twoBedAvgValueFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.twoBedAvgValueTextController',
                                                Duration(milliseconds: 300),
                                                () async {
                                                  logFirebaseEvent(
                                                      'SEARCH_twoBedAvgValue_ON_TEXTFIELD_CHANG');
                                                  logFirebaseEvent(
                                                      'twoBedAvgValue_backend_call');

                                                  await currentUserReference!
                                                      .update(
                                                          createUserDataRecordData(
                                                    twoBedAvgValue:
                                                        int.tryParse(_model
                                                            .twoBedAvgValueTextController
                                                            .text),
                                                  ));
                                                },
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                hintText: 'TextField',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                              textAlign: TextAlign.end,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              validator: _model
                                                  .twoBedAvgValueTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ADU 2 Bdrm Cost',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .aduTwoBdrmCostTextController,
                                                focusNode: _model
                                                    .aduTwoBdrmCostFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.aduTwoBdrmCostTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_aduTwoBdrmCost_ON_TEXTFIELD_CHANG');
                                                    logFirebaseEvent(
                                                        'aduTwoBdrmCost_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      aduTwoBdrmCost:
                                                          int.tryParse(_model
                                                              .aduTwoBdrmCostTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .aduTwoBdrmCostTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'New Home Value \$/SF',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .newFutValSalperSFRateTextController,
                                                focusNode: _model
                                                    .newFutValSalperSFRateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.newFutValSalperSFRateTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_newFutValSalperSFRate_ON_TEXTFIEL');
                                                    logFirebaseEvent(
                                                        'newFutValSalperSFRate_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      newFutValSalperSFRate:
                                                          int.tryParse(_model
                                                              .newFutValSalperSFRateTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .newFutValSalperSFRateTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'Fix\'N Flip',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Duration - Fix \'n Flip',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .fixnflipDurationTextController,
                                                focusNode: _model
                                                    .fixnflipDurationFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.fixnflipDurationTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_fixnflipDuration_ON_TEXTFIELD_CHA');
                                                    logFirebaseEvent(
                                                        'fixnflipDuration_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      fixnflipDuration:
                                                          int.tryParse(_model
                                                              .fixnflipDurationTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .fixnflipDurationTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Factor - F\'nF',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .fnfImpFactorTextController,
                                                focusNode: _model
                                                    .fnfImpFactorFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.fnfImpFactorTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_fnfImpFactor_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'fnfImpFactor_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      fnfImpFactor:
                                                          double.tryParse(_model
                                                              .fnfImpFactorTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .fnfImpFactorTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Rate -F\'nF',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .fnfImpRateTextController,
                                                focusNode:
                                                    _model.fnfImpRateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.fnfImpRateTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_fnfImpRate_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'fnfImpRate_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      fnfImpRate: int.tryParse(
                                                          _model
                                                              .fnfImpRateTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .fnfImpRateTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'Add-on',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Duration - Add-on',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .additionDurationTextController,
                                                focusNode: _model
                                                    .additionDurationFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.additionDurationTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_additionDuration_ON_TEXTFIELD_CHA');
                                                    logFirebaseEvent(
                                                        'additionDuration_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      addOnDuration:
                                                          int.tryParse(_model
                                                              .additionDurationTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .additionDurationTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Factor - Add-on',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .addOnImpFactorTextController,
                                                focusNode: _model
                                                    .addOnImpFactorFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.addOnImpFactorTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_addOnImpFactor_ON_TEXTFIELD_CHANG');
                                                    logFirebaseEvent(
                                                        'addOnImpFactor_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      addOnImpFactor:
                                                          double.tryParse(_model
                                                              .addOnImpFactorTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .addOnImpFactorTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Rate - Add-on',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .addOnSqftRateTextController,
                                                focusNode: _model
                                                    .addOnSqftRateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.addOnSqftRateTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_addOnSqftRate_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'addOnSqftRate_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      addOnSqftRate:
                                                          int.tryParse(_model
                                                              .addOnSqftRateTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .addOnSqftRateTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'ADU',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Duration - ADU',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .aduDurationTextController,
                                                focusNode:
                                                    _model.aduDurationFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.aduDurationTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_aduDuration_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'aduDuration_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      aduDuration: int.tryParse(
                                                          _model
                                                              .aduDurationTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .aduDurationTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Factor - ADU',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .aduImpFactorTextController,
                                                focusNode: _model
                                                    .aduImpFactorFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.aduImpFactorTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_aduImpFactor_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'aduImpFactor_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      aduImpFactor:
                                                          double.tryParse(_model
                                                              .aduImpFactorTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .aduImpFactorTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Rate - ADU',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .aduImpRateTextController,
                                                focusNode:
                                                    _model.aduImpRateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.aduImpRateTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_aduImpRate_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'aduImpRate_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      aduImpRate: int.tryParse(
                                                          _model
                                                              .aduImpRateTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .aduImpRateTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'New',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Duration  - New',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .newDurationTextController,
                                                focusNode:
                                                    _model.newDurationFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.newDurationTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_newDuration_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'newDuration_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      newDuration: int.tryParse(
                                                          _model
                                                              .newDurationTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .newDurationTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Factor - New',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .newImpFactorTextController,
                                                focusNode: _model
                                                    .newImpFactorFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.newImpFactorTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_newImpFactor_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'newImpFactor_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      newImpFactor:
                                                          double.tryParse(_model
                                                              .newImpFactorTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .newImpFactorTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Improv\'t Rate - New',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 100.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .newBuildRateTextController,
                                                focusNode: _model
                                                    .newBuildRateFocusNode,
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  '_model.newBuildRateTextController',
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                    logFirebaseEvent(
                                                        'SEARCH_newBuildRate_ON_TEXTFIELD_CHANGE');
                                                    logFirebaseEvent(
                                                        'newBuildRate_backend_call');

                                                    await currentUserReference!
                                                        .update(
                                                            createUserDataRecordData(
                                                      newBuildRate:
                                                          int.tryParse(_model
                                                              .newBuildRateTextController
                                                              .text),
                                                    ));
                                                  },
                                                ),
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  hintText: 'TextField',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                textAlign: TextAlign.end,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .newBuildRateTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0),
                child: AppBar(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  iconTheme: IconThemeData(color: Color(0xE6053C6E)),
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (responsiveVisibility(
                        context: context,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'REAL DEAL',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.audiowide(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    color: Color(0xE6053C6E),
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation1']!),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 4.0),
                              child: Text(
                                'Real Estate Deals Revealed',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation2']!),
                            ),
                          ],
                        ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                      ))
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'REAL DEAL',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.audiowide(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    color: Color(0xE6053C6E),
                                    fontSize: 30.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation3']!),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 4.0),
                              child: Text(
                                'Real Estate Deals Revealed',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation4']!),
                            ),
                          ],
                        ),
                    ],
                  ),
                  actions: [
                    Visibility(
                      visible: loggedIn,
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 12.0),
                          child: AuthUserStreamWidget(
                            builder: (context) => FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent(
                                    'SEARCH_PAGE_Button_kr5avcut_ON_TAP');
                                logFirebaseEvent('Button_alert_dialog');
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(dialogContext)
                                              .unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: BuyTokensWidget(),
                                      ),
                                    );
                                  },
                                );
                              },
                              text: '${formatNumber(
                                valueOrDefault(currentUserDocument?.tokens, 0),
                                formatType: FormatType.decimal,
                                decimalType: DecimalType.automatic,
                              )} token',
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 30.0,
                              ),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconAlignment: IconAlignment.end,
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).secondary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: loggedIn,
                      child: Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: FlutterFlowIconButton(
                            borderRadius: 60.0,
                            buttonSize: 60.0,
                            fillColor: FlutterFlowTheme.of(context).secondary,
                            icon: Icon(
                              Icons.person_outlined,
                              color: FlutterFlowTheme.of(context).info,
                              size: 28.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'SEARCH_PAGE_person_outlined_ICN_ON_TAP');
                              logFirebaseEvent('IconButton_drawer');
                              scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                  centerTitle: () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return true;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointMedium) {
                      return false;
                    } else if (MediaQuery.sizeOf(context).width <
                        kBreakpointLarge) {
                      return false;
                    } else {
                      return false;
                    }
                  }(),
                  toolbarHeight: 70.0,
                  elevation: 0.0,
                ),
              ),
              body: Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                      ))
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 0.0, 12.0),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 340.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: Color(0x40000000),
                                          offset: Offset(
                                            0.0,
                                            5.0,
                                          ),
                                          spreadRadius: 0.0,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: Color(0x00000000),
                                      child: ExpandableNotifier(
                                        controller: _model
                                            .expandableExpandableController1,
                                        child: ExpandablePanel(
                                          header: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  width: 200.0,
                                                  child: TextFormField(
                                                    controller: _model
                                                        .searchFieldTextController1,
                                                    focusNode: _model
                                                        .searchFieldFocusNode1,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      '_model.searchFieldTextController1',
                                                      Duration(
                                                          milliseconds: 600),
                                                      () async {
                                                        logFirebaseEvent(
                                                            'SEARCH_SearchField_ON_TEXTFIELD_CHANGE');
                                                        logFirebaseEvent(
                                                            'SearchField_update_page_state');
                                                        _model.selectedProperty =
                                                            null;
                                                        _model.searchCounter =
                                                            0;
                                                        _model.searchReinvestCalcsComb =
                                                            [];
                                                        _model.searchPptyDetails =
                                                            [];
                                                        _model.reInvestCalcsCombined =
                                                            [];
                                                        safeSetState(() {});
                                                        logFirebaseEvent(
                                                            'SearchField_cancel_streaming_response_su');
                                                        await ApiManager
                                                            .instance
                                                            .cancelActiveStreamingResponseSubscription(
                                                          'test',
                                                        );

                                                        logFirebaseEvent(
                                                            'SearchField_cancel_streaming_response_su');
                                                        await ApiManager
                                                            .instance
                                                            .cancelActiveStreamingResponseSubscription(
                                                          'search',
                                                        );

                                                        logFirebaseEvent(
                                                            'SearchField_backend_call');
                                                        _model.cloudFunctionsSearchOnChange =
                                                            await FirebaseCloudFunctionsGroup
                                                                .cloudCalcsCall
                                                                .call(
                                                          location: _model
                                                              .searchFieldTextController1
                                                              .text,
                                                          minPrice:
                                                              valueOrDefault<
                                                                  int>(
                                                            int.tryParse(_model
                                                                .textController24
                                                                .text),
                                                            10000,
                                                          ),
                                                          maxPrice:
                                                              valueOrDefault<
                                                                  int>(
                                                            int.tryParse(_model
                                                                .textController25
                                                                .text),
                                                            750000,
                                                          ),
                                                          propertyType:
                                                              'SINGLE_FAMILY',
                                                          daysOn: 7,
                                                          lotSizeMin: 3000,
                                                          dwnPmtRate:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.dwnPmtRate,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          salRate:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.salRate,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          financingRate:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.financingRate,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          taxInsRate:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.taxInsRate,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          fnfImpRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.fnfImpRate,
                                                              0),
                                                          aduImpRate:
                                                              valueOrDefault<
                                                                  int>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.aduImpRate,
                                                                0),
                                                            1,
                                                          ),
                                                          newImpRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newBuildRate,
                                                              0),
                                                          fnfImpFactor:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.fnfImpFactor,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          twoBedAvgValue:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.twoBedAvgValue,
                                                                  0),
                                                          twoBdrmAduCost:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.aduTwoBdrmCost,
                                                                  0),
                                                          newFutValSalperSFRate:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.newFutValSalperSFRate,
                                                                  0),
                                                          oneBdrmMarketValue:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.oneBdrmMarketValue,
                                                                  0),
                                                          loanFeesRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.loanFeesRate,
                                                              0.0),
                                                          propertyIns: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.propertyIns,
                                                              0),
                                                          propertyTaxes: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.propertyTaxes,
                                                              0),
                                                          permitsFees: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.permitsFees,
                                                              0),
                                                          fixnflipDuration:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.fixnflipDuration,
                                                                  0),
                                                          addOnDuration: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnDuration,
                                                              0),
                                                          aduDuration: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduDuration,
                                                              0),
                                                          newDuration: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newDuration,
                                                              0),
                                                          newBuildRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newBuildRate,
                                                              0),
                                                          isInterestOnly: true,
                                                          addOnSqftRate:
                                                              valueOrDefault<
                                                                  int>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.addOnSqftRate,
                                                                0),
                                                            1,
                                                          ),
                                                          addOnImpFactor:
                                                              valueOrDefault<
                                                                  double>(
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.addOnImpFactor,
                                                                0.0),
                                                            1.0,
                                                          ),
                                                          addOnBeds: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnBeds,
                                                              0),
                                                          addOnBaths: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnBaths,
                                                              0),
                                                          aduBeds: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduBaths,
                                                              0),
                                                          aduBaths: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduBaths,
                                                              0),
                                                          aduArea: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduArea,
                                                              0),
                                                          newArea: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newArea,
                                                              0),
                                                          newBeds: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newBeds,
                                                              0),
                                                          newBaths: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newBaths,
                                                              0),
                                                          statusType:
                                                              'FOR_SALE',
                                                          addOnArea: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnArea,
                                                              0),
                                                          addOnRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnSqftRate,
                                                              0),
                                                          aduImpFactor: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduImpFactor,
                                                              0.0),
                                                          maintenanceRate:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.maintenanceRate,
                                                                  0),
                                                          newImpFactor: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.newImpFactor,
                                                              0.0),
                                                          operatingExpenseRate:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.operatingExpenseRate,
                                                                  0),
                                                          propertyManagementFeeRate:
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.propertyManagementFeeRate,
                                                                  0.0),
                                                          vacanyRate: valueOrDefault(
                                                              currentUserDocument
                                                                  ?.vacanyRate,
                                                              0.0),
                                                        );
                                                        if (_model
                                                                .cloudFunctionsSearchOnChange
                                                                ?.succeeded ??
                                                            true) {
                                                          final streamSubscription = _model
                                                              .cloudFunctionsSearchOnChange
                                                              ?.streamedResponse
                                                              ?.stream
                                                              .transform(
                                                                  utf8.decoder)
                                                              .transform(
                                                                  const LineSplitter())
                                                              .transform(
                                                                  ServerSentEventLineTransformer())
                                                              .map((m) =>
                                                                  ResponseStreamMessage(
                                                                      message:
                                                                          m))
                                                              .listen(
                                                            (onMessageInput) async {
                                                              if (getJsonField(
                                                                    onMessageInput
                                                                        .serverSentEvent
                                                                        .jsonData,
                                                                    r'''$..price''',
                                                                  ) !=
                                                                  null) {
                                                                if (_model
                                                                    .searchReinvestCalcsComb
                                                                    .isNotEmpty) {
                                                                  logFirebaseEvent(
                                                                      '_update_page_state');
                                                                  _model.addToSearchReinvestCalcsComb(
                                                                      onMessageInput
                                                                          .serverSentEvent
                                                                          .jsonData);
                                                                  _model.mapCoordinates =
                                                                      functions.convertToLatLng(
                                                                          getJsonField(
                                                                            onMessageInput.serverSentEvent.jsonData,
                                                                            r'''$.latlng.latitude''',
                                                                          ),
                                                                          getJsonField(
                                                                            onMessageInput.serverSentEvent.jsonData,
                                                                            r'''$.latlng.longitude''',
                                                                          ));
                                                                  safeSetState(
                                                                      () {});
                                                                } else {
                                                                  logFirebaseEvent(
                                                                      '_update_page_state');
                                                                  _model.addToSearchReinvestCalcsComb(
                                                                      onMessageInput
                                                                          .serverSentEvent
                                                                          .jsonData);
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                              }
                                                            },
                                                            onError:
                                                                (onErrorInput) async {
                                                              logFirebaseEvent(
                                                                  '_alert_dialog');
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'ERROR'),
                                                                    content: Text(
                                                                        onErrorInput!),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            onDone: () async {
                                                              if (!(_model
                                                                  .searchReinvestCalcsComb
                                                                  .isNotEmpty)) {
                                                                logFirebaseEvent(
                                                                    '_alert_dialog');
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Error'),
                                                                      content: Text(
                                                                          'No properties found'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                          );
                                                          // Add the subscription to the active streaming response subscriptions
                                                          // in API Manager so that it can be cancelled at a later time.
                                                          ApiManager.instance
                                                              .addActiveStreamingResponseSubscription(
                                                            'search',
                                                            streamSubscription,
                                                          );
                                                        }

                                                        safeSetState(() {});
                                                      },
                                                    ),
                                                    onFieldSubmitted:
                                                        (_) async {
                                                      logFirebaseEvent(
                                                          'SEARCH_SearchField_ON_TEXTFIELD_SUBMIT');
                                                      logFirebaseEvent(
                                                          'SearchField_update_page_state');
                                                      _model.selectedProperty =
                                                          null;
                                                      _model.searchCounter = 0;
                                                      _model.searchReinvestCalcsComb =
                                                          [];
                                                      _model.searchPptyDetails =
                                                          [];
                                                      safeSetState(() {});
                                                      logFirebaseEvent(
                                                          'SearchField_cancel_streaming_response_su');
                                                      await ApiManager.instance
                                                          .cancelActiveStreamingResponseSubscription(
                                                        'test',
                                                      );

                                                      logFirebaseEvent(
                                                          'SearchField_cancel_streaming_response_su');
                                                      await ApiManager.instance
                                                          .cancelActiveStreamingResponseSubscription(
                                                        'search',
                                                      );

                                                      logFirebaseEvent(
                                                          'SearchField_backend_call');
                                                      _model.cloudFunctionsSearch =
                                                          await FirebaseCloudFunctionsGroup
                                                              .cloudCalcsCall
                                                              .call(
                                                        location: _model
                                                            .searchFieldTextController1
                                                            .text,
                                                        minPrice:
                                                            valueOrDefault<int>(
                                                          int.tryParse(_model
                                                              .textController24
                                                              .text),
                                                          1000,
                                                        ),
                                                        maxPrice:
                                                            valueOrDefault<int>(
                                                          int.tryParse(_model
                                                              .textController25
                                                              .text),
                                                          750000,
                                                        ),
                                                        propertyType:
                                                            'SINGLE_FAMILY',
                                                        daysOn: 7,
                                                        lotSizeMin: 3000,
                                                        dwnPmtRate:
                                                            valueOrDefault<
                                                                double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.dwnPmtRate,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        salRate: valueOrDefault<
                                                            double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.salRate,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        financingRate:
                                                            valueOrDefault<
                                                                double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.financingRate,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        taxInsRate:
                                                            valueOrDefault<
                                                                double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.taxInsRate,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        fnfImpRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.fnfImpRate,
                                                            0),
                                                        aduImpRate:
                                                            valueOrDefault<int>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.aduImpRate,
                                                              0),
                                                          1,
                                                        ),
                                                        newImpRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newBuildRate,
                                                            0),
                                                        fnfImpFactor:
                                                            valueOrDefault<
                                                                double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.fnfImpFactor,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        twoBedAvgValue: valueOrDefault(
                                                            currentUserDocument
                                                                ?.twoBedAvgValue,
                                                            0),
                                                        twoBdrmAduCost: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduTwoBdrmCost,
                                                            0),
                                                        newFutValSalperSFRate:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.newFutValSalperSFRate,
                                                                0),
                                                        oneBdrmMarketValue:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.oneBdrmMarketValue,
                                                                0),
                                                        loanFeesRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.loanFeesRate,
                                                            0.0),
                                                        propertyIns: valueOrDefault(
                                                            currentUserDocument
                                                                ?.propertyIns,
                                                            0),
                                                        propertyTaxes: valueOrDefault(
                                                            currentUserDocument
                                                                ?.propertyTaxes,
                                                            0),
                                                        permitsFees: valueOrDefault(
                                                            currentUserDocument
                                                                ?.permitsFees,
                                                            0),
                                                        fixnflipDuration:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.fixnflipDuration,
                                                                0),
                                                        addOnDuration: valueOrDefault(
                                                            currentUserDocument
                                                                ?.addOnDuration,
                                                            0),
                                                        aduDuration: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduDuration,
                                                            0),
                                                        newDuration: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newDuration,
                                                            0),
                                                        newBuildRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newBuildRate,
                                                            0),
                                                        isInterestOnly: true,
                                                        addOnSqftRate:
                                                            valueOrDefault<int>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnSqftRate,
                                                              0),
                                                          1,
                                                        ),
                                                        addOnImpFactor:
                                                            valueOrDefault<
                                                                double>(
                                                          valueOrDefault(
                                                              currentUserDocument
                                                                  ?.addOnImpFactor,
                                                              0.0),
                                                          1.0,
                                                        ),
                                                        addOnBeds: valueOrDefault(
                                                            currentUserDocument
                                                                ?.addOnBeds,
                                                            0),
                                                        addOnBaths: valueOrDefault(
                                                            currentUserDocument
                                                                ?.addOnBaths,
                                                            0),
                                                        aduBeds: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduBaths,
                                                            0),
                                                        aduBaths: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduBaths,
                                                            0),
                                                        aduArea: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduArea,
                                                            0),
                                                        newArea: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newArea,
                                                            0),
                                                        newBeds: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newBeds,
                                                            0),
                                                        newBaths: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newBaths,
                                                            0),
                                                        statusType: 'FOR_SALE',
                                                        addOnArea: valueOrDefault(
                                                            currentUserDocument
                                                                ?.addOnArea,
                                                            0),
                                                        addOnRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.addOnSqftRate,
                                                            0),
                                                        aduImpFactor: valueOrDefault(
                                                            currentUserDocument
                                                                ?.aduImpFactor,
                                                            0.0),
                                                        maintenanceRate:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.maintenanceRate,
                                                                0),
                                                        newImpFactor: valueOrDefault(
                                                            currentUserDocument
                                                                ?.newImpFactor,
                                                            0.0),
                                                        operatingExpenseRate:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.operatingExpenseRate,
                                                                0),
                                                        propertyManagementFeeRate:
                                                            valueOrDefault(
                                                                currentUserDocument
                                                                    ?.propertyManagementFeeRate,
                                                                0.0),
                                                        vacanyRate: valueOrDefault(
                                                            currentUserDocument
                                                                ?.vacanyRate,
                                                            0.0),
                                                      );
                                                      if (_model
                                                              .cloudFunctionsSearch
                                                              ?.succeeded ??
                                                          true) {
                                                        final streamSubscription = _model
                                                            .cloudFunctionsSearch
                                                            ?.streamedResponse
                                                            ?.stream
                                                            .transform(
                                                                utf8.decoder)
                                                            .transform(
                                                                const LineSplitter())
                                                            .transform(
                                                                ServerSentEventLineTransformer())
                                                            .map((m) =>
                                                                ResponseStreamMessage(
                                                                    message: m))
                                                            .listen(
                                                          (onMessageInput) async {
                                                            if (getJsonField(
                                                                  onMessageInput
                                                                      .serverSentEvent
                                                                      .jsonData,
                                                                  r'''$..price''',
                                                                ) !=
                                                                null) {
                                                              logFirebaseEvent(
                                                                  '_update_page_state');
                                                              _model.addToSearchReinvestCalcsComb(
                                                                  onMessageInput
                                                                      .serverSentEvent
                                                                      .jsonData);
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                          },
                                                          onError:
                                                              (onErrorInput) async {
                                                            logFirebaseEvent(
                                                                '_alert_dialog');
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'ERROR'),
                                                                  content: Text(
                                                                      onErrorInput!),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          onDone: () async {},
                                                        );
                                                        // Add the subscription to the active streaming response subscriptions
                                                        // in API Manager so that it can be cancelled at a later time.
                                                        ApiManager.instance
                                                            .addActiveStreamingResponseSubscription(
                                                          'search',
                                                          streamSubscription,
                                                        );
                                                      }

                                                      safeSetState(() {});
                                                    },
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: 'Search a city',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                                color: Color(
                                                                    0xFF1D4F7D),
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMediumIsCustom,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    43.68),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    43.68),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    43.68),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    43.68),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      prefixIcon: Icon(
                                                        Icons.search,
                                                        color:
                                                            Color(0xFF1D4F7D),
                                                      ),
                                                      suffixIcon: _model
                                                              .searchFieldTextController1!
                                                              .text
                                                              .isNotEmpty
                                                          ? InkWell(
                                                              onTap: () async {
                                                                _model
                                                                    .searchFieldTextController1
                                                                    ?.clear();
                                                                logFirebaseEvent(
                                                                    'SEARCH_SearchField_ON_TEXTFIELD_CHANGE');
                                                                logFirebaseEvent(
                                                                    'SearchField_update_page_state');
                                                                _model.selectedProperty =
                                                                    null;
                                                                _model.searchCounter =
                                                                    0;
                                                                _model.searchReinvestCalcsComb =
                                                                    [];
                                                                _model.searchPptyDetails =
                                                                    [];
                                                                _model.reInvestCalcsCombined =
                                                                    [];
                                                                safeSetState(
                                                                    () {});
                                                                logFirebaseEvent(
                                                                    'SearchField_cancel_streaming_response_su');
                                                                await ApiManager
                                                                    .instance
                                                                    .cancelActiveStreamingResponseSubscription(
                                                                  'test',
                                                                );

                                                                logFirebaseEvent(
                                                                    'SearchField_cancel_streaming_response_su');
                                                                await ApiManager
                                                                    .instance
                                                                    .cancelActiveStreamingResponseSubscription(
                                                                  'search',
                                                                );

                                                                logFirebaseEvent(
                                                                    'SearchField_backend_call');
                                                                _model.cloudFunctionsSearchOnChange =
                                                                    await FirebaseCloudFunctionsGroup
                                                                        .cloudCalcsCall
                                                                        .call(
                                                                  location: _model
                                                                      .searchFieldTextController1
                                                                      .text,
                                                                  minPrice:
                                                                      valueOrDefault<
                                                                          int>(
                                                                    int.tryParse(_model
                                                                        .textController24
                                                                        .text),
                                                                    10000,
                                                                  ),
                                                                  maxPrice:
                                                                      valueOrDefault<
                                                                          int>(
                                                                    int.tryParse(_model
                                                                        .textController25
                                                                        .text),
                                                                    750000,
                                                                  ),
                                                                  propertyType:
                                                                      'SINGLE_FAMILY',
                                                                  daysOn: 7,
                                                                  lotSizeMin:
                                                                      3000,
                                                                  dwnPmtRate:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.dwnPmtRate,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  salRate:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.salRate,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  financingRate:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.financingRate,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  taxInsRate:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.taxInsRate,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  fnfImpRate: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.fnfImpRate,
                                                                      0),
                                                                  aduImpRate:
                                                                      valueOrDefault<
                                                                          int>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.aduImpRate,
                                                                        0),
                                                                    1,
                                                                  ),
                                                                  newImpRate: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.newBuildRate,
                                                                      0),
                                                                  fnfImpFactor:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.fnfImpFactor,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  twoBedAvgValue:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.twoBedAvgValue,
                                                                          0),
                                                                  twoBdrmAduCost:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.aduTwoBdrmCost,
                                                                          0),
                                                                  newFutValSalperSFRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.newFutValSalperSFRate,
                                                                          0),
                                                                  oneBdrmMarketValue:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.oneBdrmMarketValue,
                                                                          0),
                                                                  loanFeesRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.loanFeesRate,
                                                                          0.0),
                                                                  propertyIns:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.propertyIns,
                                                                          0),
                                                                  propertyTaxes:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.propertyTaxes,
                                                                          0),
                                                                  permitsFees:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.permitsFees,
                                                                          0),
                                                                  fixnflipDuration:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.fixnflipDuration,
                                                                          0),
                                                                  addOnDuration:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.addOnDuration,
                                                                          0),
                                                                  aduDuration:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.aduDuration,
                                                                          0),
                                                                  newDuration:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.newDuration,
                                                                          0),
                                                                  newBuildRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.newBuildRate,
                                                                          0),
                                                                  isInterestOnly:
                                                                      true,
                                                                  addOnSqftRate:
                                                                      valueOrDefault<
                                                                          int>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.addOnSqftRate,
                                                                        0),
                                                                    1,
                                                                  ),
                                                                  addOnImpFactor:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    valueOrDefault(
                                                                        currentUserDocument
                                                                            ?.addOnImpFactor,
                                                                        0.0),
                                                                    1.0,
                                                                  ),
                                                                  addOnBeds: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.addOnBeds,
                                                                      0),
                                                                  addOnBaths: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.addOnBaths,
                                                                      0),
                                                                  aduBeds: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.aduBaths,
                                                                      0),
                                                                  aduBaths: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.aduBaths,
                                                                      0),
                                                                  aduArea: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.aduArea,
                                                                      0),
                                                                  newArea: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.newArea,
                                                                      0),
                                                                  newBeds: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.newBeds,
                                                                      0),
                                                                  newBaths: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.newBaths,
                                                                      0),
                                                                  statusType:
                                                                      'FOR_SALE',
                                                                  addOnArea: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.addOnArea,
                                                                      0),
                                                                  addOnRate: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.addOnSqftRate,
                                                                      0),
                                                                  aduImpFactor:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.aduImpFactor,
                                                                          0.0),
                                                                  maintenanceRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.maintenanceRate,
                                                                          0),
                                                                  newImpFactor:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.newImpFactor,
                                                                          0.0),
                                                                  operatingExpenseRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.operatingExpenseRate,
                                                                          0),
                                                                  propertyManagementFeeRate:
                                                                      valueOrDefault(
                                                                          currentUserDocument
                                                                              ?.propertyManagementFeeRate,
                                                                          0.0),
                                                                  vacanyRate: valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.vacanyRate,
                                                                      0.0),
                                                                );
                                                                if (_model
                                                                        .cloudFunctionsSearchOnChange
                                                                        ?.succeeded ??
                                                                    true) {
                                                                  final streamSubscription = _model
                                                                      .cloudFunctionsSearchOnChange
                                                                      ?.streamedResponse
                                                                      ?.stream
                                                                      .transform(utf8
                                                                          .decoder)
                                                                      .transform(
                                                                          const LineSplitter())
                                                                      .transform(
                                                                          ServerSentEventLineTransformer())
                                                                      .map((m) =>
                                                                          ResponseStreamMessage(
                                                                              message: m))
                                                                      .listen(
                                                                    (onMessageInput) async {
                                                                      if (getJsonField(
                                                                            onMessageInput.serverSentEvent.jsonData,
                                                                            r'''$..price''',
                                                                          ) !=
                                                                          null) {
                                                                        if (_model
                                                                            .searchReinvestCalcsComb
                                                                            .isNotEmpty) {
                                                                          logFirebaseEvent(
                                                                              '_update_page_state');
                                                                          _model.addToSearchReinvestCalcsComb(onMessageInput
                                                                              .serverSentEvent
                                                                              .jsonData);
                                                                          _model.mapCoordinates = functions.convertToLatLng(
                                                                              getJsonField(
                                                                                onMessageInput.serverSentEvent.jsonData,
                                                                                r'''$.latlng.latitude''',
                                                                              ),
                                                                              getJsonField(
                                                                                onMessageInput.serverSentEvent.jsonData,
                                                                                r'''$.latlng.longitude''',
                                                                              ));
                                                                          safeSetState(
                                                                              () {});
                                                                        } else {
                                                                          logFirebaseEvent(
                                                                              '_update_page_state');
                                                                          _model.addToSearchReinvestCalcsComb(onMessageInput
                                                                              .serverSentEvent
                                                                              .jsonData);
                                                                          safeSetState(
                                                                              () {});
                                                                        }
                                                                      }
                                                                    },
                                                                    onError:
                                                                        (onErrorInput) async {
                                                                      logFirebaseEvent(
                                                                          '_alert_dialog');
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('ERROR'),
                                                                            content:
                                                                                Text(onErrorInput!),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                child: Text('Ok'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    onDone:
                                                                        () async {
                                                                      if (!(_model
                                                                          .searchReinvestCalcsComb
                                                                          .isNotEmpty)) {
                                                                        logFirebaseEvent(
                                                                            '_alert_dialog');
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (alertDialogContext) {
                                                                            return AlertDialog(
                                                                              title: Text('Error'),
                                                                              content: Text('No properties found'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(alertDialogContext),
                                                                                  child: Text('Ok'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                  );
                                                                  // Add the subscription to the active streaming response subscriptions
                                                                  // in API Manager so that it can be cancelled at a later time.
                                                                  ApiManager
                                                                      .instance
                                                                      .addActiveStreamingResponseSubscription(
                                                                    'search',
                                                                    streamSubscription,
                                                                  );
                                                                }

                                                                safeSetState(
                                                                    () {});
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Icon(
                                                                Icons.clear,
                                                                size: 22,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                    cursorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    validator: _model
                                                        .searchFieldTextController1Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          collapsed: Container(),
                                          expanded: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: 200.0,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController24,
                                                        focusNode: _model
                                                            .textFieldFocusNode1,
                                                        autofocus: false,
                                                        textInputAction:
                                                            TextInputAction
                                                                .search,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          hintText: 'min',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .labelMediumIsCustom,
                                                                  ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .dollarSign,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal: true),
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        validator: _model
                                                            .textController24Validator
                                                            .asValidator(
                                                                context),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  '[0-9]'))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: 200.0,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController25,
                                                        focusNode: _model
                                                            .textFieldFocusNode2,
                                                        autofocus: false,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .labelMediumIsCustom,
                                                                  ),
                                                          hintText: 'max',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .labelMediumIsCustom,
                                                                  ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .dollarSign,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        validator: _model
                                                            .textController25Validator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        FlutterFlowChoiceChips(
                                                      options: [
                                                        ChipData('Fix & Flip'),
                                                        ChipData('Add-On'),
                                                        ChipData('ADU'),
                                                        ChipData('New'),
                                                        ChipData('Rental')
                                                      ],
                                                      onChanged: (val) async {
                                                        safeSetState(() => _model
                                                                .choiceChipsValue1 =
                                                            val?.firstOrNull);
                                                        logFirebaseEvent(
                                                            'SEARCH_ChoiceChips_4e4nngz9_ON_FORM_WIDG');
                                                        logFirebaseEvent(
                                                            'ChoiceChips_rebuild_page');
                                                        safeSetState(() {});
                                                      },
                                                      selectedChipStyle:
                                                          ChipStyle(
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        iconColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        iconSize: 16.0,
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      unselectedChipStyle:
                                                          ChipStyle(
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        iconColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        iconSize: 16.0,
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      chipSpacing: 8.0,
                                                      rowSpacing: 8.0,
                                                      multiselect: false,
                                                      alignment:
                                                          WrapAlignment.start,
                                                      controller: _model
                                                              .choiceChipsValueController1 ??=
                                                          FormFieldController<
                                                              List<String>>(
                                                        [],
                                                      ),
                                                      wrapped: true,
                                                    ),
                                                  ),
                                                  if (_model.choiceChipsValue1 !=
                                                          null &&
                                                      _model.choiceChipsValue1 !=
                                                          '')
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'SEARCH_PAGE_Icon_sgoz1aau_ON_TAP');
                                                        logFirebaseEvent(
                                                            'Icon_reset_form_fields');
                                                        safeSetState(() {
                                                          _model
                                                              .choiceChipsValueController1
                                                              ?.reset();
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          theme: ExpandableThemeData(
                                            tapHeaderToExpand: false,
                                            tapBodyToExpand: false,
                                            tapBodyToCollapse: false,
                                            headerAlignment:
                                                ExpandablePanelHeaderAlignment
                                                    .center,
                                            hasIcon: true,
                                            expandIcon:
                                                FontAwesomeIcons.slidersH,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_model.toggleSidebarOn)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.25,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.9,
                                    constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.sizeOf(context).width <=
                                                  450.0
                                              ? MediaQuery.sizeOf(context).width
                                              : 300.0,
                                      maxWidth: 439.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment(0.0, 0),
                                          child: FlutterFlowButtonTabBar(
                                            useToggleButtonStyle: false,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumFamily,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumIsCustom,
                                                    ),
                                            unselectedLabelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumIsCustom,
                                                    ),
                                            labelColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            unselectedLabelColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            backgroundColor: Color(0xFF1D4F7D),
                                            unselectedBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            unselectedBorderColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            borderWidth: 2.0,
                                            borderRadius: 41.8,
                                            elevation: 0.0,
                                            tabs: [
                                              Tab(
                                                text: 'Search',
                                              ),
                                              Tab(
                                                text: 'Saved',
                                              ),
                                            ],
                                            controller: _model.tabBarController,
                                            onTap: (i) async {
                                              [() async {}, () async {}][i]();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            controller: _model.tabBarController,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) {
                                                        if (!_model
                                                            .searchMapView) {
                                                          return AuthUserStreamWidget(
                                                            builder:
                                                                (context) =>
                                                                    Builder(
                                                              builder:
                                                                  (context) {
                                                                final resultsFromReinvestCalcs = _model.searchFieldTextController1.text !=
                                                                            ''
                                                                    ? (_model.choiceChipsValue1 !=
                                                                                null &&
                                                                            _model.choiceChipsValue1 !=
                                                                                ''
                                                                        ? _model
                                                                            .searchReinvestCalcsComb
                                                                            .where((e) =>
                                                                                _model.choiceChipsValue1 ==
                                                                                getJsonField(
                                                                                  e,
                                                                                  r'''$.method''',
                                                                                ).toString())
                                                                            .toList()
                                                                        : _model.searchReinvestCalcsComb)
                                                                    : (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                            ? _model.reInvestCalcsCombined
                                                                                .where((e) =>
                                                                                    _model.choiceChipsValue1 ==
                                                                                    getJsonField(
                                                                                      e,
                                                                                      r'''$.method''',
                                                                                    ).toString())
                                                                                .toList()
                                                                            : _model.reInvestCalcsCombined)
                                                                        .where((e) =>
                                                                            valueOrDefault(currentUserDocument?.minimumReturn, 0) <=
                                                                            getJsonField(
                                                                              e,
                                                                              r'''$.netReturn''',
                                                                            ))
                                                                        .toList()
                                                                        .sortedList(
                                                                            keyOf: (e) => '${getJsonField(
                                                                                  e,
                                                                                  r'''$.netReturn''',
                                                                                ).toString()}',
                                                                            desc: true)
                                                                        .toList();

                                                                return ListView
                                                                    .separated(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              15.0),
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemCount:
                                                                      resultsFromReinvestCalcs
                                                                          .length,
                                                                  separatorBuilder: (_,
                                                                          __) =>
                                                                      SizedBox(
                                                                          height:
                                                                              15.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                          resultsFromReinvestCalcsIndex) {
                                                                    final resultsFromReinvestCalcsItem =
                                                                        resultsFromReinvestCalcs[
                                                                            resultsFromReinvestCalcsIndex];
                                                                    return Opacity(
                                                                      opacity:
                                                                          0.85,
                                                                      child: StreamBuilder<
                                                                          List<
                                                                              SavedPropertiesRecord>>(
                                                                        stream:
                                                                            querySavedPropertiesRecord(
                                                                          queryBuilder: (savedPropertiesRecord) => savedPropertiesRecord
                                                                              .where(
                                                                                'userRef',
                                                                                isEqualTo: currentUserReference,
                                                                              )
                                                                              .where(
                                                                                'id',
                                                                                isEqualTo: getJsonField(
                                                                                  resultsFromReinvestCalcsItem,
                                                                                  r'''$.zpid''',
                                                                                ).toString(),
                                                                              ),
                                                                          singleRecord:
                                                                              true,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Center(
                                                                              child: SizedBox(
                                                                                width: 50.0,
                                                                                height: 50.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    FlutterFlowTheme.of(context).secondary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          List<SavedPropertiesRecord>
                                                                              containerSavedPropertiesRecordList =
                                                                              snapshot.data!;
                                                                          final containerSavedPropertiesRecord = containerSavedPropertiesRecordList.isNotEmpty
                                                                              ? containerSavedPropertiesRecordList.first
                                                                              : null;

                                                                          return Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 1.0,
                                                                            height:
                                                                                242.9,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: Image.network(
                                                                                  getCORSProxyUrl(
                                                                                    valueOrDefault<String>(
                                                                                      getJsonField(
                                                                                        resultsFromReinvestCalcsItem,
                                                                                        r'''$.imgSrc''',
                                                                                      )?.toString(),
                                                                                      'https://www.fivebranches.edu/wp-content/uploads/2021/08/default-image.jpg',
                                                                                    ),
                                                                                  ),
                                                                                ).image,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  blurRadius: 5.0,
                                                                                  color: Color(0x33000000),
                                                                                  offset: Offset(
                                                                                    0.0,
                                                                                    2.0,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                              borderRadius: BorderRadius.circular(37.95),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.all(12.0),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).secondary,
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 6.75,
                                                                                          color: Color(0x41000000),
                                                                                          offset: Offset(
                                                                                            0.0,
                                                                                            6.75,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                      child: Text(
                                                                                        '${containerSavedPropertiesRecord != null ? formatNumber(
                                                                                            containerSavedPropertiesRecord.netReturn,
                                                                                            formatType: FormatType.decimal,
                                                                                            decimalType: DecimalType.automatic,
                                                                                            currency: '',
                                                                                          ) : formatNumber(
                                                                                            getJsonField(
                                                                                              resultsFromReinvestCalcsItem,
                                                                                              r'''$.netReturn''',
                                                                                            ),
                                                                                            formatType: FormatType.decimal,
                                                                                            decimalType: DecimalType.automatic,
                                                                                            currency: '',
                                                                                          )} return',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(0.0, 1.0),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(44.28),
                                                                                    child: BackdropFilter(
                                                                                      filter: ImageFilter.blur(
                                                                                        sigmaX: 18.98,
                                                                                        sigmaY: 18.98,
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                        height: 50.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color(0x98FFFFFF),
                                                                                          borderRadius: BorderRadius.circular(44.28),
                                                                                        ),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      getJsonField(
                                                                                                        resultsFromReinvestCalcsItem,
                                                                                                        r'''$.method''',
                                                                                                      ).toString(),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).secondary,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      '${getJsonField(
                                                                                                        resultsFromReinvestCalcsItem,
                                                                                                        r'''$.bedrooms''',
                                                                                                      ).toString()} Bd / ${getJsonField(
                                                                                                        resultsFromReinvestCalcsItem,
                                                                                                        r'''$.bathrooms''',
                                                                                                      ).toString()} Ba ${getJsonField(
                                                                                                        resultsFromReinvestCalcsItem,
                                                                                                        r'''$.livingArea''',
                                                                                                      ).toString()}sf',
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).secondary,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Builder(
                                                                                              builder: (context) => Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                                child: FFButtonWidget(
                                                                                                  onPressed: () async {
                                                                                                    logFirebaseEvent('SEARCH_PAGE_VIEWButton_ON_TAP');
                                                                                                    logFirebaseEvent('VIEWButton_update_page_state');
                                                                                                    _model.selectedProperty = null;
                                                                                                    _model.selectedFieldSavedProperty = null;
                                                                                                    safeSetState(() {});
                                                                                                    if (loggedIn) {
                                                                                                      logFirebaseEvent('VIEWButton_firestore_query');
                                                                                                      _model.existingSavedDoc = await querySavedPropertiesRecordOnce(
                                                                                                        queryBuilder: (savedPropertiesRecord) => savedPropertiesRecord
                                                                                                            .where(
                                                                                                              'userRef',
                                                                                                              isEqualTo: currentUserReference,
                                                                                                            )
                                                                                                            .where(
                                                                                                              'id',
                                                                                                              isEqualTo: getJsonField(
                                                                                                                resultsFromReinvestCalcsItem,
                                                                                                                r'''$.zpid''',
                                                                                                              ).toString(),
                                                                                                            )
                                                                                                            .where(
                                                                                                              'method',
                                                                                                              isEqualTo: getJsonField(
                                                                                                                resultsFromReinvestCalcsItem,
                                                                                                                r'''$.method''',
                                                                                                              ).toString(),
                                                                                                            ),
                                                                                                        singleRecord: true,
                                                                                                      ).then((s) => s.firstOrNull);
                                                                                                      if (_model.existingSavedDoc != null) {
                                                                                                        logFirebaseEvent('VIEWButton_update_page_state');
                                                                                                        _model.selectedProperty = null;
                                                                                                        _model.selectedFieldSavedProperty = _model.existingSavedDoc;
                                                                                                        _model.compCoordinates = functions.convertListsToLatLng(_model.existingSavedDoc!.redfinSoldComps.map((e) => e.latLong.value.latitude).toList(), _model.existingSavedDoc!.redfinSoldComps.map((e) => e.latLong.value.longitude).toList()).toList().cast<LatLng>();
                                                                                                        _model.mapCoordinates = _model.existingSavedDoc?.latlng;
                                                                                                        safeSetState(() {});
                                                                                                      } else {
                                                                                                        if (valueOrDefault(currentUserDocument?.tokens, 0) > 0) {
                                                                                                          logFirebaseEvent('VIEWButton_backend_call');
                                                                                                          unawaited(
                                                                                                            () async {
                                                                                                              await currentUserReference!.update({
                                                                                                                ...mapToFirestore(
                                                                                                                  {
                                                                                                                    'tokens': FieldValue.increment(-(1)),
                                                                                                                  },
                                                                                                                ),
                                                                                                              });
                                                                                                            }(),
                                                                                                          );
                                                                                                          logFirebaseEvent('VIEWButton_update_page_state');
                                                                                                          _model.selectedProperty = resultsFromReinvestCalcsItem;
                                                                                                          _model.selectedFieldSavedProperty = null;
                                                                                                          safeSetState(() {});
                                                                                                          logFirebaseEvent('VIEWButton_update_page_state');
                                                                                                          _model.mapCoordinates = functions.convertToLatLng(
                                                                                                              valueOrDefault<double>(
                                                                                                                getJsonField(
                                                                                                                  _model.selectedProperty,
                                                                                                                  r'''$.latlng.latitude''',
                                                                                                                ),
                                                                                                                1.0,
                                                                                                              ),
                                                                                                              valueOrDefault<double>(
                                                                                                                getJsonField(
                                                                                                                  _model.selectedProperty,
                                                                                                                  r'''$.latlng.longitude''',
                                                                                                                ),
                                                                                                                1.0,
                                                                                                              ));
                                                                                                          _model.compCoordinates = functions.convertListsToLatLng(PropertyDetailsStruct.maybeFromMap(resultsFromReinvestCalcsItem)!.redfinSoldComps.map((e) => e.latLong.value.latitude).toList(), PropertyDetailsStruct.maybeFromMap(resultsFromReinvestCalcsItem)!.redfinSoldComps.map((e) => e.latLong.value.longitude).toList()).toList().cast<LatLng>();
                                                                                                          safeSetState(() {});
                                                                                                          logFirebaseEvent('VIEWButton_action_block');
                                                                                                          await _model.documentFromAPIData(
                                                                                                            context,
                                                                                                            apiPropertyData: resultsFromReinvestCalcsItem,
                                                                                                          );
                                                                                                          logFirebaseEvent('VIEWButton_rebuild_page');
                                                                                                          safeSetState(() {});
                                                                                                        } else {
                                                                                                          logFirebaseEvent('VIEWButton_show_snack_bar');
                                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                                            SnackBar(
                                                                                                              content: Text(
                                                                                                                'Please purchase tokens to continue',
                                                                                                                style: TextStyle(
                                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                ),
                                                                                                              ),
                                                                                                              duration: Duration(milliseconds: 4000),
                                                                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                            ),
                                                                                                          );
                                                                                                        }
                                                                                                      }
                                                                                                    } else {
                                                                                                      logFirebaseEvent('VIEWButton_alert_dialog');
                                                                                                      await showDialog(
                                                                                                        context: context,
                                                                                                        builder: (dialogContext) {
                                                                                                          return Dialog(
                                                                                                            elevation: 0,
                                                                                                            insetPadding: EdgeInsets.zero,
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                                            child: GestureDetector(
                                                                                                              onTap: () {
                                                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                                                              },
                                                                                                              child: AuthDialogueWidget(),
                                                                                                            ),
                                                                                                          );
                                                                                                        },
                                                                                                      );
                                                                                                    }

                                                                                                    safeSetState(() {});
                                                                                                  },
                                                                                                  text: 'View',
                                                                                                  options: FFButtonOptions(
                                                                                                    height: 40.0,
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                    color: FlutterFlowTheme.of(context).secondary,
                                                                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                          color: Colors.white,
                                                                                                          letterSpacing: 0.0,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                        ),
                                                                                                    elevation: 0.0,
                                                                                                    borderRadius: BorderRadius.circular(42.38),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        } else {
                                                          return Visibility(
                                                            visible: (_model
                                                                        .selectedProperty ==
                                                                    null) &&
                                                                !(_model.selectedFieldSavedProperty !=
                                                                    null) &&
                                                                (_model.searchFieldTextController1
                                                                            .text !=
                                                                        '') &&
                                                                (_model
                                                                    .searchReinvestCalcsComb
                                                                    .isNotEmpty),
                                                            child:
                                                                FlutterFlowGoogleMap(
                                                              controller: _model
                                                                  .googleMapsController1,
                                                              onCameraIdle: (latLng) =>
                                                                  safeSetState(() =>
                                                                      _model.googleMapsCenter1 =
                                                                          latLng),
                                                              initialLocation: _model.googleMapsCenter1 ??= functions
                                                                  .convertListsToLatLng(
                                                                      (_model.searchReinvestCalcsComb
                                                                              .map((e) => getJsonField(
                                                                                    e,
                                                                                    r'''$.latlng.latitude''',
                                                                                  ))
                                                                              .toList())
                                                                          .cast<double>()
                                                                          .toList(),
                                                                      (_model.searchReinvestCalcsComb
                                                                              .map((e) => getJsonField(
                                                                                    e,
                                                                                    r'''$.latlng.longitude''',
                                                                                  ))
                                                                              .toList())
                                                                          .cast<double>()
                                                                          .toList())
                                                                  .firstOrNull!,
                                                              markers: functions
                                                                  .convertListsToLatLng(
                                                                      (_model.searchReinvestCalcsComb
                                                                              .map((e) => getJsonField(
                                                                                    e,
                                                                                    r'''$.latlng.latitude''',
                                                                                  ))
                                                                              .toList())
                                                                          .cast<double>()
                                                                          .toList(),
                                                                      (_model.searchReinvestCalcsComb
                                                                              .map((e) => getJsonField(
                                                                                    e,
                                                                                    r'''$.latlng.longitude''',
                                                                                  ))
                                                                              .toList())
                                                                          .cast<double>()
                                                                          .toList())
                                                                  .map(
                                                                    (marker) =>
                                                                        FlutterFlowMarker(
                                                                      marker
                                                                          .serialize(),
                                                                      marker,
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                              markerColor:
                                                                  GoogleMarkerColor
                                                                      .violet,
                                                              markerImage:
                                                                  MarkerImage(
                                                                imagePath:
                                                                    'assets/images/Group_27.svg',
                                                                isAssetImage:
                                                                    true,
                                                                size:
                                                                    20.0 ?? 20,
                                                              ),
                                                              mapType: MapType
                                                                  .normal,
                                                              style:
                                                                  GoogleMapStyle
                                                                      .standard,
                                                              initialZoom: 11.0,
                                                              allowInteraction:
                                                                  true,
                                                              allowZoom: true,
                                                              showZoomControls:
                                                                  true,
                                                              showLocation:
                                                                  true,
                                                              showCompass:
                                                                  false,
                                                              showMapToolbar:
                                                                  false,
                                                              showTraffic:
                                                                  false,
                                                              centerMapOnMarkerTap:
                                                                  true,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) {
                                                        if (!_model
                                                            .savedPropertiesMapView) {
                                                          return StreamBuilder<
                                                              List<
                                                                  SavedPropertiesRecord>>(
                                                            stream:
                                                                querySavedPropertiesRecord(
                                                              queryBuilder:
                                                                  (savedPropertiesRecord) =>
                                                                      savedPropertiesRecord
                                                                          .where(
                                                                'userRef',
                                                                isEqualTo:
                                                                    currentUserReference,
                                                              ),
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<SavedPropertiesRecord>
                                                                  listViewSavedPropertiesRecordList =
                                                                  snapshot
                                                                      .data!;

                                                              return ListView
                                                                  .separated(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            12.0),
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    listViewSavedPropertiesRecordList
                                                                        .length,
                                                                separatorBuilder: (_,
                                                                        __) =>
                                                                    SizedBox(
                                                                        height:
                                                                            12.0),
                                                                itemBuilder:
                                                                    (context,
                                                                        listViewIndex) {
                                                                  final listViewSavedPropertiesRecord =
                                                                      listViewSavedPropertiesRecordList[
                                                                          listViewIndex];
                                                                  return Stack(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.0,
                                                                            -1.0),
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            logFirebaseEvent('SEARCH_PAGE_Container_a8cu6k0e_ON_TAP');
                                                                            if (loggedIn ==
                                                                                true) {
                                                                              logFirebaseEvent('ImageCard_update_page_state');
                                                                              _model.selectedProperty = null;
                                                                              _model.selectedFieldSavedProperty = null;
                                                                              _model.mapCoordinates = null;
                                                                              safeSetState(() {});
                                                                              logFirebaseEvent('ImageCard_update_page_state');
                                                                              _model.selectedFieldSavedProperty = listViewSavedPropertiesRecord;
                                                                              _model.mapCoordinates = listViewSavedPropertiesRecord.latlng;
                                                                              safeSetState(() {});
                                                                              if (MediaQuery.sizeOf(context).width <= 450.0) {
                                                                                logFirebaseEvent('ImageCard_update_page_state');
                                                                                _model.savedPropertiesMapView = true;
                                                                                safeSetState(() {});
                                                                              }
                                                                            } else {
                                                                              logFirebaseEvent('ImageCard_show_snack_bar');
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text(
                                                                                    'Please purchase token to continue',
                                                                                    style: TextStyle(
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    ),
                                                                                  ),
                                                                                  duration: Duration(milliseconds: 4000),
                                                                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              ImageCardWidget(
                                                                            key:
                                                                                Key('Keya8c_${listViewIndex}_of_${listViewSavedPropertiesRecordList.length}'),
                                                                            price:
                                                                                listViewSavedPropertiesRecord.price,
                                                                            address:
                                                                                listViewSavedPropertiesRecord.address,
                                                                            duration:
                                                                                listViewSavedPropertiesRecord.duration,
                                                                            method:
                                                                                listViewSavedPropertiesRecord.method,
                                                                            grossReturn:
                                                                                listViewSavedPropertiesRecord.grossReturn,
                                                                            totalCosts:
                                                                                listViewSavedPropertiesRecord.totalCosts,
                                                                            financingCosts:
                                                                                listViewSavedPropertiesRecord.sellingCosts,
                                                                            bedrooms:
                                                                                listViewSavedPropertiesRecord.bedrooms,
                                                                            baths:
                                                                                listViewSavedPropertiesRecord.bathrooms,
                                                                            livingArea:
                                                                                listViewSavedPropertiesRecord.livingArea,
                                                                            lotArea:
                                                                                listViewSavedPropertiesRecord.lotAreaValue,
                                                                            imgSrc:
                                                                                listViewSavedPropertiesRecord.imgSrc,
                                                                            zpid:
                                                                                FFAppConstants.zipId.toString(),
                                                                            estimatedValue:
                                                                                listViewSavedPropertiesRecord.zestimate,
                                                                            downPayment:
                                                                                listViewSavedPropertiesRecord.downPayment,
                                                                            yearBuilt:
                                                                                listViewSavedPropertiesRecord.yearBuilt,
                                                                            loanAmount:
                                                                                listViewSavedPropertiesRecord.loanAmount,
                                                                            detailUrl:
                                                                                listViewSavedPropertiesRecord.detailUrl,
                                                                            cashNeeded:
                                                                                listViewSavedPropertiesRecord.cashNeeded,
                                                                            proposedClosedDate:
                                                                                listViewSavedPropertiesRecord.purchCloseDate,
                                                                            proposedSaleDate:
                                                                                listViewSavedPropertiesRecord.saleCloseDate,
                                                                            netReturn:
                                                                                listViewSavedPropertiesRecord.netReturn,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      FlutterFlowIconButton(
                                                                        borderRadius:
                                                                            8.0,
                                                                        buttonSize:
                                                                            40.0,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).error,
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          logFirebaseEvent(
                                                                              'SEARCH_PAGE_close_ICN_ON_TAP');
                                                                          logFirebaseEvent(
                                                                              'IconButton_alert_dialog');
                                                                          var confirmDialogResponse = await showDialog<bool>(
                                                                                context: context,
                                                                                builder: (alertDialogContext) {
                                                                                  return AlertDialog(
                                                                                    title: Text('Delete Entry'),
                                                                                    content: Text('Are you sure you want to delete this entry?'),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                        child: Text('Cancel'),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                        child: Text('Confirm'),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              ) ??
                                                                              false;
                                                                          if (confirmDialogResponse) {
                                                                            logFirebaseEvent('IconButton_backend_call');
                                                                            await listViewSavedPropertiesRecord.reference.delete();
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          return Stack(
                                                            children: [
                                                              if ((_model
                                                                          .selectedProperty ==
                                                                      null) &&
                                                                  !(_model.selectedFieldSavedProperty !=
                                                                      null) &&
                                                                  (_model.searchFieldTextController1
                                                                              .text ==
                                                                          '') &&
                                                                  (_model
                                                                      .reInvestCalcsCombined
                                                                      .isNotEmpty))
                                                                FlutterFlowGoogleMap(
                                                                  controller: _model
                                                                      .googleMapsController2,
                                                                  onCameraIdle: (latLng) =>
                                                                      safeSetState(() =>
                                                                          _model.googleMapsCenter2 =
                                                                              latLng),
                                                                  initialLocation: _model
                                                                          .googleMapsCenter2 ??=
                                                                      LatLng(
                                                                          38.575764,
                                                                          -121.478851),
                                                                  markers: functions
                                                                      .convertListsToLatLng(
                                                                          (_model.reInvestCalcsCombined
                                                                                  .map((e) => getJsonField(
                                                                                        e,
                                                                                        r'''$.latlng.latitude''',
                                                                                      ))
                                                                                  .toList())
                                                                              .cast<double>()
                                                                              .toList(),
                                                                          (_model.reInvestCalcsCombined
                                                                                  .map((e) => getJsonField(
                                                                                        e,
                                                                                        r'''$.latlng.longitude''',
                                                                                      ))
                                                                                  .toList())
                                                                              .cast<double>()
                                                                              .toList())
                                                                      .map(
                                                                        (marker) =>
                                                                            FlutterFlowMarker(
                                                                          marker
                                                                              .serialize(),
                                                                          marker,
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                  markerColor:
                                                                      GoogleMarkerColor
                                                                          .violet,
                                                                  mapType: MapType
                                                                      .normal,
                                                                  style: GoogleMapStyle
                                                                      .standard,
                                                                  initialZoom:
                                                                      11.0,
                                                                  allowInteraction:
                                                                      true,
                                                                  allowZoom:
                                                                      true,
                                                                  showZoomControls:
                                                                      true,
                                                                  showLocation:
                                                                      true,
                                                                  showCompass:
                                                                      false,
                                                                  showMapToolbar:
                                                                      false,
                                                                  showTraffic:
                                                                      false,
                                                                  centerMapOnMarkerTap:
                                                                      true,
                                                                ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        1.0,
                                                                        -1.0),
                                                                child:
                                                                    PointerInterceptor(
                                                                  intercepting:
                                                                      isWeb,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            20.0,
                                                                            20.0,
                                                                            0.0),
                                                                    child:
                                                                        FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryBackground,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .list_alt,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        logFirebaseEvent(
                                                                            'SEARCH_PAGE_list_alt_ICN_ON_TAP');
                                                                        logFirebaseEvent(
                                                                            'IconButton_update_page_state');
                                                                        _model.savedPropertiesMapView =
                                                                            false;
                                                                        safeSetState(
                                                                            () {});
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (!(_model.selectedFieldSavedProperty != null) &&
                          ((_model.reInvestCalcsCombined.isNotEmpty) ||
                              (_model.searchReinvestCalcsComb.isNotEmpty)))
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 30.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 30.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 0.0;
                                        } else {
                                          return 0.0;
                                        }
                                      }(),
                                      0.0,
                                    )),
                                    bottomRight:
                                        Radius.circular(valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 30.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 30.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 0.0;
                                        } else {
                                          return 0.0;
                                        }
                                      }(),
                                      0.0,
                                    )),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 30.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 30.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 0.0;
                                            } else {
                                              return 0.0;
                                            }
                                          }(),
                                          0.0,
                                        )),
                                        bottomRight: Radius.circular(
                                            valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 30.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 30.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 0.0;
                                            } else {
                                              return 0.0;
                                            }
                                          }(),
                                          0.0,
                                        )),
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (!(_model
                                                .selectedFieldSavedProperty !=
                                            null))
                                          Builder(
                                            builder: (context) =>
                                                AuthUserStreamWidget(
                                              builder: (context) => Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        1.0,
                                                child: custom_widgets.MainMap(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1.0,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          1.0,
                                                  zoomSetting: 11.0,
                                                  coordinates: functions
                                                      .convertListsToLatLng(
                                                          (_model.searchFieldTextController1
                                                                              .text !=
                                                                          ''
                                                                  ? (_model.choiceChipsValue1 !=
                                                                              null &&
                                                                          _model.choiceChipsValue1 !=
                                                                              ''
                                                                      ? _model
                                                                          .searchReinvestCalcsComb
                                                                          .where((e) =>
                                                                              _model.choiceChipsValue1 ==
                                                                              getJsonField(
                                                                                e,
                                                                                r'''$.method''',
                                                                              ).toString())
                                                                          .toList()
                                                                      : _model.searchReinvestCalcsComb)
                                                                  : (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                          ? _model.reInvestCalcsCombined
                                                                              .where((e) =>
                                                                                  _model.choiceChipsValue1 ==
                                                                                  getJsonField(
                                                                                    e,
                                                                                    r'''$.method''',
                                                                                  ).toString())
                                                                              .toList()
                                                                          : _model.reInvestCalcsCombined)
                                                                      .where((e) =>
                                                                          valueOrDefault(currentUserDocument?.minimumReturn, 0) <=
                                                                          getJsonField(
                                                                            e,
                                                                            r'''$.netReturn''',
                                                                          ))
                                                                      .toList()
                                                                      .map((e) => getJsonField(
                                                                            e,
                                                                            r'''$.latlng.latitude''',
                                                                          ))
                                                                      .toList())
                                                              .cast<double>()
                                                              .toList(),
                                                          (_model.searchFieldTextController1.text != ''
                                                                  ? (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                      ? _model.searchReinvestCalcsComb
                                                                          .where((e) =>
                                                                              _model.choiceChipsValue1 ==
                                                                              getJsonField(
                                                                                e,
                                                                                r'''$.method''',
                                                                              ).toString())
                                                                          .toList()
                                                                      : _model.searchReinvestCalcsComb)
                                                                  : (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                          ? _model.reInvestCalcsCombined
                                                                              .where((e) =>
                                                                                  _model.choiceChipsValue1 ==
                                                                                  getJsonField(
                                                                                    e,
                                                                                    r'''$.method''',
                                                                                  ).toString())
                                                                              .toList()
                                                                          : _model.reInvestCalcsCombined)
                                                                      .where((e) =>
                                                                          valueOrDefault(currentUserDocument?.minimumReturn, 0) <=
                                                                          getJsonField(
                                                                            e,
                                                                            r'''$.netReturn''',
                                                                          ))
                                                                      .toList()
                                                                      .map((e) => getJsonField(
                                                                            e,
                                                                            r'''$.latlng.longitude''',
                                                                          ))
                                                                      .toList())
                                                              .cast<double>()
                                                              .toList())
                                                      .firstOrNull!,
                                                  propertyCoordinates: functions.convertListsToLatLng(
                                                      (_model.searchFieldTextController1.text != ''
                                                              ? (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                  ? _model.searchReinvestCalcsComb
                                                                      .where((e) =>
                                                                          _model.choiceChipsValue1 ==
                                                                          getJsonField(
                                                                            e,
                                                                            r'''$.method''',
                                                                          ).toString())
                                                                      .toList()
                                                                  : _model.searchReinvestCalcsComb)
                                                              : (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                      ? _model.reInvestCalcsCombined
                                                                          .where((e) =>
                                                                              _model.choiceChipsValue1 ==
                                                                              getJsonField(
                                                                                e,
                                                                                r'''$.method''',
                                                                              ).toString())
                                                                          .toList()
                                                                      : _model.reInvestCalcsCombined)
                                                                  .where((e) =>
                                                                      valueOrDefault(currentUserDocument?.minimumReturn, 0) <=
                                                                      getJsonField(
                                                                        e,
                                                                        r'''$.netReturn''',
                                                                      ))
                                                                  .toList()
                                                                  .map((e) => getJsonField(
                                                                        e,
                                                                        r'''$.latlng.latitude''',
                                                                      ))
                                                                  .toList())
                                                          .cast<double>()
                                                          .toList(),
                                                      (_model.searchFieldTextController1.text != ''
                                                              ? (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                  ? _model.searchReinvestCalcsComb
                                                                      .where((e) =>
                                                                          _model.choiceChipsValue1 ==
                                                                          getJsonField(
                                                                            e,
                                                                            r'''$.method''',
                                                                          ).toString())
                                                                      .toList()
                                                                  : _model.searchReinvestCalcsComb)
                                                              : (_model.choiceChipsValue1 != null && _model.choiceChipsValue1 != ''
                                                                      ? _model.reInvestCalcsCombined
                                                                          .where((e) =>
                                                                              _model.choiceChipsValue1 ==
                                                                              getJsonField(
                                                                                e,
                                                                                r'''$.method''',
                                                                              ).toString())
                                                                          .toList()
                                                                      : _model.reInvestCalcsCombined)
                                                                  .where((e) =>
                                                                      valueOrDefault(currentUserDocument?.minimumReturn, 0) <=
                                                                      getJsonField(
                                                                        e,
                                                                        r'''$.netReturn''',
                                                                      ))
                                                                  .toList()
                                                                  .map((e) => getJsonField(
                                                                        e,
                                                                        r'''$.latlng.longitude''',
                                                                      ))
                                                                  .toList())
                                                          .cast<double>()
                                                          .toList()),
                                                  maxZoom: 16.0,
                                                  properties: _model.searchFieldTextController1
                                                                  .text !=
                                                              ''
                                                      ? (_model.choiceChipsValue1 !=
                                                                  null &&
                                                              _model.choiceChipsValue1 !=
                                                                  ''
                                                          ? _model
                                                              .searchReinvestCalcsComb
                                                              .where((e) =>
                                                                  _model
                                                                      .choiceChipsValue1 ==
                                                                  getJsonField(
                                                                    e,
                                                                    r'''$.method''',
                                                                  ).toString())
                                                              .toList()
                                                          : _model
                                                              .searchReinvestCalcsComb)
                                                      : (_model.choiceChipsValue1 !=
                                                                      null &&
                                                                  _model.choiceChipsValue1 !=
                                                                      ''
                                                              ? _model
                                                                  .reInvestCalcsCombined
                                                                  .where((e) =>
                                                                      _model
                                                                          .choiceChipsValue1 ==
                                                                      getJsonField(
                                                                        e,
                                                                        r'''$.method''',
                                                                      )
                                                                          .toString())
                                                                  .toList()
                                                              : _model
                                                                  .reInvestCalcsCombined)
                                                          .where((e) =>
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.minimumReturn,
                                                                  0) <=
                                                              getJsonField(
                                                                e,
                                                                r'''$.netReturn''',
                                                              ))
                                                          .toList(),
                                                  onPropertyTap:
                                                      (zpid, method) async {
                                                    logFirebaseEvent(
                                                        'SEARCH_PAGE_Container_t5jbpku8_CALLBACK');
                                                    logFirebaseEvent(
                                                        'MainMap_update_page_state');
                                                    _model.selectedProperty =
                                                        null;
                                                    _model.selectedFieldSavedProperty =
                                                        null;
                                                    safeSetState(() {});
                                                    if (loggedIn) {
                                                      logFirebaseEvent(
                                                          'MainMap_firestore_query');
                                                      _model.existingSavedDocMap =
                                                          await querySavedPropertiesRecordOnce(
                                                        queryBuilder:
                                                            (savedPropertiesRecord) =>
                                                                savedPropertiesRecord
                                                                    .where(
                                                                      'userRef',
                                                                      isEqualTo:
                                                                          currentUserReference,
                                                                    )
                                                                    .where(
                                                                      'id',
                                                                      isEqualTo:
                                                                          zpid,
                                                                    )
                                                                    .where(
                                                                      'method',
                                                                      isEqualTo:
                                                                          method,
                                                                    ),
                                                        singleRecord: true,
                                                      ).then((s) =>
                                                              s.firstOrNull);
                                                      if (_model
                                                              .existingSavedDocMap !=
                                                          null) {
                                                        logFirebaseEvent(
                                                            'MainMap_update_page_state');
                                                        _model.selectedProperty =
                                                            null;
                                                        _model.selectedFieldSavedProperty =
                                                            _model
                                                                .existingSavedDocMap;
                                                        _model.compCoordinates = functions
                                                            .convertListsToLatLng(
                                                                _model
                                                                    .existingSavedDocMap!
                                                                    .redfinSoldComps
                                                                    .map((e) => e
                                                                        .latLong
                                                                        .value
                                                                        .latitude)
                                                                    .toList(),
                                                                _model
                                                                    .existingSavedDocMap!
                                                                    .redfinSoldComps
                                                                    .map((e) => e
                                                                        .latLong
                                                                        .value
                                                                        .longitude)
                                                                    .toList())
                                                            .toList()
                                                            .cast<LatLng>();
                                                        _model.mapCoordinates =
                                                            _model
                                                                .existingSavedDocMap
                                                                ?.latlng;
                                                        safeSetState(() {});
                                                      } else {
                                                        if (valueOrDefault(
                                                                currentUserDocument
                                                                    ?.tokens,
                                                                0) >
                                                            0) {
                                                          logFirebaseEvent(
                                                              'MainMap_backend_call');
                                                          unawaited(
                                                            () async {
                                                              await currentUserReference!
                                                                  .update({
                                                                ...mapToFirestore(
                                                                  {
                                                                    'tokens': FieldValue
                                                                        .increment(
                                                                            -(1)),
                                                                  },
                                                                ),
                                                              });
                                                            }(),
                                                          );
                                                          logFirebaseEvent(
                                                              'MainMap_update_page_state');
                                                          _model.selectedProperty = _model
                                                              .reInvestCalcsCombined
                                                              .where((e) =>
                                                                  (zpid ==
                                                                      e.toString()) &&
                                                                  (method ==
                                                                      getJsonField(
                                                                        e,
                                                                        r'''$.method''',
                                                                      ).toString()))
                                                              .toList()
                                                              .firstOrNull;
                                                          _model.selectedFieldSavedProperty =
                                                              null;
                                                          safeSetState(() {});
                                                          logFirebaseEvent(
                                                              'MainMap_update_page_state');
                                                          _model.mapCoordinates = functions
                                                              .convertToLatLng(
                                                                  valueOrDefault<
                                                                      double>(
                                                                    getJsonField(
                                                                      _model
                                                                          .selectedProperty,
                                                                      r'''$.latlng.latitude''',
                                                                    ),
                                                                    1.0,
                                                                  ),
                                                                  valueOrDefault<
                                                                      double>(
                                                                    getJsonField(
                                                                      _model
                                                                          .selectedProperty,
                                                                      r'''$.latlng.longitude''',
                                                                    ),
                                                                    1.0,
                                                                  ));
                                                          _model.compCoordinates = functions
                                                              .convertListsToLatLng(
                                                                  PropertyDetailsStruct.maybeFromMap(_model.reInvestCalcsCombined
                                                                          .where((e) =>
                                                                              (zpid == e.toString()) &&
                                                                              (method ==
                                                                                  getJsonField(
                                                                                    e,
                                                                                    r'''$.method''',
                                                                                  ).toString()))
                                                                          .toList()
                                                                          .firstOrNull!)!
                                                                      .redfinSoldComps
                                                                      .map((e) => e.latLong.value.latitude)
                                                                      .toList(),
                                                                  PropertyDetailsStruct.maybeFromMap(_model.reInvestCalcsCombined
                                                                          .where((e) =>
                                                                              (zpid == e.toString()) &&
                                                                              (method ==
                                                                                  getJsonField(
                                                                                    e,
                                                                                    r'''$.method''',
                                                                                  ).toString()))
                                                                          .toList()
                                                                          .firstOrNull!)!
                                                                      .redfinSoldComps
                                                                      .map((e) => e.latLong.value.longitude)
                                                                      .toList())
                                                              .toList()
                                                              .cast<LatLng>();
                                                          safeSetState(() {});
                                                          logFirebaseEvent(
                                                              'MainMap_action_block');
                                                          await _model
                                                              .documentFromAPIData(
                                                            context,
                                                            apiPropertyData: _model
                                                                .reInvestCalcsCombined
                                                                .where((e) =>
                                                                    (zpid ==
                                                                        e.toString()) &&
                                                                    (method ==
                                                                        getJsonField(
                                                                          e,
                                                                          r'''$.method''',
                                                                        ).toString()))
                                                                .toList()
                                                                .firstOrNull,
                                                          );
                                                          safeSetState(() {});
                                                        } else {
                                                          logFirebaseEvent(
                                                              'MainMap_show_snack_bar');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Please purchase tokens to continue',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } else {
                                                      logFirebaseEvent(
                                                          'MainMap_alert_dialog');
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (dialogContext) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            insetPadding:
                                                                EdgeInsets.zero,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            alignment: AlignmentDirectional(
                                                                    0.0, 0.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        dialogContext)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child:
                                                                  AuthDialogueWidget(),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (responsiveVisibility(
                                              context: context,
                                              tabletLandscape: false,
                                              desktop: false,
                                            ))
                                              Material(
                                                color: Colors.transparent,
                                                elevation: 4.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 5.0,
                                                          color:
                                                              Color(0x40000000),
                                                          offset: Offset(
                                                            0.0,
                                                            5.0,
                                                          ),
                                                          spreadRadius: 0.0,
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      color: Color(0x00000000),
                                                      child: ExpandableNotifier(
                                                        controller: _model
                                                            .expandableExpandableController2,
                                                        child: ExpandablePanel(
                                                          header: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  width: 200.0,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model
                                                                            .searchFieldTextController2,
                                                                    focusNode:
                                                                        _model
                                                                            .searchFieldFocusNode2,
                                                                    onChanged: (_) =>
                                                                        EasyDebounce
                                                                            .debounce(
                                                                      '_model.searchFieldTextController2',
                                                                      Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      () => safeSetState(
                                                                          () {}),
                                                                    ),
                                                                    onFieldSubmitted:
                                                                        (_) async {
                                                                      logFirebaseEvent(
                                                                          'SEARCH_SearchField_ON_TEXTFIELD_SUBMIT');
                                                                      logFirebaseEvent(
                                                                          'SearchField_update_page_state');
                                                                      _model.selectedProperty =
                                                                          null;
                                                                      _model.searchCounter =
                                                                          0;
                                                                      _model.searchReinvestCalcsComb =
                                                                          [];
                                                                      _model.searchPptyDetails =
                                                                          [];
                                                                      safeSetState(
                                                                          () {});
                                                                      logFirebaseEvent(
                                                                          'SearchField_cancel_streaming_response_su');
                                                                      await ApiManager
                                                                          .instance
                                                                          .cancelActiveStreamingResponseSubscription(
                                                                        'test',
                                                                      );

                                                                      logFirebaseEvent(
                                                                          'SearchField_backend_call');
                                                                      _model.cloudFunctionsSearchMobile = await FirebaseCloudFunctionsGroup
                                                                          .cloudCalcsCall
                                                                          .call(
                                                                        location: _model
                                                                            .searchFieldTextController2
                                                                            .text,
                                                                        minPrice:
                                                                            valueOrDefault<int>(
                                                                          int.tryParse(_model
                                                                              .textController27
                                                                              .text),
                                                                          10000,
                                                                        ),
                                                                        maxPrice:
                                                                            valueOrDefault<int>(
                                                                          int.tryParse(_model
                                                                              .textController28
                                                                              .text),
                                                                          750000,
                                                                        ),
                                                                        propertyType:
                                                                            'SINGLE_FAMILY',
                                                                        daysOn:
                                                                            7,
                                                                        lotSizeMin:
                                                                            3000,
                                                                        dwnPmtRate:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.dwnPmtRate,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        salRate:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.salRate,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        financingRate:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.financingRate,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        taxInsRate:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.taxInsRate,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        fnfImpRate: valueOrDefault(
                                                                            currentUserDocument?.fnfImpRate,
                                                                            0),
                                                                        aduImpRate:
                                                                            valueOrDefault<int>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.aduImpRate,
                                                                              0),
                                                                          1,
                                                                        ),
                                                                        newImpRate: valueOrDefault(
                                                                            currentUserDocument?.newBuildRate,
                                                                            0),
                                                                        fnfImpFactor:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.fnfImpFactor,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        twoBedAvgValue: valueOrDefault(
                                                                            currentUserDocument?.twoBedAvgValue,
                                                                            0),
                                                                        twoBdrmAduCost: valueOrDefault(
                                                                            currentUserDocument?.aduTwoBdrmCost,
                                                                            0),
                                                                        newFutValSalperSFRate: valueOrDefault(
                                                                            currentUserDocument?.newFutValSalperSFRate,
                                                                            0),
                                                                        oneBdrmMarketValue: valueOrDefault(
                                                                            currentUserDocument?.oneBdrmMarketValue,
                                                                            0),
                                                                        loanFeesRate: valueOrDefault(
                                                                            currentUserDocument?.loanFeesRate,
                                                                            0.0),
                                                                        propertyIns: valueOrDefault(
                                                                            currentUserDocument?.propertyIns,
                                                                            0),
                                                                        propertyTaxes: valueOrDefault(
                                                                            currentUserDocument?.propertyTaxes,
                                                                            0),
                                                                        permitsFees: valueOrDefault(
                                                                            currentUserDocument?.permitsFees,
                                                                            0),
                                                                        fixnflipDuration: valueOrDefault(
                                                                            currentUserDocument?.fixnflipDuration,
                                                                            0),
                                                                        addOnDuration: valueOrDefault(
                                                                            currentUserDocument?.addOnDuration,
                                                                            0),
                                                                        aduDuration: valueOrDefault(
                                                                            currentUserDocument?.aduDuration,
                                                                            0),
                                                                        newDuration: valueOrDefault(
                                                                            currentUserDocument?.newDuration,
                                                                            0),
                                                                        newBuildRate: valueOrDefault(
                                                                            currentUserDocument?.newBuildRate,
                                                                            0),
                                                                        isInterestOnly:
                                                                            true,
                                                                        addOnSqftRate:
                                                                            valueOrDefault<int>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.addOnSqftRate,
                                                                              0),
                                                                          1,
                                                                        ),
                                                                        addOnImpFactor:
                                                                            valueOrDefault<double>(
                                                                          valueOrDefault(
                                                                              currentUserDocument?.addOnImpFactor,
                                                                              0.0),
                                                                          1.0,
                                                                        ),
                                                                        addOnBeds: valueOrDefault(
                                                                            currentUserDocument?.addOnBeds,
                                                                            0),
                                                                        addOnBaths: valueOrDefault(
                                                                            currentUserDocument?.addOnBaths,
                                                                            0),
                                                                        aduBeds: valueOrDefault(
                                                                            currentUserDocument?.aduBaths,
                                                                            0),
                                                                        aduBaths: valueOrDefault(
                                                                            currentUserDocument?.aduBaths,
                                                                            0),
                                                                        aduArea: valueOrDefault(
                                                                            currentUserDocument?.aduArea,
                                                                            0),
                                                                        newArea: valueOrDefault(
                                                                            currentUserDocument?.newArea,
                                                                            0),
                                                                        newBeds: valueOrDefault(
                                                                            currentUserDocument?.newBeds,
                                                                            0),
                                                                        newBaths: valueOrDefault(
                                                                            currentUserDocument?.newBaths,
                                                                            0),
                                                                        statusType:
                                                                            'FOR_SALE',
                                                                      );
                                                                      if (_model
                                                                              .cloudFunctionsSearchMobile
                                                                              ?.succeeded ??
                                                                          true) {
                                                                        final streamSubscription = _model
                                                                            .cloudFunctionsSearchMobile
                                                                            ?.streamedResponse
                                                                            ?.stream
                                                                            .transform(utf8
                                                                                .decoder)
                                                                            .transform(
                                                                                const LineSplitter())
                                                                            .transform(
                                                                                ServerSentEventLineTransformer())
                                                                            .map((m) =>
                                                                                ResponseStreamMessage(message: m))
                                                                            .listen(
                                                                          (onMessageInput) async {
                                                                            if (getJsonField(
                                                                                  onMessageInput.serverSentEvent.jsonData,
                                                                                  r'''$..price''',
                                                                                ) !=
                                                                                null) {
                                                                              logFirebaseEvent('_update_page_state');
                                                                              _model.addToSearchReinvestCalcsComb(onMessageInput.serverSentEvent.jsonData);
                                                                              safeSetState(() {});
                                                                            }
                                                                          },
                                                                          onError:
                                                                              (onErrorInput) async {
                                                                            logFirebaseEvent('_alert_dialog');
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('ERROR'),
                                                                                  content: Text(onErrorInput!),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext),
                                                                                      child: Text('Ok'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          onDone:
                                                                              () async {
                                                                            logFirebaseEvent('_alert_dialog');
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Done'),
                                                                                  content: Text('Completed Response'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(alertDialogContext),
                                                                                      child: Text('Ok'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        );
                                                                        // Add the subscription to the active streaming response subscriptions
                                                                        // in API Manager so that it can be cancelled at a later time.
                                                                        ApiManager
                                                                            .instance
                                                                            .addActiveStreamingResponseSubscription(
                                                                          'search',
                                                                          streamSubscription,
                                                                        );
                                                                      }

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    autofocus:
                                                                        false,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      hintText:
                                                                          'Search a city',
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelMediumFamily,
                                                                            color:
                                                                                Color(0xFF1D4F7D),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Color(0x00000000),
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(43.68),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Color(0x00000000),
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(43.68),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(43.68),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(43.68),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      prefixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: Color(
                                                                            0xFF1D4F7D),
                                                                      ),
                                                                      suffixIcon: _model
                                                                              .searchFieldTextController2!
                                                                              .text
                                                                              .isNotEmpty
                                                                          ? InkWell(
                                                                              onTap: () async {
                                                                                _model.searchFieldTextController2?.clear();
                                                                                safeSetState(() {});
                                                                              },
                                                                              child: Icon(
                                                                                Icons.clear,
                                                                                size: 22,
                                                                              ),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    cursorColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    validator: _model
                                                                        .searchFieldTextController2Validator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          collapsed:
                                                              Container(),
                                                          expanded: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          200.0,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.textController27,
                                                                        focusNode:
                                                                            _model.textFieldFocusNode3,
                                                                        autofocus:
                                                                            false,
                                                                        textInputAction:
                                                                            TextInputAction.search,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          isDense:
                                                                              true,
                                                                          hintText:
                                                                              'min',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00000000),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00000000),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          prefixIcon:
                                                                              Icon(
                                                                            FontAwesomeIcons.dollarSign,
                                                                          ),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        keyboardType: const TextInputType
                                                                            .numberWithOptions(
                                                                            decimal:
                                                                                true),
                                                                        cursorColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        validator: _model
                                                                            .textController27Validator
                                                                            .asValidator(context),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp('[0-9]'))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          200.0,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.textController28,
                                                                        focusNode:
                                                                            _model.textFieldFocusNode4,
                                                                        autofocus:
                                                                            false,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          isDense:
                                                                              true,
                                                                          labelStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                              ),
                                                                          hintText:
                                                                              'max',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00000000),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00000000),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          prefixIcon:
                                                                              Icon(
                                                                            FontAwesomeIcons.dollarSign,
                                                                          ),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        cursorColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        validator: _model
                                                                            .textController28Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          10.0),
                                                                      child:
                                                                          FlutterFlowChoiceChips(
                                                                        options: [
                                                                          ChipData(
                                                                              'Fix & Flip'),
                                                                          ChipData(
                                                                              'Add-On'),
                                                                          ChipData(
                                                                              'ADU'),
                                                                          ChipData(
                                                                              'New'),
                                                                          ChipData(
                                                                              'Rental')
                                                                        ],
                                                                        onChanged:
                                                                            (val) =>
                                                                                safeSetState(() => _model.choiceChipsValue2 = val?.firstOrNull),
                                                                        selectedChipStyle:
                                                                            ChipStyle(
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).info,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          iconColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          iconSize:
                                                                              16.0,
                                                                          elevation:
                                                                              0.0,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        unselectedChipStyle:
                                                                            ChipStyle(
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          iconColor:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          iconSize:
                                                                              16.0,
                                                                          elevation:
                                                                              0.0,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        chipSpacing:
                                                                            8.0,
                                                                        rowSpacing:
                                                                            8.0,
                                                                        multiselect:
                                                                            false,
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        controller:
                                                                            _model.choiceChipsValueController2 ??=
                                                                                FormFieldController<List<String>>(
                                                                          [],
                                                                        ),
                                                                        wrapped:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (_model.choiceChipsValue2 !=
                                                                          null &&
                                                                      _model.choiceChipsValue2 !=
                                                                          '')
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          10.0),
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          logFirebaseEvent(
                                                                              'SEARCH_PAGE_Icon_628n2g1v_ON_TAP');
                                                                          logFirebaseEvent(
                                                                              'Icon_reset_form_fields');
                                                                          safeSetState(
                                                                              () {
                                                                            _model.choiceChipsValueController2?.reset();
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .clear,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          theme:
                                                              ExpandableThemeData(
                                                            tapHeaderToExpand:
                                                                false,
                                                            tapBodyToExpand:
                                                                false,
                                                            tapBodyToCollapse:
                                                                false,
                                                            headerAlignment:
                                                                ExpandablePanelHeaderAlignment
                                                                    .center,
                                                            hasIcon: true,
                                                            expandIcon:
                                                                FontAwesomeIcons
                                                                    .slidersH,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (responsiveVisibility(
                                context: context,
                                tabletLandscape: false,
                                desktop: false,
                              ))
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      if (_model.selectedTab == 'search') {
                                        return Visibility(
                                          visible: responsiveVisibility(
                                            context: context,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final resultsFromReinvestCalcs = (_model.searchFieldTextController1
                                                                  .text !=
                                                              ''
                                                      ? (_model.choiceChipsValue1 !=
                                                                  null &&
                                                              _model.choiceChipsValue1 !=
                                                                  ''
                                                          ? _model
                                                              .searchReinvestCalcsComb
                                                              .where((e) =>
                                                                  _model
                                                                      .choiceChipsValue1 ==
                                                                  getJsonField(
                                                                    e,
                                                                    r'''$.method''',
                                                                  ).toString())
                                                              .toList()
                                                          : _model
                                                              .searchReinvestCalcsComb)
                                                      : (_model.choiceChipsValue1 !=
                                                                  null &&
                                                              _model.choiceChipsValue1 !=
                                                                  ''
                                                          ? _model
                                                              .reInvestCalcsCombined
                                                              .where((e) =>
                                                                  _model
                                                                      .choiceChipsValue1 ==
                                                                  getJsonField(
                                                                    e,
                                                                    r'''$.method''',
                                                                  ).toString())
                                                              .toList()
                                                          : _model
                                                              .reInvestCalcsCombined))
                                                  .toList();

                                              return ListView.separated(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15.0),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    resultsFromReinvestCalcs
                                                        .length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 15.0),
                                                itemBuilder: (context,
                                                    resultsFromReinvestCalcsIndex) {
                                                  final resultsFromReinvestCalcsItem =
                                                      resultsFromReinvestCalcs[
                                                          resultsFromReinvestCalcsIndex];
                                                  return Opacity(
                                                    opacity: 0.85,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  4.0,
                                                                  0.0,
                                                                  4.0,
                                                                  0.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height: 242.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                Image.network(
                                                              getCORSProxyUrl(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    resultsFromReinvestCalcsItem,
                                                                    r'''$.imgSrc''',
                                                                  )?.toString(),
                                                                  'https://www.fivebranches.edu/wp-content/uploads/2021/08/default-image.jpg',
                                                                ),
                                                              ),
                                                            ).image,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 5.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                0.0,
                                                                2.0,
                                                              ),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      37.95),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      blurRadius:
                                                                          6.75,
                                                                      color: Color(
                                                                          0x41000000),
                                                                      offset:
                                                                          Offset(
                                                                        0.0,
                                                                        6.75,
                                                                      ),
                                                                    )
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          4.0,
                                                                          8.0,
                                                                          4.0),
                                                                  child: Text(
                                                                    '${formatNumber(
                                                                      getJsonField(
                                                                        resultsFromReinvestCalcsItem,
                                                                        r'''$.netReturn''',
                                                                      ),
                                                                      formatType:
                                                                          FormatType
                                                                              .decimal,
                                                                      decimalType:
                                                                          DecimalType
                                                                              .automatic,
                                                                      currency:
                                                                          '',
                                                                    )} return',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 1.0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            44.28),
                                                                child:
                                                                    BackdropFilter(
                                                                  filter:
                                                                      ImageFilter
                                                                          .blur(
                                                                    sigmaX:
                                                                        18.98,
                                                                    sigmaY:
                                                                        18.98,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        1.0,
                                                                    height:
                                                                        50.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0x98FFFFFF),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              44.28),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                12.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  getJsonField(
                                                                                    resultsFromReinvestCalcsItem,
                                                                                    r'''$.method''',
                                                                                  ).toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).secondary,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  '${getJsonField(
                                                                                    resultsFromReinvestCalcsItem,
                                                                                    r'''$.bedrooms''',
                                                                                  ).toString()} Bd / ${getJsonField(
                                                                                    resultsFromReinvestCalcsItem,
                                                                                    r'''$.bathrooms''',
                                                                                  ).toString()} Ba ${getJsonField(
                                                                                    resultsFromReinvestCalcsItem,
                                                                                    r'''$.livingArea''',
                                                                                  ).toString()}sf',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).secondary,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Builder(
                                                                          builder: (context) =>
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                8.0,
                                                                                0.0),
                                                                            child:
                                                                                FFButtonWidget(
                                                                              onPressed: () async {
                                                                                logFirebaseEvent('SEARCH_PAGE_VIEW_BTN_ON_TAP');
                                                                                if (loggedIn) {
                                                                                  if (valueOrDefault(currentUserDocument?.tokens, 0) > 0) {
                                                                                    logFirebaseEvent('Button_backend_call');
                                                                                    unawaited(
                                                                                      () async {
                                                                                        await currentUserReference!.update({
                                                                                          ...mapToFirestore(
                                                                                            {
                                                                                              'tokens': FieldValue.increment(-(1)),
                                                                                            },
                                                                                          ),
                                                                                        });
                                                                                      }(),
                                                                                    );
                                                                                    logFirebaseEvent('Button_update_page_state');
                                                                                    _model.selectedProperty = null;
                                                                                    _model.selectedFieldSavedProperty = null;
                                                                                    _model.mapCoordinates = null;
                                                                                    safeSetState(() {});
                                                                                    logFirebaseEvent('Button_wait__delay');
                                                                                    await Future.delayed(
                                                                                      Duration(
                                                                                        milliseconds: 500,
                                                                                      ),
                                                                                    );
                                                                                    logFirebaseEvent('Button_update_page_state');
                                                                                    _model.selectedProperty = resultsFromReinvestCalcsItem;
                                                                                    _model.selectedFieldSavedProperty = null;
                                                                                    safeSetState(() {});
                                                                                    logFirebaseEvent('Button_update_page_state');
                                                                                    _model.mapCoordinates = functions.convertToLatLng(
                                                                                        valueOrDefault<double>(
                                                                                          getJsonField(
                                                                                            _model.selectedProperty,
                                                                                            r'''$.latlng.latitude''',
                                                                                          ),
                                                                                          1.0,
                                                                                        ),
                                                                                        valueOrDefault<double>(
                                                                                          getJsonField(
                                                                                            _model.selectedProperty,
                                                                                            r'''$.latlng.longitude''',
                                                                                          ),
                                                                                          1.0,
                                                                                        ));
                                                                                    _model.compCoordinates = functions.convertListsToLatLng(PropertyDetailsStruct.maybeFromMap(resultsFromReinvestCalcsItem)!.redfinSoldComps.map((e) => e.latLong.value.latitude).toList(), PropertyDetailsStruct.maybeFromMap(resultsFromReinvestCalcsItem)!.redfinSoldComps.map((e) => e.latLong.value.longitude).toList()).toList().cast<LatLng>();
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    logFirebaseEvent('Button_show_snack_bar');
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(
                                                                                        content: Text(
                                                                                          'Please purchase token to continue',
                                                                                          style: TextStyle(
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          ),
                                                                                        ),
                                                                                        duration: Duration(milliseconds: 4000),
                                                                                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                } else {
                                                                                  logFirebaseEvent('Button_alert_dialog');
                                                                                  await showDialog(
                                                                                    context: context,
                                                                                    builder: (dialogContext) {
                                                                                      return Dialog(
                                                                                        elevation: 0,
                                                                                        insetPadding: EdgeInsets.zero,
                                                                                        backgroundColor: Colors.transparent,
                                                                                        alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            FocusScope.of(dialogContext).unfocus();
                                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                                          },
                                                                                          child: AuthDialogueWidget(),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }
                                                                              },
                                                                              text: 'View',
                                                                              options: FFButtonOptions(
                                                                                height: 40.0,
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                    ),
                                                                                elevation: 0.0,
                                                                                borderRadius: BorderRadius.circular(42.38),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Visibility(
                                          visible: responsiveVisibility(
                                            context: context,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ),
                                          child: StreamBuilder<
                                              List<SavedPropertiesRecord>>(
                                            stream:
                                                querySavedPropertiesRecord(),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<SavedPropertiesRecord>
                                                  mobileSavedListViewSavedPropertiesRecordList =
                                                  snapshot.data!;

                                              return ListView.separated(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.0),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    mobileSavedListViewSavedPropertiesRecordList
                                                        .length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 12.0),
                                                itemBuilder: (context,
                                                    mobileSavedListViewIndex) {
                                                  final mobileSavedListViewSavedPropertiesRecord =
                                                      mobileSavedListViewSavedPropertiesRecordList[
                                                          mobileSavedListViewIndex];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                8.0, 0.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'SEARCH_PAGE_Container_dlhhza1t_ON_TAP');
                                                        if (valueOrDefault(
                                                                currentUserDocument
                                                                    ?.tokens,
                                                                0) >
                                                            0) {
                                                          logFirebaseEvent(
                                                              'ImageCard_backend_call');
                                                          unawaited(
                                                            () async {
                                                              await currentUserReference!
                                                                  .update({
                                                                ...mapToFirestore(
                                                                  {
                                                                    'tokens': FieldValue
                                                                        .increment(
                                                                            -(1)),
                                                                  },
                                                                ),
                                                              });
                                                            }(),
                                                          );
                                                          logFirebaseEvent(
                                                              'ImageCard_update_page_state');
                                                          _model.selectedProperty =
                                                              null;
                                                          _model.selectedFieldSavedProperty =
                                                              null;
                                                          _model.mapCoordinates =
                                                              null;
                                                          safeSetState(() {});
                                                          logFirebaseEvent(
                                                              'ImageCard_update_page_state');
                                                          _model.selectedFieldSavedProperty =
                                                              mobileSavedListViewSavedPropertiesRecord;
                                                          _model.mapCoordinates =
                                                              mobileSavedListViewSavedPropertiesRecord
                                                                  .latlng;
                                                          safeSetState(() {});
                                                          if (MediaQuery.sizeOf(
                                                                      context)
                                                                  .width <=
                                                              450.0) {
                                                            logFirebaseEvent(
                                                                'ImageCard_update_page_state');
                                                            _model.savedPropertiesMapView =
                                                                true;
                                                            safeSetState(() {});
                                                          }
                                                        } else {
                                                          logFirebaseEvent(
                                                              'ImageCard_show_snack_bar');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Please purchase token to continue',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: ImageCardWidget(
                                                        key: Key(
                                                            'Keydlh_${mobileSavedListViewIndex}_of_${mobileSavedListViewSavedPropertiesRecordList.length}'),
                                                        price:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .price,
                                                        address:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .address,
                                                        duration:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .duration,
                                                        method:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .method,
                                                        grossReturn:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .grossReturn,
                                                        totalCosts:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .totalCosts,
                                                        financingCosts:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .sellingCosts,
                                                        bedrooms:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .bedrooms,
                                                        baths:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .bathrooms,
                                                        livingArea:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .livingArea,
                                                        lotArea:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .lotAreaValue,
                                                        imgSrc:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .imgSrc,
                                                        zpid: FFAppConstants
                                                            .zipId
                                                            .toString(),
                                                        estimatedValue:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .zestimate,
                                                        downPayment:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .downPayment,
                                                        yearBuilt:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .yearBuilt,
                                                        loanAmount:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .loanAmount,
                                                        detailUrl:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .detailUrl,
                                                        cashNeeded:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .cashNeeded,
                                                        proposedClosedDate:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .purchCloseDate,
                                                        proposedSaleDate:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .saleCloseDate,
                                                        netReturn:
                                                            mobileSavedListViewSavedPropertiesRecord
                                                                .netReturn,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (_model.selectedFieldSavedProperty != null)
                        Expanded(
                          child: StreamBuilder<SavedPropertiesRecord>(
                            stream: SavedPropertiesRecord.getDocument(
                                _model.selectedFieldSavedProperty!.reference),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).secondary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final widgetScreenshotSavedPropertiesRecord =
                                  snapshot.data!;

                              return custom_widgets.WidgetScreenshot(
                                width: 50.0,
                                height: 50.0,
                                initialPosition: _model.mapCoordinates!,
                                markerCoordinates: _model.compCoordinates,
                                screenshotChild: () =>
                                    DetailComponentSearchNonEditableWidget(
                                  zpid:
                                      widgetScreenshotSavedPropertiesRecord.id,
                                  selectedFilter: '',
                                  dscr: widgetScreenshotSavedPropertiesRecord
                                      .dscr,
                                  image: widgetScreenshotSavedPropertiesRecord
                                      .imgSrc,
                                  impValue:
                                      widgetScreenshotSavedPropertiesRecord
                                          .impValue,
                                  ttlValue:
                                      widgetScreenshotSavedPropertiesRecord
                                          .totalValue,
                                  dwnPmt: widgetScreenshotSavedPropertiesRecord
                                      .downPayment,
                                  address: widgetScreenshotSavedPropertiesRecord
                                      .address,
                                  netRoi: widgetScreenshotSavedPropertiesRecord
                                      .netRoi,
                                  method: widgetScreenshotSavedPropertiesRecord
                                      .method,
                                  lvgArea: widgetScreenshotSavedPropertiesRecord
                                      .livingArea,
                                  purchClosedDate:
                                      widgetScreenshotSavedPropertiesRecord
                                          .purchCloseDate,
                                  beds: widgetScreenshotSavedPropertiesRecord
                                      .bedrooms,
                                  lotAreaValue:
                                      widgetScreenshotSavedPropertiesRecord
                                          .lotAreaValue,
                                  loanPayments:
                                      widgetScreenshotSavedPropertiesRecord
                                          .loanPayments,
                                  loanFees:
                                      widgetScreenshotSavedPropertiesRecord
                                          .loanFees,
                                  pptyTaxIns:
                                      widgetScreenshotSavedPropertiesRecord
                                          .propertyTaxIns,
                                  baths: widgetScreenshotSavedPropertiesRecord
                                      .bathrooms,
                                  permitsFees:
                                      widgetScreenshotSavedPropertiesRecord
                                          .permitFees,
                                  improvements:
                                      widgetScreenshotSavedPropertiesRecord
                                          .impValue,
                                  futValue:
                                      widgetScreenshotSavedPropertiesRecord
                                          .futureValue,
                                  sellingCosts:
                                      widgetScreenshotSavedPropertiesRecord
                                          .sellingCosts,
                                  netReturn:
                                      widgetScreenshotSavedPropertiesRecord
                                          .netReturn,
                                  cashOnCash:
                                      widgetScreenshotSavedPropertiesRecord
                                          .cashOnCashReturn,
                                  map2: widgetScreenshotSavedPropertiesRecord
                                      .latlng,
                                  price: widgetScreenshotSavedPropertiesRecord
                                      .price,
                                  duration:
                                      widgetScreenshotSavedPropertiesRecord
                                          .duration,
                                  saleCloseDate:
                                      widgetScreenshotSavedPropertiesRecord
                                          .saleCloseDate,
                                  totalCosts:
                                      widgetScreenshotSavedPropertiesRecord
                                          .totalCosts,
                                  detailUrl:
                                      widgetScreenshotSavedPropertiesRecord
                                          .detailUrl,
                                  avgCompSsF: 0.0,
                                  futureValueSsF: 0.0,
                                  avgPricePerArea:
                                      widgetScreenshotSavedPropertiesRecord
                                          .pricePerSqft
                                          .toDouble(),
                                  futureArea:
                                      widgetScreenshotSavedPropertiesRecord
                                          .futureArea,
                                  futureBeds:
                                      widgetScreenshotSavedPropertiesRecord
                                          .futureBeds,
                                  futureBaths:
                                      widgetScreenshotSavedPropertiesRecord
                                          .futureBaths,
                                  rentEstimate:
                                      widgetScreenshotSavedPropertiesRecord
                                          .rentZestimate,
                                  capRate: 0.0,
                                  irr:
                                      widgetScreenshotSavedPropertiesRecord.irr,
                                  compsAvgPricePerBdrm:
                                      widgetScreenshotSavedPropertiesRecord
                                          .calculateBedroomPriceAverages,
                                  rentPerSqft: 0,
                                  description:
                                      widgetScreenshotSavedPropertiesRecord
                                          .description,
                                  estimatedValue:
                                      widgetScreenshotSavedPropertiesRecord
                                          .zestimate,
                                  downPayment:
                                      widgetScreenshotSavedPropertiesRecord
                                          .downPayment,
                                  yearBuilt:
                                      widgetScreenshotSavedPropertiesRecord
                                          .yearBuilt,
                                  loanAmount:
                                      widgetScreenshotSavedPropertiesRecord
                                          .loanAmount,
                                  cashNeeded:
                                      widgetScreenshotSavedPropertiesRecord
                                          .cashNeeded,
                                  redfinSoldComps:
                                      widgetScreenshotSavedPropertiesRecord
                                          .redfinSoldComps,
                                  redfinForSaleComps:
                                      widgetScreenshotSavedPropertiesRecord
                                          .redfinForSaleComps,
                                  roe:
                                      widgetScreenshotSavedPropertiesRecord.roe,
                                  groc: widgetScreenshotSavedPropertiesRecord
                                      .groc,
                                  grossReturn:
                                      widgetScreenshotSavedPropertiesRecord
                                          .grossReturn,
                                  propTaxIns:
                                      widgetScreenshotSavedPropertiesRecord
                                          .propertyIns,
                                  savedDocRef: _model
                                      .selectedFieldSavedProperty?.reference,
                                  avgCompPrice:
                                      widgetScreenshotSavedPropertiesRecord
                                          .avgCompPrice,
                                  totalReturn:
                                      widgetScreenshotSavedPropertiesRecord
                                          .totalReturn,
                                  netRentalIncome5yrs:
                                      widgetScreenshotSavedPropertiesRecord
                                          .netRetnalIncome5yrs,
                                  onClose: () async {
                                    logFirebaseEvent(
                                        'SEARCH_PAGE_Container_b6x5oa47_CALLBACK');
                                    logFirebaseEvent(
                                        'WidgetScreenshot_update_page_state');
                                    _model.selectedProperty = null;
                                    _model.selectedFieldSavedProperty = null;
                                    _model.mapCoordinates = null;
                                    safeSetState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      if ((_model.selectedFieldSavedProperty != null) &&
                          responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                          ))
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (responsiveVisibility(
                              context: context,
                              phone: false,
                              tablet: false,
                            ))
                              Expanded(
                                child: Container(
                                  width: 300.0,
                                  height: 398.1,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Visibility(
                                    visible: responsiveVisibility(
                                      context: context,
                                      phone: false,
                                      tablet: false,
                                    ),
                                    child: custom_widgets.CustomMap(
                                      width: 200.0,
                                      height: 300.0,
                                      zoomSetting: 12.0,
                                      coordinates: _model.mapCoordinates!,
                                      compCoordinates: _model.compCoordinates,
                                      markerImage:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/xsau1zr68pie/Group_30.svg',
                                      markerImage2:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/hk29nneiyjab/Group_27.svg',
                                      markerImage3:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/hk29nneiyjab/Group_27.svg',
                                    ),
                                  ),
                                ),
                              ),
                            if (responsiveVisibility(
                              context: context,
                              phone: false,
                              tablet: false,
                            ))
                              Expanded(
                                child: Container(
                                  width: 300.0,
                                  height: 417.6,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Visibility(
                                    visible: responsiveVisibility(
                                      context: context,
                                      phone: false,
                                      tablet: false,
                                    ),
                                    child: custom_widgets.CustomMap(
                                      width: 200.0,
                                      height: 300.0,
                                      zoomSetting: 19.0,
                                      coordinates: _model.mapCoordinates!,
                                      compCoordinates: _model.compCoordinates,
                                      markerImage:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/xsau1zr68pie/Group_30.svg',
                                      markerImage2:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/hk29nneiyjab/Group_27.svg',
                                      markerImage3:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/habu-1gxak2/assets/hk29nneiyjab/Group_27.svg',
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (!(_model.reInvestCalcsCombined.isNotEmpty) &&
                          !(_model.searchReinvestCalcsComb.isNotEmpty))
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Lottie.asset(
                              'assets/jsons/Trail_loading.json',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.contain,
                              animate: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4.0,
                            sigmaY: 4.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x67FFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x3F000000),
                                  offset: Offset(
                                    0.0,
                                    4.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: Visibility(
                              visible: responsiveVisibility(
                                context: context,
                                tabletLandscape: false,
                                desktop: false,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FlutterFlowIconButton(
                                    borderRadius: 35.0,
                                    buttonSize: 40.0,
                                    fillColor: _model.selectedTab == 'search'
                                        ? Color(0x00FFFFFF)
                                        : FlutterFlowTheme.of(context)
                                            .secondary,
                                    icon: Icon(
                                      Icons.save_alt,
                                      color: _model.selectedTab == 'search'
                                          ? FlutterFlowTheme.of(context)
                                              .secondary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'SEARCH_PAGE_save_alt_ICN_ON_TAP');
                                      logFirebaseEvent(
                                          'IconButton_update_page_state');
                                      _model.selectedTab = 'saved';
                                      safeSetState(() {});
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 35.0,
                                    buttonSize: 40.0,
                                    fillColor: _model.selectedTab == 'search'
                                        ? FlutterFlowTheme.of(context).secondary
                                        : Color(0x00FFFFFF),
                                    icon: Icon(
                                      Icons.search_sharp,
                                      color: _model.selectedTab == 'search'
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                          : FlutterFlowTheme.of(context)
                                              .secondary,
                                      size: 24.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'SEARCH_PAGE_search_sharp_ICN_ON_TAP');
                                      logFirebaseEvent(
                                          'IconButton_update_page_state');
                                      _model.selectedTab = 'search';
                                      safeSetState(() {});
                                    },
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
