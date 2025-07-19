import 'package:dio/dio.dart';
import '../core/api_response.dart';
import '../core/app_exception.dart';
import '../core/logger.dart';
import '../models/book.dart';

/// Repository for fetching books from the Open Library API.
/// Handles API requests, error handling, and data conversion.
class BookRepository {
  final Dio _dio;
  static const _baseUrl = 'https://openlibrary.org';

  BookRepository(this._dio);

  /// Searches for books by title (query) with pagination support.
  /// Returns an ApiResponse with a list of Book objects.
  Future<ApiResponse<List<Book>>> searchBooks(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search.json',
        queryParameters: {
          'q': query,
          'page': page,
        },
      );
      final docs = response.data['docs'] as List<dynamic>;
      final books = docs.map((e) => Book.fromJson(e)).toList();
      return ApiResponse.success(books);
    } catch (e, stack) {
      logger.e('Book search error', error: e, stackTrace: stack);
      return ApiResponse.error(e.toString());
    }
  }
} 