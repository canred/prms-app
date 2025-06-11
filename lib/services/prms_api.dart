import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class PrmsApi {
  static const String _baseUrl = 'https://api.example.com'; // 替换为实际的 API URL

  static Future<bool> checkPrAndTubeMatch(String prId, String tubeId) async {
    final url = Uri.parse('https://i-services.info/wordpress/?p=14260');
    try {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final request = await httpClient.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking PR and Tube match: $e');
      return false;
    }
  }
}
