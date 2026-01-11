import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'welcome_message_model.dart';
export 'welcome_message_model.dart';

class WelcomeMessageWidget extends StatefulWidget {
  const WelcomeMessageWidget({super.key});

  @override
  State<WelcomeMessageWidget> createState() => _WelcomeMessageWidgetState();
}

class _WelcomeMessageWidgetState extends State<WelcomeMessageWidget> {
  late WelcomeMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeMessageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome! Let’s Find Your Next investment Deal\n\nRight now, getRealDeal.ai is scanning every residential property on the market near you—filtering out the noise and surfacing only those with a positive return potential.\n\nRental, flip, add-on, ADU, or new build? If it pencils, you’ll see it—complete with a live-editable proforma you can tweak without leaving the screen.\n\nAll saved reports live in your Saved tab. We’re actively improving filtering and accuracy, so your input makes a difference.\n\nAppreciate you giving it a shot.\n— Don |          support@fluidcm.com',
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            letterSpacing: 0.0,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
          ),
    );
  }
}
