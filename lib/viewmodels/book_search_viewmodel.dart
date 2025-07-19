import 'package:flutter/material.dart';
import '../core/api_response.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

/// ViewModel for searching books using the Open Library API.
/// Handles search, pagination, refresh, and initial/default book loading.
class BookSearchViewModel extends ChangeNotifier {
  final BookRepository repository;

  // Holds the current state of the book search (loading, success, error)
  ApiResponse<List<Book>> _books = ApiResponse.loading();
  ApiResponse<List<Book>> get books => _books;

  int _currentPage = 1;
  String _lastQuery = '';
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  BookSearchViewModel(this.repository);

  /// Search for books by title (query). Resets pagination.
  Future<void> search(String query) async {
    _books = ApiResponse.loading();
    _currentPage = 1;
    _lastQuery = query;
    _hasMore = true;
    notifyListeners();
    final result = await repository.searchBooks(query, page: _currentPage);
    _books = result;
    // OpenLibrary returns up to 100 per page
    _hasMore = (result.data?.length ?? 0) >= 100;
    notifyListeners();
  }

  /// Loads the next page of results for the current query (pagination).
  Future<void> loadMore() async {
    if (!_hasMore || _books.status == Status.loading) return;
    _currentPage++;
    final result = await repository.searchBooks(_lastQuery, page: _currentPage);
    if (result.status == Status.success && result.data != null) {
      final current = _books.data ?? [];
      _books = ApiResponse.success([...current, ...result.data!]);
      _hasMore = result.data!.length >= 100;
    } else if (result.status == Status.error) {
      _books = ApiResponse.error(result.message);
    }
    notifyListeners();
  }

  /// Refreshes the current search (reloads the first page).
  Future<void> refresh() async {
    await search(_lastQuery);
  }

  /// Loads a default set of books (e.g., on app launch or when query is empty).
  Future<void> fetchInitialBooks() async {
    // Use a default query, e.g., 'bestseller' or 'the'
    await search('the');
  }
} 