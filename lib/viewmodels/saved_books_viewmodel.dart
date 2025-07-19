import 'package:flutter/material.dart';
import '../models/saved_book.dart';
import '../repositories/local_book_repository.dart';

class SavedBooksViewModel extends ChangeNotifier {
  final LocalBookRepository localRepo;
  List<SavedBook> _books = [];
  List<SavedBook> get books => _books;
  bool _loading = false;
  bool get loading => _loading;

  SavedBooksViewModel(this.localRepo);

  Future<void> loadBooks() async {
    _loading = true;
    notifyListeners();
    _books = await localRepo.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteBook(int id) async {
    await localRepo.delete(id);
    await loadBooks();
  }
} 