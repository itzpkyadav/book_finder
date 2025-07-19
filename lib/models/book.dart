/// Model representing a book from the Open Library API.
class Book {
  final String key;
  final String title;
  final List<String> authorNames;
  final int? firstPublishYear;
  final String? coverId;

  Book({
    required this.key,
    required this.title,
    required this.authorNames,
    this.firstPublishYear,
    this.coverId,
  });

  /// Creates a Book from Open Library API JSON.
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'] as String,
      title: json['title'] as String,
      authorNames: (json['author_name'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i']?.toString(),
    );
  }

  /// Returns the cover image URL for the book, if available.
  String? get coverImageUrl => coverId != null
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : null;
} 