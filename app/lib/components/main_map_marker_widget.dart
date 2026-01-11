import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'main_map_marker_model.dart';
export 'main_map_marker_model.dart';

class MainMapMarkerWidget extends StatefulWidget {
  const MainMapMarkerWidget({
    super.key,
    required this.property,
    required this.onPropertyTap,
  });

  final dynamic property;
  final Future Function(String zpid, String method)? onPropertyTap;

  @override
  State<MainMapMarkerWidget> createState() => _MainMapMarkerWidgetState();
}

class _MainMapMarkerWidgetState extends State<MainMapMarkerWidget> {
  late MainMapMarkerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainMapMarkerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          logFirebaseEvent('MAIN_MAP_MARKER_Container_c8uql00a_ON_TA');
          logFirebaseEvent('Container_execute_callback');
          await widget.onPropertyTap?.call(
            getJsonField(
              widget.property,
              r'''$.zpid''',
            ).toString(),
            getJsonField(
              widget.property,
              r'''$.method''',
            ).toString(),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              formatNumber(
                valueOrDefault<int>(
                  getJsonField(
                    widget.property,
                    r'''$.netReturn''',
                  ),
                  0,
                ),
                formatType: FormatType.compact,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
