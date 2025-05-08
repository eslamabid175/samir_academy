import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import 'package:uuid/uuid.dart'; // Add this import
import '../../../../core/utils/pdf_utils.dart';

class BookFormDialog extends StatefulWidget {
  final Book? book;
  final Function(String title, String author, String description, String coverImage, 
    String fileUrl, int pageCount, List<String> categories, bool isFeatured) onSubmit;

  const BookFormDialog({
    Key? key,
    this.book,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _coverImageController;
  late TextEditingController _fileUrlController;
  late TextEditingController _pageCountController;
  late TextEditingController _categoriesController;
  late bool _isFeatured;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title);
    _authorController = TextEditingController(text: widget.book?.author);
    _descriptionController = TextEditingController(text: widget.book?.description);
    _coverImageController = TextEditingController(text: widget.book?.coverImage);
    _fileUrlController = TextEditingController(text: widget.book?.fileUrl);
    _pageCountController = TextEditingController(
        text: widget.book?.pageCount.toString() ?? '');
    _categoriesController = TextEditingController(
        text: widget.book?.categories.join(', '));
    _isFeatured = widget.book?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverImageController.dispose();
    _fileUrlController.dispose();
    _pageCountController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.book == null ? 'Add New Book' : 'Edit Book'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter an author' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _coverImageController,
                decoration: const InputDecoration(labelText: 'Cover Image URL'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a cover image URL' : null,
              ),
              TextFormField(
                controller: _fileUrlController,
                decoration: const InputDecoration(labelText: 'PDF File URL'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a PDF file URL' : null,
              ),
              TextFormField(
                controller: _pageCountController,
                decoration: const InputDecoration(labelText: 'Page Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter page count';
                  if (int.tryParse(value!) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriesController,
                decoration: const InputDecoration(
                  labelText: 'Categories',
                  helperText: 'Separate categories with commas',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter at least one category' : null,
              ),
              CheckboxListTile(
                title: const Text('Featured Book'),
                value: _isFeatured,
                onChanged: (value) {
                  setState(() {
                    _isFeatured = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onSubmit(
                _titleController.text,
                _authorController.text,
                _descriptionController.text,
                _coverImageController.text,
                _fileUrlController.text,
                int.parse(_pageCountController.text),
                _categoriesController.text.split(',').map((e) => e.trim()).toList(),
                _isFeatured,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.book == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
