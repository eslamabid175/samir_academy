import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/book.dart';
import '../bloc/books_bloc.dart';
import 'book_reader_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  void initState() {
    super.initState();
    // Fetch books when the page is loaded
    BlocProvider.of<BooksBloc>(context).add(GetBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoadingState) {
            return const LoadingWidget();
          } else if (state is BooksLoadedState) {
            return _buildBooksList(state.books);
          } else if (state is BooksErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text('No books available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildBooksList(List<Book> books) {
    return CustomScrollView(
      slivers: [
        // Featured books section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Books',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        // Featured books horizontal list
        SliverToBoxAdapter(
          child: SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: books.where((book) => book.isFeatured).length,
              itemBuilder: (context, index) {
                final featuredBooks = books.where((book) => book.isFeatured).toList();
                if (index < featuredBooks.length) {
                  return _buildFeaturedBookCard(featuredBooks[index]);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        
        // All books section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Books',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        // All books grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index < books.length) {
                  return _buildBookCard(books[index]);
                }
                return const SizedBox.shrink();
              },
              childCount: books.length,
            ),
          ),
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildFeaturedBookCard(Book book) {
    return GestureDetector(
      onTap: () => _navigateToBookReader(book),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverImage,
                height: 200,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            
            // Book title
            Text(
              book.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Book author
            Text(
              book.author,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => _navigateToBookReader(book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book cover
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverImage,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Book title
          Text(
            book.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          
          // Book author
          Text(
            book.author,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToBookReader(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookReaderPage(bookId: book.id),
      ),
    );
  }
}
