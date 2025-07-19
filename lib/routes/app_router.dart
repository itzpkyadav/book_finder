import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/book.dart';
import '../views/screens/search_screen.dart';
import '../views/screens/details_screen.dart';
import '../views/screens/saved_books_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SearchScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final book = state.extra as Book;
            return DetailsScreen(book: book);
          },
        ),
        GoRoute(
          path: 'saved',
          builder: (context, state) => const SavedBooksScreen(),
        ),
      ],
    ),
  ],
); 