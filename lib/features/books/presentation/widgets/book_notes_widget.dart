import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';

class BookNotesWidget extends StatelessWidget {
  final List<Note> notes;
  final int currentPage;
  final VoidCallback onAddNote;
  final Function(String) onDeleteNote;
  final Function(Note, String, String) onUpdateNote;

  const BookNotesWidget({
    Key? key,
    required this.notes,
    required this.currentPage,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.onUpdateNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter notes for the current page
    final currentPageNotes = notes.where((note) => note.pageNumber == currentPage).toList();
    // Get notes for other pages
    final otherNotes = notes.where((note) => note.pageNumber != currentPage).toList();

    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.sticky_note_2, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notes for current page
                  if (currentPageNotes.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Current Page (${currentPageNotes.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...currentPageNotes.map((note) => _buildNoteCard(context, note)),
                    const Divider(height: 32),
                  ],

                  // Add note button for current page
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: onAddNote,
                      icon: const Icon(Icons.add),
                      label:  Text('Add Note for Page $currentPage'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),

                  if (currentPageNotes.isEmpty && otherNotes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No notes yet. Add your first note!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  // Notes for other pages
                  if (otherNotes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Other Pages (${otherNotes.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...otherNotes.map((note) => _buildNoteCard(context, note)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Color(int.parse(note.color.substring(1), radix: 16) + 0xFF000000),
      child: InkWell(
        onTap: () => _showNoteDetails(context, note),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Page ${note.pageNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(note.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, Note note) {
    TextEditingController contentController = TextEditingController(text: note.content);
    String selectedColor = note.color;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Note Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Page ${note.pageNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          'Created: ${_formatDate(note.createdAt)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Note Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                    ),
                    const SizedBox(height: 16),
                    const Text('Color:'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildColorOption('#FFFF8D', selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        }),
                        _buildColorOption('#80DEEA', selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        }),
                        _buildColorOption('#CF93D9', selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        }),
                        _buildColorOption('#FFD180', selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        }),
                        _buildColorOption('#FFAB91', selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onDeleteNote(note.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    onUpdateNote(note, contentController.text, selectedColor);
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildColorOption(String color, String selectedColor, Function(String) onColorSelected) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
          shape: BoxShape.circle,
          border: Border.all(
            color: color == selectedColor ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
