import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../model/music_item.dart';

class RemoteDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseApiUrl));

  Future<List<MusicItem>> searchMusic(String query, {int limit = 200}) async {
    try {
      if (query.trim().isEmpty || query.contains('bangla hindi english pop')) {
        // Fetch from multiple queries to get around the 200 limit of iTunes API
        final queries = ['bangla song', 'hindi song', 'english pop', 'trending music'];
        List<MusicItem> allResults = [];
        
        for (var q in queries) {
          final response = await _dio.get(
            AppConstants.searchEndpoint,
            queryParameters: {
              'term': q,
              'media': 'music',
              'limit': 200,
            },
          );
          
          if (response.statusCode == 200) {
            Map<String, dynamic> data;
            if (response.data is String) {
              data = jsonDecode(response.data);
            } else {
              data = response.data;
            }
            final List results = data['results'] ?? [];
            allResults.addAll(results.map((json) => MusicItem.fromJson(json)));
          }
        }
        
        // Remove duplicates
        final seen = <int>{};
        allResults = allResults.where((item) => seen.add(item.id)).toList();
        
        // Shuffle to mix the languages
        allResults.shuffle();
        
        return allResults;
      } else {
        // Normal single query search
        final response = await _dio.get(
          AppConstants.searchEndpoint,
          queryParameters: {
            'term': query,
            'media': 'music',
            'limit': limit > 200 ? 200 : limit, // iTunes max limit is 200
          },
        );
        
        if (response.statusCode == 200) {
          Map<String, dynamic> data;
          if (response.data is String) {
            data = jsonDecode(response.data);
          } else {
            data = response.data;
          }
  
          final List results = data['results'] ?? [];
          return results.map((json) => MusicItem.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load music from API');
        }
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
