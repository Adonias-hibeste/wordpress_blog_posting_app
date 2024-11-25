import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:post_wordpress_api/model/postmodel.dart';

class WordPressApiService {
  static const String apiUrl = 'https://blog.bolenav.com/wp-json/wp/v2/posts';
  static const String mediaUrlBase =
      'https://blog.bolenav.com/wp-json/wp/v2/media/';

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      //More informative error message
      rethrow; //Re-throw the exception for handling in the calling function
    }
  }

  Future<String?> fetchImageUrl(int mediaId) async {
    if (mediaId == 0) return null;

    final url = Uri.parse('$mediaUrlBase$mediaId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        //Improved error handling and clarity.  Prioritizes 'full' size, then defaults to null if no image available
        return jsonBody['media_details']?['sizes']?['full']?['source_url'] ??
            null;
      } else {
        print("Error fetching image URL ($mediaId): ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching image URL ($mediaId): $e");
      return null;
    }
  }
}
