import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/features/courses/domain/entities/course.dart';
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';

class AddCourseScreen extends StatefulWidget {
  final String categoryId;
  const AddCourseScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController(); // New controller for image URL

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose(); // Dispose the new controller
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: '',
        title: _titleController.text,
        description: _descriptionController.text,
        categoryId: widget.categoryId,
        imageUrl: _imageUrlController.text, // Use the image URL from text field
      );

      BlocProvider.of<CourseBloc>(context).add(AddCourseEvent(course: course));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course to ${widget.categoryId}'),
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Course added successfully!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          } else if (state is CourseActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error adding course: ${state.message}'), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Course Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'Enter a valid image URL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    if (!Uri.tryParse(value)!.hasAbsolutePath ?? false) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                context.watch<CourseBloc>().state is CourseActionLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Add Course'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
