import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:book_finder/viewmodels/book_search_viewmodel.dart';
import 'package:book_finder/repositories/book_repository.dart';
import 'package:book_finder/core/api_response.dart';
import 'package:book_finder/models/book.dart';
import 'book_search_viewmodel_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  group('BookSearchViewModel', () {
    late MockBookRepository mockRepo;
    late BookSearchViewModel viewModel;

    setUp(() {
      mockRepo = MockBookRepository();
      viewModel = BookSearchViewModel(mockRepo);
    });

    test('search success', () async {
      final books = [Book(key: '1', title: 'Test', authorNames: ['Author'], firstPublishYear: 2020, coverId: '123')];
      when(mockRepo.searchBooks('Test', page: 1)).thenAnswer((_) async => ApiResponse.success(books));
      await viewModel.search('Test');
      expect(viewModel.books.status, Status.success);
      expect(viewModel.books.data, books);
    });

    test('search error', () async {
      when(mockRepo.searchBooks('Error', page: 1)).thenAnswer((_) async => ApiResponse.error('error'));
      await viewModel.search('Error');
      expect(viewModel.books.status, Status.error);
      expect(viewModel.books.message, 'error');
    });
  });
} 