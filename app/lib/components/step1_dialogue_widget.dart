import '/components/step2_dialogue_widget.dart';
import '/components/step3_dialogue_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'step1_dialogue_model.dart';
export 'step1_dialogue_model.dart';

class Step1DialogueWidget extends StatefulWidget {
  const Step1DialogueWidget({
    super.key,
    this.loadProperty,
  });

  final Future Function()? loadProperty;

  @override
  State<Step1DialogueWidget> createState() => _Step1DialogueWidgetState();
}

class _Step1DialogueWidgetState extends State<Step1DialogueWidget>
    with TickerProviderStateMixin {
  late Step1DialogueModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Step1DialogueModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 80.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
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
      padding: EdgeInsetsDirectional.fromSTEB(192.0, 0.0, 0.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            maxWidth: 350.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thanks for checking us out!',
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(48.0, 12.0, 48.0, 12.0),
                  child: Text(
                    'Right now the app is analyzing all available residential investment deals in your areas. ',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Text(
                    'You can select a marker on the map or a picture on the left side to see more details',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Text(
                    '(1 of 3)',
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                              'STEP1_DIALOGUE_navigate_next_ICN_ON_TAP');
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
                              'STEP1_DIALOGUE_navigate_next_ICN_ON_TAP');
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
              ].divide(SizedBox(height: 12.0)).around(SizedBox(height: 12.0)),
            ),
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
