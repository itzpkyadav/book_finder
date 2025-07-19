import 'package:flutter/material.dart';
import '../../models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  const BookTile({Key? key, required this.book, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverImageUrl != null
          ? CachedNetworkImage(
              imageUrl: book.coverImageUrl!,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                width: 50,
                height: 70,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) => Container(
                width: 50,
                height: 70,
                color: Colors.grey[300],
                child: const Icon(Icons.book, color: Colors.grey),
              ),
            )
          : Container(
              width: 50,
              height: 70,
              color: Colors.grey[300],
              child: const Icon(Icons.book, color: Colors.grey),
            ),
      title: Text(book.title),
      subtitle: Text(book.authorNames.join(', ')),
      onTap: onTap,
    );
  }
} 