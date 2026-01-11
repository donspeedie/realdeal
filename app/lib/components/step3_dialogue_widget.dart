import '/components/step1_dialogue_widget.dart';
import '/components/step2_dialogue_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'step3_dialogue_model.dart';
export 'step3_dialogue_model.dart';

class Step3DialogueWidget extends StatefulWidget {
  const Step3DialogueWidget({
    super.key,
    required this.loadProperty,
  });

  final Future Function()? loadProperty;

  @override
  State<Step3DialogueWidget> createState() => _Step3DialogueWidgetState();
}

class _Step3DialogueWidgetState extends State<Step3DialogueWidget> {
  late Step3DialogueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Step3DialogueModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('STEP3_DIALOGUE_Step3Dialogue_ON_INIT_STA');
      logFirebaseEvent('Step3Dialogue_execute_callback');
      await widget.loadProperty?.call();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(48.0, 0.0, 0.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            maxWidth: 300.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'The automated performa gives you a running start. Review and adjust the After Repair Value, Improvements, and any other costs you want to account for. ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      TextSpan(
                        text: 'Canges will be automatically saved ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      TextSpan(
                        text: 'and returns recalculated.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      )
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                  child: Text(
                    'You can customise your calculator settings by selecting the User profile setting in the top right.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
                Text(
                  '(3 of 3)',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) => FlutterFlowIconButton(
                        borderColor: FlutterFlowTheme.of(context).primaryText,
                        borderRadius: 40.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).alternate,
                        icon: Icon(
                          Icons.navigate_next,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        showLoadingIndicator: true,
                        onPressed: () async {
                          logFirebaseEvent(
                              'STEP3_DIALOGUE_navigate_next_ICN_ON_TAP');
                          logFirebaseEvent('IconButton_dismiss_dialog');
                          Navigator.pop(context);
                          logFirebaseEvent('IconButton_alert_dialog');
                          await showDialog(
                            barrierColor: Color(0x34000000),
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(-1.0, 0.0)
                                    .resolve(Directionality.of(context)),
                                child: Step1DialogueWidget(
                                  loadProperty: () async {
                                    logFirebaseEvent('_wait__delay');
                                    await Future.delayed(
                                      Duration(
                                        milliseconds: 100,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Builder(
                      builder: (context) => FlutterFlowIconButton(
                        borderColor: FlutterFlowTheme.of(context).primaryText,
                        borderRadius: 40.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).alternate,
                        icon: Icon(
                          Icons.navigate_next,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        showLoadingIndicator: true,
                        onPressed: () async {
                          logFirebaseEvent(
                              'STEP3_DIALOGUE_navigate_next_ICN_ON_TAP');
                          logFirebaseEvent('IconButton_dismiss_dialog');
                          Navigator.pop(context);
                          logFirebaseEvent('IconButton_alert_dialog');
                          await showDialog(
                            barrierColor: Color(0x34000000),
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(-1.0, -1.0)
                                    .resolve(Directionality.of(context)),
                                child: Step2DialogueWidget(
                                  loadProperty: () async {
                                    logFirebaseEvent('_execute_callback');
                                    await widget.loadProperty?.call();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).primaryText,
                      borderRadius: 40.0,
                      buttonSize: 40.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.navigate_next,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      showLoadingIndicator: true,
                      onPressed: true
                          ? null
                          : () async {
                              logFirebaseEvent(
                                  'STEP3_DIALOGUE_navigate_next_ICN_ON_TAP');
                              logFirebaseEvent('IconButton_dismiss_dialog');
                              Navigator.pop(context);
                            },
                    ),
                  ].divide(SizedBox(width: 12.0)).around(SizedBox(width: 12.0)),
                ),
              ].divide(SizedBox(height: 8.0)).around(SizedBox(height: 8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
