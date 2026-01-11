import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/budget_component_search_editable_widget.dart';
import '/components/description_i_i_widget.dart';
import '/components/image_card_widget.dart';
import '/components/summaryof_returns_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'detail_component_search_non_editable_widget.dart'
    show DetailComponentSearchNonEditableWidget;
import 'package:flutter/material.dart';

class DetailComponentSearchNonEditableModel
    extends FlutterFlowModel<DetailComponentSearchNonEditableWidget> {
  ///  Local state fields for this component.

  bool isMapPeriodicRuning = false;

  int compsLoopCounter = 0;

  List<RedfinHomeDataStruct> soldHomesData = [];
  void addToSoldHomesData(RedfinHomeDataStruct item) => soldHomesData.add(item);
  void removeFromSoldHomesData(RedfinHomeDataStruct item) =>
      soldHomesData.remove(item);
  void removeAtIndexFromSoldHomesData(int index) =>
      soldHomesData.removeAt(index);
  void insertAtIndexInSoldHomesData(int index, RedfinHomeDataStruct item) =>
      soldHomesData.insert(index, item);
  void updateSoldHomesDataAtIndex(
          int index, Function(RedfinHomeDataStruct) updateFn) =>
      soldHomesData[index] = updateFn(soldHomesData[index]);

  List<RedfinHomeDataStruct> forSaleHomeData = [];
  void addToForSaleHomeData(RedfinHomeDataStruct item) =>
      forSaleHomeData.add(item);
  void removeFromForSaleHomeData(RedfinHomeDataStruct item) =>
      forSaleHomeData.remove(item);
  void removeAtIndexFromForSaleHomeData(int index) =>
      forSaleHomeData.removeAt(index);
  void insertAtIndexInForSaleHomeData(int index, RedfinHomeDataStruct item) =>
      forSaleHomeData.insert(index, item);
  void updateForSaleHomeDataAtIndex(
          int index, Function(RedfinHomeDataStruct) updateFn) =>
      forSaleHomeData[index] = updateFn(forSaleHomeData[index]);

  ///  State fields for stateful widgets in this component.

  // Model for ImageCard component.
  late ImageCardModel imageCardModel;
  // Model for budgetComponentSearchEditable component.
  late BudgetComponentSearchEditableModel budgetComponentSearchEditableModel;
  // Model for summaryofReturns component.
  late SummaryofReturnsModel summaryofReturnsModel;
  // Model for DescriptionII component.
  late DescriptionIIModel descriptionIIModel;

  @override
  void initState(BuildContext context) {
    imageCardModel = createModel(context, () => ImageCardModel());
    budgetComponentSearchEditableModel =
        createModel(context, () => BudgetComponentSearchEditableModel());
    summaryofReturnsModel = createModel(context, () => SummaryofReturnsModel());
    descriptionIIModel = createModel(context, () => DescriptionIIModel());
  }

  @override
  void dispose() {
    imageCardModel.dispose();
    budgetComponentSearchEditableModel.dispose();
    summaryofReturnsModel.dispose();
    descriptionIIModel.dispose();
  }
}
