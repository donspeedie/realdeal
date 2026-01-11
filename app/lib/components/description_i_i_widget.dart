import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'description_i_i_model.dart';
export 'description_i_i_model.dart';

class DescriptionIIWidget extends StatefulWidget {
  const DescriptionIIWidget({
    super.key,
    this.description,
  });

  final String? description;

  @override
  State<DescriptionIIWidget> createState() => _DescriptionIIWidgetState();
}

class _DescriptionIIWidgetState extends State<DescriptionIIWidget> {
  late DescriptionIIModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DescriptionIIModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Color(0x520E151B),
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                valueOrDefault<String>(
                  widget.description,
                  'description',
                ),
                maxLines: _model.isExpanded ? 99 : 3,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            ToggleIcon(
              onPressed: () async {
                safeSetState(() => _model.isExpanded = !_model.isExpanded);
              },
              value: _model.isExpanded,
              onIcon: Icon(
                Icons.arrow_drop_up,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              offIcon: Icon(
                Icons.arrow_drop_down,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
            ),
          ].divide(SizedBox(width: 8.0)).around(SizedBox(width: 8.0)),
        ),
      ),
    );
  }
}
