import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'buy_tokens_widget.dart' show BuyTokensWidget;
import 'package:flutter/material.dart';

class BuyTokensModel extends FlutterFlowModel<BuyTokensWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (Create Customer)] action in Button widget.
  ApiCallResponse? createCustomer;
  // Stores action output result for [Backend Call - API (Create Checkout Session)] action in Button widget.
  ApiCallResponse? createCheckout;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
