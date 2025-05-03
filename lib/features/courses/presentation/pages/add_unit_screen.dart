import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/features/courses/domain/entities/unit.dart';
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';

class AddUnitScreen extends StatefulWidget {
  final String courseId;

  const AddUnitScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _orderController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final order = int.parse(_orderController.text.trim());
        final unit = Unit(
          id: '', // Firestore will generate this
          title: _titleController.text.trim(),
          order: order,
          courseId: widget.courseId,
        );

        // Add loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        BlocProvider.of<CourseBloc>(context).add(
          AddUnitEvent(courseId: widget.courseId, unit: unit),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Unit'),
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unit added successfully!'), backgroundColor: Colors.green),
            );
            // Navigate back and potentially trigger a refresh on the details screen
            Navigator.pop(context, true); // Pass true to indicate success
          } else if (state is CourseActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error adding unit: ${state.message}'), backgroundColor: Colors.red),
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
                  decoration: const InputDecoration(labelText: 'Unit Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _orderController,
                  decoration: const InputDecoration(labelText: 'Order (e.g., 1, 2, 3)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Allow only digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an order number';
                    }
                    if (int.tryParse(value) == null) {
                       return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                BlocBuilder<CourseBloc, CourseState>(
                  builder: (context, state) {
                    if (state is CourseActionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Add Unit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
