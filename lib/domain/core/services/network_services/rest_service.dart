/// Stub REST service — replace with actual HTTP implementation.
class RestService {
  RestService._();

  static Future<Map<String, dynamic>> performGETRequest(String url, {Map<String, String>? headers}) async {
    throw UnimplementedError('RESTService.performGETRequest not implemented');
  }

  static Future<Map<String, dynamic>> performPOSTRequest(String url, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    throw UnimplementedError('RESTService.performPOSTRequest not implemented');
  }
}
