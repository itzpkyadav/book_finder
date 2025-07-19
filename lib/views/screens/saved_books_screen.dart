import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/saved_books_viewmodel.dart';
import '../../models/saved_book.dart';
import 'package:go_router/go_router.dart';
import '../../models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Screen to display the list of books saved locally in SQLite.
/// Allows viewing details and deleting saved books.
class SavedBooksScreen extends StatefulWidget {
  const SavedBooksScreen({Key? key}) : super(key: key);

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved books when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedBooksViewModel>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Books')),
      body: Consumer<SavedBooksViewModel>(
        builder: (context, vm, _) {
          if (vm.loading) {
            // Show loading indicator while fetching saved books
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.books.isEmpty) {
            // Show message if no books are saved
            return const Center(child: Text('No saved books.'));
          }
          // Show list of saved books
          return ListView.builder(
            itemCount: vm.books.length,
            itemBuilder: (context, index) {
              final book = vm.books[index];
              return ListTile(
                leading: book.coverId != null
                    ? CachedNetworkImage(
                        imageUrl: 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 50,
                          height: 70,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.book, size: 40),
                      )
                    : const Icon(Icons.book, size: 40),
                title: Text(book.title),
                subtitle: Text(book.authors),
                // Navigate to details when tapped
                onTap: () {
                  context.push('/details', extra: book.toBook());
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => vm.deleteBook(book.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 