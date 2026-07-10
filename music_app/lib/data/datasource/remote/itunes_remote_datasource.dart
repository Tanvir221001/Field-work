import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/itunes_response.dart';

class ItunesRemoteDatasource {
  final Dio _dio;

  ItunesRemoteDatasource(this._dio);

  Future<ItunesResponse> searchSongs(String query, {int limit = 50}) async {
    try {
      final response = await _dio.get(
        ApiConstants.baseUrl + ApiConstants.search,
        queryParameters: {
          'term': query.isEmpty ? ApiConstants.defaultTerm : query,
          'media': 'music',
          'entity': 'song',
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data;
        if (response.data is String) {
          data = jsonDecode(response.data);
        } else {
          data = response.data;
        }
        return ItunesResponse.fromJson(data);
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
