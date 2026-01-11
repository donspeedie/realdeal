import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'buy_tokens_model.dart';
export 'buy_tokens_model.dart';

class BuyTokensWidget extends StatefulWidget {
  const BuyTokensWidget({super.key});

  @override
  State<BuyTokensWidget> createState() => _BuyTokensWidgetState();
}

class _BuyTokensWidgetState extends State<BuyTokensWidget> {
  late BuyTokensModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BuyTokensModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(35.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: FutureBuilder<ApiCallResponse>(
          future: StripeAPIsGroup.listAllProductsCall.call(),
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
            final containerListAllProductsResponse = snapshot.data!;

            return AnimatedContainer(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 300.0,
              constraints: BoxConstraints(
                maxWidth: 448.0,
                maxHeight: 448.0,
              ),
              decoration: BoxDecoration(
                color: Color(0x66FFFFFF),
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 12.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          logFirebaseEvent(
                              'BUY_TOKENS_COMP_Icon_f8y5csan_ON_TAP');
                          logFirebaseEvent('Icon_close_dialog_drawer_etc');
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.add_card,
                    color: FlutterFlowTheme.of(context).secondary,
                    size: 80.0,
                  ),
                  Text(
                    'Hello World',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Builder(
                    builder: (context) {
                      final data = StripeAPIsGroup.listAllProductsCall
                              .data(
                                containerListAllProductsResponse.jsonBody,
                              )
                              ?.toList() ??
                          [];

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(data.length, (dataIndex) {
                          final dataItem = data[dataIndex];
                          return Expanded(
                            child: FutureBuilder<ApiCallResponse>(
                              future: StripeAPIsGroup.getPriceCall.call(
                                priceId: getJsonField(
                                  dataItem,
                                  r'''$.default_price''',
                                ).toString(),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final columnGetPriceResponse = snapshot.data!;

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FFButtonWidget(
                                      onPressed:
                                          (FFAppState().selectedProduct ==
                                                  dataItem)
                                              ? null
                                              : () async {
                                                  logFirebaseEvent(
                                                      'BUY_TOKENS_COMP_Button_5c3j2ygt_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Button_update_app_state');
                                                  FFAppState().selectedProduct =
                                                      dataItem;
                                                  safeSetState(() {});
                                                },
                                      text: formatNumber(
                                        (StripeAPIsGroup.getPriceCall.unitAmout(
                                              columnGetPriceResponse.jsonBody,
                                            )!) /
                                            100,
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.automatic,
                                        currency: '',
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            29.0, 16.0, 29.0, 16.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Color(0xFF1D4F7D),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(39.0),
                                        disabledColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        disabledTextColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                      ),
                                    ),
                                    Text(
                                      getJsonField(
                                        dataItem,
                                        r'''$.name''',
                                      ).toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 7.0)),
                                );
                              },
                            ),
                          );
                        })
                            .divide(SizedBox(width: 8.0))
                            .addToStart(SizedBox(width: 24.0))
                            .addToEnd(SizedBox(width: 24.0)),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent('BUY_TOKENS_COMP_BUY_BTN_ON_TAP');
                        if (FFAppState().selectedProduct != null) {
                          if (valueOrDefault(
                                      currentUserDocument?.stripeCustomerId,
                                      '') ==
                                  '') {
                            logFirebaseEvent('Button_backend_call');
                            _model.createCustomer =
                                await StripeAPIsGroup.createCustomerCall.call(
                              email: currentUserEmail,
                            );

                            if (!(_model.createCustomer?.succeeded ?? true)) {
                              logFirebaseEvent('Button_alert_dialog');
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Unable to create customer'),
                                    content: Text(
                                        (_model.createCustomer?.jsonBody ?? '')
                                            .toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            logFirebaseEvent('Button_backend_call');

                            await currentUserReference!
                                .update(createUserDataRecordData(
                              stripeCustomerId: getJsonField(
                                (_model.createCustomer?.jsonBody ?? ''),
                                r'''$.id''',
                              ).toString(),
                            ));
                          } else {
                            logFirebaseEvent('Button_show_snack_bar');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Customer found',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          }

                          logFirebaseEvent('Button_backend_call');
                          _model.createCheckout = await StripeAPIsGroup
                              .createCheckoutSessionCall
                              .call(
                            successUrl:
                                FFDevEnvironmentValues().paymentSuccessUrl,
                            lineItems0PriceId: getJsonField(
                              FFAppState().selectedProduct,
                              r'''$.default_price''',
                            ).toString(),
                            lineItems0Quantity: 1,
                            customer: valueOrDefault(
                                currentUserDocument?.stripeCustomerId, ''),
                            token: int.parse(getJsonField(
                              FFAppState().selectedProduct,
                              r'''$.metadata.token''',
                            ).toString()),
                          );

                          if ((_model.createCheckout?.succeeded ?? true)) {
                            logFirebaseEvent('Button_launch_u_r_l');
                            await launchURL(getJsonField(
                              (_model.createCheckout?.jsonBody ?? ''),
                              r'''$.url''',
                            ).toString());
                          } else {
                            logFirebaseEvent('Button_alert_dialog');
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('Unable to checkout'),
                                  content: Text(
                                      (_model.createCheckout?.jsonBody ?? '')
                                          .toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a product to purchase',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                        }

                        safeSetState(() {});
                      },
                      text: 'Buy',
                      options: FFButtonOptions(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            123.0, 20.0, 131.0, 20.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(39.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
