import '/components/step1_dialogue_widget.dart';
import '/components/step3_dialogue_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'step2_dialogue_model.dart';
export 'step2_dialogue_model.dart';

class Step2DialogueWidget extends StatefulWidget {
  const Step2DialogueWidget({
    super.key,
    required this.loadProperty,
  });

  final Future Function()? loadProperty;

  @override
  State<Step2DialogueWidget> createState() => _Step2DialogueWidgetState();
}

class _Step2DialogueWidgetState extends State<Step2DialogueWidget> {
  late Step2DialogueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Step2DialogueModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(350.0, 24.0, 0.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: 300.0,
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
            padding: EdgeInsetsDirectional.fromSTEB(18.0, 12.0, 18.0, 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Use the filters to focus on a investment strategy that you want to see.',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                  child: Text(
                    'When you see a property that looks interesting, select View to see the automated performance (costs one token)',
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
                  '(2 of 3)',
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
                              'STEP2_DIALOGUE_navigate_next_ICN_ON_TAP');
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
                          : () {
                              print('IconButton pressed ...');
                            },
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
                              'STEP2_DIALOGUE_navigate_next_ICN_ON_TAP');
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
                                child: Step3DialogueWidget(
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
