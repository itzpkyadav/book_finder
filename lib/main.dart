import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/book_repository.dart';
import 'repositories/local_book_repository.dart';
import 'routes/app_router.dart';
import 'viewmodels/book_search_viewmodel.dart';
import 'viewmodels/saved_books_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookSearchViewModel(BookRepository(Dio())),
        ),
        ChangeNotifierProvider(
          create: (_) => SavedBooksViewModel(LocalBookRepository()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Book Finder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
