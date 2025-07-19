import 'book.dart';

/// Model representing a book saved locally in SQLite.
class SavedBook {
  final int? id;
  final String key;
  final String title;
  final String authors;
  final int? firstPublishYear;
  final String? coverId;

  SavedBook({
    this.id,
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  /// Creates a SavedBook from a database map.
  factory SavedBook.fromMap(Map<String, dynamic> map) => SavedBook(
        id: map['id'] as int?,
        key: map['key'] as String,
        title: map['title'] as String,
        authors: map['authors'] as String,
        firstPublishYear: map['firstPublishYear'] as int?,
        coverId: map['coverId'] as String?,
      );

  /// Converts this SavedBook to a map for database storage.
  Map<String, dynamic> toMap() => {
        'id': id,
        'key': key,
        'title': title,
        'authors': authors,
        'firstPublishYear': firstPublishYear,
        'coverId': coverId,
      };

  /// Converts this SavedBook to a Book model for use in the UI.
  Book toBook() => Book(
        key: key,
        title: title,
        authorNames: authors.split(',').map((e) => e.trim()).toList(),
        firstPublishYear: firstPublishYear,
        coverId: coverId,
      );
} 