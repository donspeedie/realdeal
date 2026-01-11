import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'on_payment_success_model.dart';
export 'on_payment_success_model.dart';

class OnPaymentSuccessWidget extends StatefulWidget {
  const OnPaymentSuccessWidget({
    super.key,
    required this.coins,
    required this.checkoutId,
  });

  final int? coins;
  final String? checkoutId;

  static String routeName = 'OnPaymentSuccess';
  static String routePath = '/onPaymentSuccess';

  @override
  State<OnPaymentSuccessWidget> createState() => _OnPaymentSuccessWidgetState();
}

class _OnPaymentSuccessWidgetState extends State<OnPaymentSuccessWidget> {
  late OnPaymentSuccessModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnPaymentSuccessModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'OnPaymentSuccess'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('ON_PAYMENT_SUCCESS_OnPaymentSuccess_ON_I');
      logFirebaseEvent('OnPaymentSuccess_wait__delay');
      await Future.delayed(
        Duration(
          milliseconds: 3000,
        ),
      );
      logFirebaseEvent('OnPaymentSuccess_navigate_to');

      context.pushNamed(SearchWidget.routeName);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        title: 'OnPaymentSuccess',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondary,
              automaticallyImplyLeading: false,
              title: Text(
                'Checkout Session',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).headlineMediumFamily,
                      color: Colors.white,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Lottie.asset(
                      'assets/jsons/Animation_-_1749573908587.json',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                      animate: true,
                    ),
                  ),
                  Text(
                    'Please wait we are processing your request.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
