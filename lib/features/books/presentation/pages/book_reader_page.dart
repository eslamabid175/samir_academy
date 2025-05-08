import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/note.dart';
import '../bloc/books_bloc.dart';
import '../widgets/book_notes_widget.dart';
import '../../../../core/utils/pdf_utils.dart';

class BookReaderPage extends StatefulWidget {
  final String bookId;

  const BookReaderPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  
  Book? _book;
  List<Bookmark> _bookmarks = [];
  List<Note> _notes = [];
  int _currentPage = 1;
  int _totalPages = 0;
  double _progress = 0.0;
  
  bool _isBookmarksPanelOpen = false;
  bool _isNotesPanelOpen = false;

  @override
  void initState() {
    super.initState();

    // Get current user ID - in a real app, get this from auth service
    final userId = 'current_user_id';

    // Load book details when the page is loaded
    BlocProvider.of<BooksBloc>(context).add(
      GetBookDetailsEvent(
        userId: userId,
        bookId: widget.bookId,
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _updateReadingProgress() {
    if (_book != null) {
      final userId = 'current_user_id';

      BlocProvider.of<BooksBloc>(context).add(
        UpdateReadingProgressEvent(
          userId: userId,
          bookId: widget.bookId,
          currentPage: _currentPage,
          totalPages: _totalPages > 0 ? _totalPages : _book!.pageCount,
        ),
      );
    }
  }

  void _addBookmark() {
    if (_book != null) {
      showDialog(
        context: context,
        builder: (context) {
          String title = 'Page $_currentPage';
          String description = '';

          return AlertDialog(
            title: const Text('Add Bookmark'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter bookmark title',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                  controller: TextEditingController(text: title),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter bookmark description',
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final userId = 'current_user_id';

                  BlocProvider.of<BooksBloc>(context).add(
                    AddBookmarkEvent(
                      userId: userId,
                      bookId: widget.bookId,
                      pageNumber: _currentPage,
                      title: title,
                      description: description,
                    ),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmark added successfully'),
                    ),
                  );
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addNote() {
    if (_book != null) {
      showDialog(
        context: context,
        builder: (context) {
          String content = '';
          String selectedColor = '#FFFF8D'; // Default yellow color

          return AlertDialog(
            title: const Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Enter your note',
                  ),
                  onChanged: (value) {
                    content = value;
                  },
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Color options for notes
                    _buildColorOption('#FFFF8D', selectedColor == '#FFFF8D', (color) {
                      selectedColor = color;
                    }),
                    _buildColorOption('#80DEEA', selectedColor == '#80DEEA', (color) {
                      selectedColor = color;
                    }),
                    _buildColorOption('#CF93D9', selectedColor == '#CF93D9', (color) {
                      selectedColor = color;
                    }),
                    _buildColorOption('#FFD180', selectedColor == '#FFD180', (color) {
                      selectedColor = color;
                    }),
                    _buildColorOption('#FFAB91', selectedColor == '#FFAB91', (color) {
                      selectedColor = color;
                    }),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (content.isNotEmpty) {
                    final userId = 'current_user_id';

                    BlocProvider.of<BooksBloc>(context).add(
                      AddNoteEvent(
                        userId: userId,
                        bookId: widget.bookId,
                        pageNumber: _currentPage,
                        content: content,
                        color: selectedColor,
                      ),
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note added successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter some content for your note'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildColorOption(String color, bool isSelected, Function(String) onColorSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onColorSelected(color);
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<BooksBloc, BooksState>(
          builder: (context, state) {
            if (state is BookDetailsLoadedState) {
              return Text(state.book.title);
            }
            return const Text('Book Reader');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _addBookmark,
            tooltip: 'Add bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: _addNote,
            tooltip: 'Add note',
          ),
          IconButton(
            icon: Icon(
              _isBookmarksPanelOpen ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarksPanelOpen ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _isBookmarksPanelOpen = !_isBookmarksPanelOpen;
                if (_isBookmarksPanelOpen) {
                  _isNotesPanelOpen = false;
                }
              });
            },
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: Icon(
              _isNotesPanelOpen ? Icons.sticky_note_2 : Icons.sticky_note_2_outlined,
              color: _isNotesPanelOpen ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _isNotesPanelOpen = !_isNotesPanelOpen;
                if (_isNotesPanelOpen) {
                  _isBookmarksPanelOpen = false;
                }
              });
            },
            tooltip: 'Notes',
          ),
        ],
      ),
      body: BlocConsumer<BooksBloc, BooksState>(
        listener: (context, state) {
          if (state is BookDetailsLoadedState) {
            setState(() {
              _book = state.book;
              _bookmarks = state.bookmarks;
              _notes = state.notes;
              _currentPage = state.currentPage > 0 ? state.currentPage : 1;
              _progress = state.progress;
              _totalPages = _book?.pageCount ?? 0;
            });

            // Jump to the saved page
            if (_currentPage > 1 && _pdfViewerController.pageNumber != _currentPage) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (_pdfViewerController.pageCount >= _currentPage) {
                  _pdfViewerController.jumpToPage(_currentPage);
                }
              });
            }
          } else if (state is BookmarkAddedState) {
            setState(() {
              _bookmarks = [..._bookmarks, state.bookmark];
            });
          } else if (state is NoteAddedState) {
            setState(() {
              _notes = [..._notes, state.note];
            });
          } else if (state is ReadingProgressUpdatedState) {
            setState(() {
              _currentPage = state.currentPage;
              _progress = state.progress;
            });
          }
        },
        builder: (context, state) {
          if (state is BookDetailsLoadingState) {
            return const LoadingWidget();
          } else if (state is BooksErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Retry loading the book
                      final userId = 'current_user_id'; // Replace with actual user ID
                      BlocProvider.of<BooksBloc>(context).add(
                        GetBookDetailsEvent(
                          userId: userId,
                          bookId: widget.bookId,
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          } else if (_book != null) {
            return _buildReader();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No book details available',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildReader() {
    if (_book == null) return const SizedBox.shrink();

    return Row(
      children: [
        // Main PDF reader
        Expanded(
          child: Stack(
            children: [
              SfPdfViewer.network(
                _book!.fileUrl,
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                  setState(() {
                    _totalPages = details.document.pages.count;
                  });
                },
                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                  _updateReadingProgress();
                },
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading PDF: ${details.error}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                },
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                interactionMode: PdfInteractionMode.pan,
                initialZoomLevel: 1.0,
                pageSpacing: 0,
                canShowPasswordDialog: true,
              ),

              // Loading indicator
              FutureBuilder<bool>(
                future: PdfUtils.checkPdfUrl(_book!.fileUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError || (snapshot.hasData && !snapshot.data!)) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load PDF file',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => setState(() {}), // Retry loading
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),

        // Bookmarks panel
        if (_isBookmarksPanelOpen)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.bookmark, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Bookmarks',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _bookmarks.isEmpty
                        ? const Center(
                            child: Text('No bookmarks yet'),
                          )
                        : ListView.builder(
                            itemCount: _bookmarks.length,
                            itemBuilder: (context, index) {
                              final bookmark = _bookmarks[index];
                              return ListTile(
                                title: Text(bookmark.title),
                                subtitle: Text(
                                  'Page ${bookmark.pageNumber}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                onTap: () {
                                  _pdfViewerController.jumpToPage(bookmark.pageNumber);
                                  setState(() {
                                    _currentPage = bookmark.pageNumber;
                                  });
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    final userId = 'current_user_id';
                                    BlocProvider.of<BooksBloc>(context).add(
                                      RemoveBookmarkEvent(
                                        userId: userId,
                                        bookId: widget.bookId,
                                        bookmarkId: bookmark.id,
                                      ),
                                    );
                                    setState(() {
                                      _bookmarks.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: 'Add Bookmark',
                      onPressed: _addBookmark,
                      icon: Icons.add,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Notes panel
        if (_isNotesPanelOpen)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: BookNotesWidget(
              notes: _notes,
              currentPage: _currentPage,
              onAddNote: _addNote,
              onDeleteNote: (noteId) {
                final userId = 'current_user_id';
                BlocProvider.of<BooksBloc>(context).add(
                  RemoveNoteEvent(
                    userId: userId,
                    bookId: widget.bookId,
                    noteId: noteId,
                  ),
                );
                setState(() {
                  _notes.removeWhere((note) => note.id == noteId);
                });
              },
              onUpdateNote: (note, content, color) {
                BlocProvider.of<BooksBloc>(context).add(
                  UpdateNoteEvent(
                    userId: note.userId,
                    bookId: note.bookId,
                    noteId: note.id,
                    content: content,
                    color: color,
                  ),
                );
                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    // Create a copy of the note with updated values
                    final updatedNote = Note(
                      id: note.id,
                      userId: note.userId,
                      bookId: note.bookId,
                      pageNumber: note.pageNumber,
                      content: content,
                      color: color,
                      createdAt: note.createdAt,
                      updatedAt: DateTime.now(),
                    );
                    _notes[index] = updatedNote;
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _totalPages > 0 ? _currentPage / _totalPages : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),

          // Page navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous page button
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: _currentPage > 1
                    ? () {
                        _pdfViewerController.previousPage();
                      }
                    : null,
              ),

              // Page indicator
              Text(
                'Page $_currentPage of $_totalPages',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              // Next page button
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: _currentPage < _totalPages
                    ? () {
                        _pdfViewerController.nextPage();
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

