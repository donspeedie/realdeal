import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

LatLng convertToLatLng(
  double latitude,
  double longitude,
) {
  // convert to latlng
  return LatLng(latitude, longitude);
}

List<LatLng> convertListsToLatLng(
  List<double> latitude,
  List<double> longitude,
) {
  // convert lists to latlng
  List<LatLng> latLngList = [];
  for (int i = 0; i < latitude.length; i++) {
    LatLng latLng = LatLng(latitude[i], longitude[i]);
    latLngList.add(latLng);
  }
  return latLngList;
}

DateTime? convertToDateTime(dynamic input) {
  // convert {_seconds: 1750438270, _nanoseconds: 291000000} to DateTime
  if (input is Map<String, dynamic>) {
    int seconds = input['_seconds'];
    int nanoseconds = input['_nanoseconds'];
    return DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + nanoseconds ~/ 1000000);
  } else if (input is String) {
    return DateTime.tryParse(input);
  }
}

List<CompsStruct> mergeCompsLists(
  List<CompsStruct>? list1,
  List<CompsStruct>? list2,
) {
  return list1 != null && list2 != null
      ? [...list1, ...list2]
      : (list1 ?? list2 ?? []);
}
