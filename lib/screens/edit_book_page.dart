import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/book.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_label.dart';
import '../widgets/form_text_field.dart';
import '../widgets/condition_chip_selector.dart';
import '../services/book_service.dart';
import '../services/auth_service.dart';
import '../services/cloudinary_service.dart';

class EditBookPage extends StatefulWidget {
  final Book book;

  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final BookService _bookService = BookService();
  final AuthService _authService = AuthService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  static const Color _bg = Color(0xFF0B1026);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  late String selectedCondition;
  final List<String> conditions = ['New', 'Like New', 'Good', 'Used'];
  XFile? _selectedImage;
  bool _isLoading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current book data
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _categoryController = TextEditingController(text: widget.book.category);
    _descriptionController = TextEditingController(
      text: widget.book.description ?? '',
    );
    selectedCondition = widget.book.condition;
    _currentImageUrl = widget.book.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await _cloudinaryService.showImageSourceDialog(context);
    if (result != null) {
      setState(() {
        _selectedImage = result;
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = _authService.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to edit a book')),
        );
        return;
      }

      // Verify ownership
      if (currentUser.uid != widget.book.ownerId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only edit your own books')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        String? imageUrl = _currentImageUrl;

        // Upload new image if selected
        if (_selectedImage != null) {
          print('Uploading new image to Cloudinary...');
          imageUrl = await _cloudinaryService.uploadBookCover(
            _selectedImage!,
            widget.book.id,
          );
          print('New image uploaded, URL: $imageUrl');
        }

        // Update book in Firestore
        await _bookService.updateBook(
          bookId: widget.book.id,
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          category: _categoryController.text.trim(),
          condition: selectedCondition,
          description: _descriptionController.text.trim(),
          imageUrl: imageUrl,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        print('Error updating book: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating book: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
          'Edit Book',
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
                // Book Cover Image
                const FormLabel(text: 'Book Cover'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FutureBuilder<Uint8List>(
                              future: _selectedImage!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFF1C64A),
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 48,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Stack(
                                    children: [
                                      Image.memory(
                                        snapshot.data!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedImage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const Center(
                                  child: Text(
                                    'No image data',
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                );
                              },
                            ),
                          )
                        : _currentImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _currentImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 48,
                                      color: Colors.white30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to change book cover',
                                      style: TextStyle(color: Colors.white38),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: Colors.white30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add book cover',
                                style: TextStyle(color: Colors.white38),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Book Title
                const FormLabel(text: 'Title'),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _titleController,
                  hintText: 'Enter book title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the book title';
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

                // Description
                const FormLabel(text: 'Description'),
                const SizedBox(height: 8),
                FormTextField(
                  controller: _descriptionController,
                  hintText: 'Enter book description',
                  maxLines: 4,
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

                // Update Button
                PrimaryButton(
                  text: _isLoading ? 'Updating...' : 'Update Book',
                  onPressed: _isLoading ? null : () => _handleUpdate(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
