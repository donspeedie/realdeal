import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'comp_card_zillow_model.dart';
export 'comp_card_zillow_model.dart';

class CompCardZillowWidget extends StatefulWidget {
  const CompCardZillowWidget({
    super.key,
    this.comp1Img,
    this.comp1Value,
    required this.comp1LvgArea,
    this.comp1Beds,
    this.comp1Baths,
    this.comp1LotArea,
    required this.onCompLoad,
  });

  final String? comp1Img;
  final int? comp1Value;
  final int? comp1LvgArea;
  final int? comp1Beds;
  final int? comp1Baths;
  final int? comp1LotArea;
  final Future Function(CompsStruct comp)? onCompLoad;

  @override
  State<CompCardZillowWidget> createState() => _CompCardZillowWidgetState();
}

class _CompCardZillowWidgetState extends State<CompCardZillowWidget> {
  late CompCardZillowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompCardZillowModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 221.7,
      decoration: BoxDecoration(),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                getCORSProxyUrl(
                  valueOrDefault<String>(
                    widget.comp1Img,
                    '1',
                  ),
                ),
                width: 150.0,
                height: 124.1,
                fit: BoxFit.scaleDown,
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  formatNumber(
                    widget.comp1Value,
                    formatType: FormatType.compact,
                  ),
                  '1',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  formatNumber(
                    widget.comp1LvgArea,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                  ),
                  '1',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  formatNumber(
                    widget.comp1Beds,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                  ),
                  '1',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  formatNumber(
                    widget.comp1Baths,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                  ),
                  '1',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  formatNumber(
                    widget.comp1LotArea,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                  ),
                  '1',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
