import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/saved_book.dart';
import '../repositories/local_book_repository.dart';

/// ViewModel for handling book details logic, including saving to SQLite and checking saved status.
class BookDetailsViewModel extends ChangeNotifier {
  final LocalBookRepository localRepo;
  bool _isSaving = false;
  bool get isSaving => _isSaving;
  bool _saved = false;
  bool get saved => _saved;
  bool _alreadySaved = false;
  bool get alreadySaved => _alreadySaved;

  BookDetailsViewModel(this.localRepo);

  /// Checks if the book is already saved in SQLite.
  Future<void> checkIfSaved(String key) async {
    _alreadySaved = await localRepo.isBookSaved(key);
    notifyListeners();
  }

  /// Saves the book to SQLite if not already saved.
  Future<void> saveBook(Book book) async {
    if (_alreadySaved) return;
    _isSaving = true;
    notifyListeners();
    final savedBook = SavedBook(
      key: book.key,
      title: book.title,
      authors: book.authorNames.join(', '),
      firstPublishYear: book.firstPublishYear,
      coverId: book.coverId,
    );
    await localRepo.insert(savedBook);
    _isSaving = false;
    _saved = true;
    _alreadySaved = true;
    notifyListeners();
  }

  /// Resets the saved state (not used in current flow).
  void resetSaved() {
    _saved = false;
    notifyListeners();
  }
} 