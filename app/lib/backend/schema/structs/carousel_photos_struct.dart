// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CarouselPhotosStruct extends FFFirebaseStruct {
  CarouselPhotosStruct({
    String? url,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _url = url,
        super(firestoreUtilData);

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

  static CarouselPhotosStruct fromMap(Map<String, dynamic> data) =>
      CarouselPhotosStruct(
        url: data['url'] as String?,
      );

  static CarouselPhotosStruct? maybeFromMap(dynamic data) => data is Map
      ? CarouselPhotosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'url': _url,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
      }.withoutNulls;

  static CarouselPhotosStruct fromSerializableMap(Map<String, dynamic> data) =>
      CarouselPhotosStruct(
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CarouselPhotosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CarouselPhotosStruct && url == other.url;
  }

  @override
  int get hashCode => const ListEquality().hash([url]);
}

CarouselPhotosStruct createCarouselPhotosStruct({
  String? url,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CarouselPhotosStruct(
      url: url,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CarouselPhotosStruct? updateCarouselPhotosStruct(
  CarouselPhotosStruct? carouselPhotos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    carouselPhotos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCarouselPhotosStructData(
  Map<String, dynamic> firestoreData,
  CarouselPhotosStruct? carouselPhotos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (carouselPhotos == null) {
    return;
  }
  if (carouselPhotos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && carouselPhotos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final carouselPhotosData =
      getCarouselPhotosFirestoreData(carouselPhotos, forFieldValue);
  final nestedData =
      carouselPhotosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = carouselPhotos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCarouselPhotosFirestoreData(
  CarouselPhotosStruct? carouselPhotos, [
  bool forFieldValue = false,
]) {
  if (carouselPhotos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(carouselPhotos.toMap());

  // Add any Firestore field values
  carouselPhotos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCarouselPhotosListFirestoreData(
  List<CarouselPhotosStruct>? carouselPhotoss,
) =>
    carouselPhotoss
        ?.map((e) => getCarouselPhotosFirestoreData(e, true))
        .toList() ??
    [];
