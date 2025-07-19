import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../viewmodels/book_details_viewmodel.dart';
import '../../repositories/local_book_repository.dart';

/// Screen to display details of a selected book.
/// Shows animated book cover, book info, and allows saving to SQLite.
class DetailsScreen extends StatefulWidget {
  final Book book;
  const DetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation controller for rotating book cover
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide a new BookDetailsViewModel for each book
    return ChangeNotifierProvider(
      create: (_) => BookDetailsViewModel(LocalBookRepository()),
      child: Consumer<BookDetailsViewModel>(
        builder: (context, vm, _) {
          final book = widget.book;
          // Check if already saved on first build
          if (!vm.alreadySaved && !vm.isSaving && !vm.saved) {
            vm.checkIfSaved(book.key);
          }
          return Scaffold(
            appBar: AppBar(title: Text(book.title)),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated book cover
                  Center(
                    child: RotationTransition(
                      turns: _controller,
                      child: book.coverImageUrl != null
                          ? Image.network(book.coverImageUrl!, height: 180)
                          : const Icon(Icons.book, size: 120),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Book title
                  Text(book.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  // Book authors
                  Text('by ${book.authorNames.join(', ')}', style: Theme.of(context).textTheme.bodyLarge),
                  if (book.firstPublishYear != null)
                    Text('First published: ${book.firstPublishYear}', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  // Save button or status
                  if (vm.alreadySaved)
                    const Text('Already Saved', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                  else if (vm.saved)
                    const Text('Saved!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                  else
                    ElevatedButton.icon(
                      onPressed: vm.isSaving ? null : () => vm.saveBook(book),
                      icon: vm.isSaving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save),
                      label: const Text('Save to Library'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}