import 'package:http/http.dart' as http;

class PdfUtils {
  /// Checks if a PDF URL is valid and accessible
  static Future<bool> checkPdfUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      
      // Check if response is successful and content type is PDF
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        return contentType?.toLowerCase().contains('pdf') ?? false;
      }
      
      return false;
    } catch (e) {
      // Return false for any network or parsing errors
      return false;
    }
  }
}
