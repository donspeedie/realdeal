import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'comp_card_redfin_model.dart';
export 'comp_card_redfin_model.dart';

class CompCardRedfinWidget extends StatefulWidget {
  const CompCardRedfinWidget({
    super.key,
    String? comp1Img,
    double? comp1Value,
    double? comp1LvgArea,
    double? comp1Beds,
    double? comp1Baths,
    double? comp1LotArea,
  })  : this.comp1Img = comp1Img ??
            'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg',
        this.comp1Value = comp1Value ?? 0.0,
        this.comp1LvgArea = comp1LvgArea ?? 0.0,
        this.comp1Beds = comp1Beds ?? 0.0,
        this.comp1Baths = comp1Baths ?? 0.0,
        this.comp1LotArea = comp1LotArea ?? 0.0;

  final String comp1Img;
  final double comp1Value;
  final double comp1LvgArea;
  final double comp1Beds;
  final double comp1Baths;
  final double comp1LotArea;

  @override
  State<CompCardRedfinWidget> createState() => _CompCardRedfinWidgetState();
}

class _CompCardRedfinWidgetState extends State<CompCardRedfinWidget> {
  late CompCardRedfinModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompCardRedfinModel());

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
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Price',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          formatNumber(
                            widget.comp1Value,
                            formatType: FormatType.compact,
                          ),
                          '1',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Living ',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            formatNumber(
                              widget.comp1LvgArea,
                              formatType: FormatType.decimal,
                              decimalType: DecimalType.automatic,
                            ),
                            '1',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Beds',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            formatNumber(
                              widget.comp1Beds,
                              formatType: FormatType.decimal,
                              decimalType: DecimalType.automatic,
                            ),
                            '1',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Baths',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
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
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Lot',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
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
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
