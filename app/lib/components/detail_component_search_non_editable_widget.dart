import '/backend/backend.dart';
import '/components/budget_component_search_editable_widget.dart';
import '/components/comp_card_redfin_widget.dart';
import '/components/description_i_i_widget.dart';
import '/components/image_card_widget.dart';
import '/components/summaryof_returns_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'detail_component_search_non_editable_model.dart';
export 'detail_component_search_non_editable_model.dart';

class DetailComponentSearchNonEditableWidget extends StatefulWidget {
  const DetailComponentSearchNonEditableWidget({
    super.key,
    this.image,
    this.impValue,
    this.ttlValue,
    this.dwnPmt,
    this.address,
    this.netRoi,
    this.method,
    this.lvgArea,
    this.purchClosedDate,
    this.beds,
    this.lotAreaValue,
    this.loanPayments,
    this.loanFees,
    this.pptyTaxIns,
    this.baths,
    this.permitsFees,
    this.improvements,
    this.futValue,
    this.sellingCosts,
    this.netReturn,
    this.cashOnCash,
    this.map2,
    this.price,
    this.duration,
    this.saleCloseDate,
    this.totalCosts,
    this.detailUrl,
    this.avgCompSsF,
    this.futureValueSsF,
    required this.zpid,
    required this.selectedFilter,
    this.avgPricePerArea,
    this.futureArea,
    this.futureBeds,
    this.futureBaths,
    this.rentEstimate,
    this.capRate,
    required this.dscr,
    this.irr,
    this.compsAvgPricePerBdrm,
    this.rentPerSqft,
    required this.description,
    this.estimatedValue,
    this.downPayment,
    this.yearBuilt,
    this.loanAmount,
    this.cashNeeded,
    required this.redfinSoldComps,
    required this.redfinForSaleComps,
    required this.onClose,
    this.roe,
    this.groc,
    this.grossReturn,
    this.propTaxIns,
    this.savedDocRef,
    required this.avgCompPrice,
    this.totalReturn,
    int? netRentalIncome5yrs,
  }) : this.netRentalIncome5yrs = netRentalIncome5yrs ?? 0;

  final String? image;
  final int? impValue;
  final int? ttlValue;
  final int? dwnPmt;
  final String? address;
  final double? netRoi;
  final String? method;
  final int? lvgArea;
  final DateTime? purchClosedDate;
  final int? beds;
  final double? lotAreaValue;
  final int? loanPayments;
  final int? loanFees;
  final int? pptyTaxIns;
  final int? baths;
  final int? permitsFees;
  final int? improvements;
  final int? futValue;
  final int? sellingCosts;
  final int? netReturn;
  final double? cashOnCash;
  final LatLng? map2;
  final int? price;
  final int? duration;
  final DateTime? saleCloseDate;
  final int? totalCosts;
  final String? detailUrl;

  /// avg Comps $/SF Rate for comparison
  final double? avgCompSsF;

  final double? futureValueSsF;
  final String? zpid;
  final String? selectedFilter;

  /// for comps data only
  final double? avgPricePerArea;

  final int? futureArea;
  final int? futureBeds;
  final int? futureBaths;
  final int? rentEstimate;
  final double? capRate;
  final double? dscr;
  final double? irr;
  final int? compsAvgPricePerBdrm;
  final int? rentPerSqft;
  final String? description;
  final int? estimatedValue;
  final int? downPayment;
  final int? yearBuilt;
  final int? loanAmount;
  final int? cashNeeded;
  final List<RedfinHomeDataStruct>? redfinSoldComps;
  final List<RedfinHomeDataStruct>? redfinForSaleComps;
  final Future Function()? onClose;
  final double? roe;
  final double? groc;
  final int? grossReturn;
  final int? propTaxIns;
  final DocumentReference? savedDocRef;
  final int? avgCompPrice;
  final int? totalReturn;
  final int netRentalIncome5yrs;

  @override
  State<DetailComponentSearchNonEditableWidget> createState() =>
      _DetailComponentSearchNonEditableWidgetState();
}

class _DetailComponentSearchNonEditableWidgetState
    extends State<DetailComponentSearchNonEditableWidget> {
  late DetailComponentSearchNonEditableModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => DetailComponentSearchNonEditableModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.close,
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 24.0,
                ),
                showLoadingIndicator: true,
                onPressed: () async {
                  logFirebaseEvent('DETAIL_COMPONENT_SEARCH_NON_EDITABLE_clo');
                  logFirebaseEvent('IconButton_execute_callback');
                  await widget.onClose?.call();
                },
              ),
              FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.restart_alt,
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 24.0,
                ),
                showLoadingIndicator: true,
                onPressed: () async {
                  logFirebaseEvent('DETAIL_COMPONENT_SEARCH_NON_EDITABLE_res');
                  logFirebaseEvent('IconButton_backend_call');
                  await widget.savedDocRef!.delete();
                  logFirebaseEvent('IconButton_execute_callback');
                  await widget.onClose?.call();
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
            child: wrapWithModel(
              model: _model.imageCardModel,
              updateCallback: () => safeSetState(() {}),
              updateOnChange: true,
              child: ImageCardWidget(
                price: valueOrDefault<int>(
                  widget.price,
                  500000,
                ),
                address: widget.address,
                duration: valueOrDefault<int>(
                  widget.duration,
                  9,
                ),
                method: valueOrDefault<String>(
                  widget.method,
                  'test',
                ),
                grossReturn: valueOrDefault<int>(
                  widget.netReturn,
                  30000,
                ),
                totalCosts: valueOrDefault<int>(
                  widget.totalCosts,
                  600000,
                ),
                financingCosts: valueOrDefault<int>(
                  widget.loanPayments,
                  1234,
                ),
                bedrooms: valueOrDefault<int>(
                  widget.beds,
                  3,
                ),
                baths: valueOrDefault<int>(
                  widget.baths,
                  2,
                ),
                livingArea: valueOrDefault<int>(
                  widget.lvgArea,
                  1234,
                ),
                lotArea: widget.lotAreaValue,
                proposedClosedDate: widget.purchClosedDate,
                proposedSaleDate: widget.saleCloseDate,
                imgSrc: valueOrDefault<String>(
                  widget.image,
                  'imgSrc',
                ),
                zpid: valueOrDefault<String>(
                  widget.zpid,
                  '1234',
                ),
                estimatedValue: valueOrDefault<int>(
                  widget.estimatedValue,
                  1234,
                ),
                downPayment: widget.dwnPmt,
                yearBuilt: valueOrDefault<int>(
                  widget.yearBuilt,
                  1900,
                ),
                loanAmount: valueOrDefault<int>(
                  widget.loanAmount,
                  1,
                ),
                detailUrl: widget.detailUrl,
                cashNeeded: widget.cashNeeded,
                netReturn: widget.netReturn!,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
            child: wrapWithModel(
              model: _model.budgetComponentSearchEditableModel,
              updateCallback: () => safeSetState(() {}),
              updateOnChange: true,
              child: BudgetComponentSearchEditableWidget(
                price: valueOrDefault<int>(
                  widget.price,
                  1,
                ),
                loanPayments: valueOrDefault<int>(
                  widget.loanPayments,
                  1,
                ),
                propertyTaxIns: valueOrDefault<int>(
                  widget.pptyTaxIns,
                  1,
                ),
                permitsFees: valueOrDefault<int>(
                  widget.permitsFees,
                  1,
                ),
                impValue: valueOrDefault<int>(
                  widget.impValue,
                  1,
                ),
                futureValue: valueOrDefault<int>(
                  widget.futValue,
                  1,
                ),
                sellingCosts: valueOrDefault<int>(
                  widget.sellingCosts,
                  1,
                ),
                netRtn: valueOrDefault<int>(
                  widget.netReturn,
                  1,
                ),
                totalCosts: valueOrDefault<int>(
                  widget.totalCosts,
                  1,
                ),
                netReturn: valueOrDefault<int>(
                  widget.netReturn,
                  1,
                ),
                loanFees: valueOrDefault<int>(
                  widget.loanFees,
                  1,
                ),
                livingArea: valueOrDefault<int>(
                  widget.lvgArea,
                  1,
                ),
                futureArea: valueOrDefault<int>(
                  widget.futureArea,
                  1,
                ),
                grossReturn: widget.grossReturn,
                estimatedValue: widget.estimatedValue,
                loanAmount: widget.loanAmount,
                savedDocRef: widget.savedDocRef!,
                estimatedRentalIncome: widget.rentEstimate,
                rentEstimate: widget.rentEstimate,
                method: widget.method!,
                totalReturn: widget.totalReturn,
                netRentalIncome5yrs: widget.netRentalIncome5yrs,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: wrapWithModel(
                model: _model.summaryofReturnsModel,
                updateCallback: () => safeSetState(() {}),
                updateOnChange: true,
                child: SummaryofReturnsWidget(
                  cashOnCash: valueOrDefault<double>(
                    widget.cashOnCash,
                    1.0,
                  ),
                  netRoi: widget.netRoi,
                  irr: widget.irr,
                  capRate: valueOrDefault<double>(
                    widget.capRate,
                    1.0,
                  ),
                  dscr: valueOrDefault<double>(
                    widget.dscr,
                    1.0,
                  ),
                  roe: widget.roe,
                  groc: widget.groc,
                  method: widget.method!,
                ),
              ),
            ),
          ),
          wrapWithModel(
            model: _model.descriptionIIModel,
            updateCallback: () => safeSetState(() {}),
            child: DescriptionIIWidget(
              description: widget.description,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
            child: Text(
              'Comps that recently sold in the area',
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondary,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Average \$/Comp',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        formatNumber(
                          widget.avgCompPrice,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: '',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: 0.0,
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Text(
                          'Avg \$ / Comp',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Average \$/SF',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        formatNumber(
                          widget.avgPricePerArea,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.automatic,
                          currency: '',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: 0.0,
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Text(
                          'Avg \$ / Comp',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            formatNumber(
                              widget.avgPricePerArea,
                              formatType: FormatType.custom,
                              format: '#,###',
                              locale: '',
                            ),
                            '1',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Avg \$/Bdrm',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      formatNumber(
                        widget.compsAvgPricePerBdrm,
                        formatType: FormatType.decimal,
                        decimalType: DecimalType.automatic,
                        currency: '',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                ].divide(SizedBox(width: 15.0)).around(SizedBox(width: 15.0)),
              ),
            ),
          ),
          Container(
            height: 250.0,
            constraints: BoxConstraints(
              maxWidth: 800.0,
            ),
            decoration: BoxDecoration(),
            child: Builder(
              builder: (context) {
                final comp = widget.redfinSoldComps!.toList();

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: comp.length,
                  itemBuilder: (context, compIndex) {
                    final compItem = comp[compIndex];
                    return Stack(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      children: [
                        CompCardRedfinWidget(
                          key: Key('Keyq2f_${compIndex}_of_${comp.length}'),
                          comp1Img: compItem.photos.items.firstOrNull,
                          comp1Value: compItem.price.value,
                          comp1LvgArea: compItem.sqFt.value.toDouble(),
                          comp1Beds: compItem.beds.toDouble(),
                          comp1Baths: compItem.baths,
                          comp1LotArea: compItem.lotSize.value.toDouble(),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).error,
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).info,
                            size: 24.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            logFirebaseEvent(
                                'DETAIL_COMPONENT_SEARCH_NON_EDITABLE_clo');
                            logFirebaseEvent('IconButton_alert_dialog');
                            var confirmDialogResponse = await showDialog<bool>(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Delete Comp'),
                                      content: Text(
                                          'Are you sure you want to delete this comp'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, true),
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                ) ??
                                false;
                            if (confirmDialogResponse) {
                              logFirebaseEvent('IconButton_backend_call');

                              await widget.savedDocRef!.update({
                                ...mapToFirestore(
                                  {
                                    'redfinSoldComps': FieldValue.arrayRemove([
                                      getRedfinHomeDataFirestoreData(
                                        updateRedfinHomeDataStruct(
                                          compItem,
                                          clearUnsetFields: false,
                                        ),
                                        true,
                                      )
                                    ]),
                                  },
                                ),
                              });
                              logFirebaseEvent('IconButton_wait__delay');
                              await Future.delayed(
                                Duration(
                                  milliseconds: 5000,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 0.0, 0.0),
            child: Text(
              'Comps for sale in the area',
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondary,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
          Container(
            height: 250.0,
            constraints: BoxConstraints(
              maxWidth: 800.0,
            ),
            decoration: BoxDecoration(),
            child: Builder(
              builder: (context) {
                final comp = widget.redfinForSaleComps!.toList();

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: comp.length,
                  itemBuilder: (context, compIndex) {
                    final compItem = comp[compIndex];
                    return Stack(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      children: [
                        CompCardRedfinWidget(
                          key: Key('Key6p8_${compIndex}_of_${comp.length}'),
                          comp1Img: compItem.photos.items.firstOrNull,
                          comp1Value: valueOrDefault<double>(
                            compItem.price.value,
                            0.0,
                          ),
                          comp1LvgArea: valueOrDefault<double>(
                            compItem.sqFt.value.toDouble(),
                            0.0,
                          ),
                          comp1Beds: valueOrDefault<double>(
                            compItem.beds.toDouble(),
                            0.0,
                          ),
                          comp1Baths: valueOrDefault<double>(
                            compItem.baths,
                            0.0,
                          ),
                          comp1LotArea: valueOrDefault<double>(
                            compItem.lotSize.value.toDouble(),
                            0.0,
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).error,
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).info,
                            size: 24.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            logFirebaseEvent(
                                'DETAIL_COMPONENT_SEARCH_NON_EDITABLE_clo');
                            logFirebaseEvent('IconButton_alert_dialog');
                            var confirmDialogResponse = await showDialog<bool>(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Delete Comp'),
                                      content: Text(
                                          'Are you sure you want to delete this comp'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, true),
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                ) ??
                                false;
                            if (confirmDialogResponse) {
                              logFirebaseEvent('IconButton_backend_call');

                              await widget.savedDocRef!.update({
                                ...mapToFirestore(
                                  {
                                    'redfinForSaleComps':
                                        FieldValue.arrayRemove([
                                      getRedfinHomeDataFirestoreData(
                                        updateRedfinHomeDataStruct(
                                          compItem,
                                          clearUnsetFields: false,
                                        ),
                                        true,
                                      )
                                    ]),
                                  },
                                ),
                              });
                              logFirebaseEvent('IconButton_wait__delay');
                              await Future.delayed(
                                Duration(
                                  milliseconds: 5000,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
