import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../widgets/primary_button.dart';
import '../widgets/form_label.dart';
import '../widgets/form_text_field.dart';
import '../widgets/condition_chip_selector.dart';
import '../services/book_service.dart';
import '../services/auth_service.dart';
import '../services/cloudinary_service.dart';
import '../services/user_service.dart';

class PostBookPage extends StatefulWidget {
  const PostBookPage({super.key});

  @override
  State<PostBookPage> createState() => _PostBookPageState();
}

class _PostBookPageState extends State<PostBookPage> {
  final BookService _bookService = BookService();
  final AuthService _authService = AuthService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final UserService _userService = UserService();

  static const Color _bg = Color(0xFF0B1026);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedCondition = 'Like New';
  final List<String> conditions = ['New', 'Like New', 'Good', 'Used'];
  XFile? _selectedImage;
  bool _isLoading = false;

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

  Future<void> _handlePost() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = _authService.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to post a book')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Get user profile to get their name
        final userProfile = await _userService.getUserProfile(currentUser.uid);
        final userName = userProfile?.name ?? currentUser.email ?? 'User';

        // First create book in Firestore to get the book ID
        final bookId = await _bookService.createBook(
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          category: _categoryController.text.trim(),
          condition: selectedCondition,
          description: _descriptionController.text.trim(),
          ownerId: currentUser.uid,
          ownerName: userName,
          ownerEmail: currentUser.email ?? '',
        );

        // Upload image to Cloudinary if selected
        if (_selectedImage != null) {
          final imageUrl = await _cloudinaryService.uploadBookCover(
            _selectedImage!,
            bookId,
          );

          // Update book with image URL
          await _bookService.updateBook(bookId: bookId, imageUrl: imageUrl);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book posted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error posting book: ${e.toString()}'),
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
                // Book Cover Image
                const FormLabel(text: 'Book Cover (Optional)'),
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Color(0xFFF1C64A),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Loading image...',
                                          style: TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ],
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
                                          'Error loading image',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${snapshot.error}',
                                          style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
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
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: Colors.white30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add book cover',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

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
                const FormLabel(
                  text: 'Description (Optional)',
                  isRequired: false,
                ),
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
                PrimaryButton(
                  text: _isLoading ? 'Posting...' : 'Post Book',
                  onPressed: _isLoading ? null : () => _handlePost(),
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
