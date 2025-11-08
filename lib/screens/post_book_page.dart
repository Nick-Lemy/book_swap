import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_label.dart';
import '../widgets/form_text_field.dart';
import '../widgets/condition_chip_selector.dart';

class PostBookPage extends StatefulWidget {
  const PostBookPage({super.key});

  @override
  State<PostBookPage> createState() => _PostBookPageState();
}

class _PostBookPageState extends State<PostBookPage> {
  static const Color _bg = Color(0xFF0B1026);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedCondition = 'Like New';
  final List<String> conditions = ['New', 'Like New', 'Good', 'Used'];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handlePost() {
    if (_formKey.currentState!.validate()) {
      // TODO: Create and save the book
      // For now, just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Post a Book',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Title
                const FormLabel(text: 'Book Title'),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _titleController,
                  hintText: 'Enter book title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a book title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Author
                const FormLabel(text: 'Author'),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _authorController,
                  hintText: 'Enter author name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the author name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                const FormLabel(text: 'Category'),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _categoryController,
                  hintText: 'e.g., Data Structures, Algorithms',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description (Optional)
                const FormLabel(text: 'Description (Optional)', isRequired: false),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _descriptionController,
                  hintText: 'Describe the book condition, notes, etc.',
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Condition
                const FormLabel(text: 'Condition'),
                const SizedBox(height: 12),
                ConditionChipSelector(
                  conditions: conditions,
                  selectedCondition: selectedCondition,
                  onConditionSelected: (condition) {
                    setState(() {
                      selectedCondition = condition;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Post Button
                PrimaryButton(text: 'Post', onPressed: _handlePost),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
