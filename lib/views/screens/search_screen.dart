import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/book_search_viewmodel.dart';
import '../widgets/search_bar.dart';
import '../widgets/book_tile.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../../core/api_response.dart';
import 'package:go_router/go_router.dart';

/// Main screen for searching books and displaying results.
/// Handles search input, loading, error, and navigation to details/saved screens.
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch initial books if query is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BookSearchViewModel>();
      if (_controller.text.trim().isEmpty) {
        vm.fetchInitialBooks();
      }
    });
  }

  /// Handles infinite scroll pagination.
  void _onScroll() {
    final vm = context.read<BookSearchViewModel>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && vm.hasMore) {
      vm.loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
        actions: [
          // Button to open the Saved Books screen
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => context.push('/saved'),
            tooltip: 'Saved Books',
          ),
        ],
      ),
      body: Consumer<BookSearchViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              // Search bar for user input
              SearchBarWidget(
                controller: _controller,
                onSubmitted: (query) {
                  final vm = context.read<BookSearchViewModel>();
                  if (query.trim().isEmpty) {
                    vm.fetchInitialBooks();
                  } else {
                    vm.search(query.trim());
                  }
                },
              ),
              // Main content area: loading, error, or book list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.refresh(),
                  child: Builder(
                    builder: (context) {
                      switch (vm.books.status) {
                        case Status.loading:
                          // Show shimmer loading while fetching data
                          return ListView.builder(
                            itemCount: 6,
                            itemBuilder: (_, __) => const LoadingWidget(),
                          );
                        case Status.error:
                          // Show error message and retry button
                          return ErrorWidgetCustom(
                            message: vm.books.message,
                            onRetry: () => vm.search(_controller.text.trim()),
                          );
                        case Status.success:
                          final books = vm.books.data ?? [];
                          if (books.isEmpty) {
                            return const Center(child: Text('No books found.'));
                          }
                          // Show list of books with infinite scroll
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: books.length + (vm.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < books.length) {
                                return BookTile(
                                  book: books[index],
                                  onTap: () {
                                    context.push('/details', extra: books[index]);
                                  },
                                );
                              } else {
                                // Show loading indicator at the end for pagination
                                return const LoadingWidget(height: 60);
                              }
                            },
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 