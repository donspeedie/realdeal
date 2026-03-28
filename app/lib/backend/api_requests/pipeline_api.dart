import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for sending deals to the NimbleDashboard deal pipeline.
class PipelineApi {
  /// NimbleDashboard backend URL.
  /// In dev: localhost via port forwarding or local network IP.
  /// In prod: replace with deployed URL.
  static const String baseUrl = 'http://10.0.2.2:8001'; // Android emulator -> host

  /// Send a saved property to the deal pipeline for scoring.
  ///
  /// Returns the scored deal response or throws on failure.
  static Future<Map<String, dynamic>> sendToPipeline({
    required String realdealId,
    required String address,
    required int price,
    required int impValue,
    int? futureValue,
    int? downPayment,
    int? loanFees,
    int? cashNeeded,
    int? duration,
    int? beds,
    int? baths,
    int? sqft,
    String? city,
    String? state,
    String? zipCode,
    String? strategy,
  }) async {
    final body = {
      'realdeal_id': realdealId,
      'address': address,
      'price': price.toDouble(),
      'impValue': impValue.toDouble(),
      if (futureValue != null) 'futureValue': futureValue.toDouble(),
      'downPayment': (downPayment ?? 0).toDouble(),
      'loanFees': (loanFees ?? 0).toDouble(),
      'outOfPocket': (cashNeeded ?? 0).toDouble(),
      if (duration != null) 'projectDuration': duration.toDouble(),
      if (beds != null) 'beds': beds,
      if (baths != null) 'baths': baths.toDouble(),
      if (sqft != null) 'sqft': sqft,
      if (city != null) 'city': city,
      'state': state ?? 'CA',
      if (zipCode != null) 'zip_code': zipCode,
      if (strategy != null) 'strategy': strategy,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/deals/import-from-realdeal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final err = jsonDecode(response.body);
      throw Exception(err['detail'] ?? 'Failed to send to pipeline (${response.statusCode})');
    }
  }
}
