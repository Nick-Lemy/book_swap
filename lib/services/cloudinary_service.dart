import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // 🔐 CLOUDINARY CREDENTIALS - Replace these with your credentials from Cloudinary Dashboard
  // Get them from: https://console.cloudinary.com/
  static const String _cloudName = 'dhr4dq48b'; // e.g., 'dab123xyz'
  static const String _uploadPreset =
      'bookswap_preset'; // e.g., 'bookswap_preset'

  late final CloudinaryPublic _cloudinary;
  final ImagePicker _picker = ImagePicker();

  CloudinaryService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// Upload book cover to Cloudinary
  Future<String> uploadBookCover(File imageFile, String bookId) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'bookswap/book_covers',
          resourceType: CloudinaryResourceType.Image,
          publicId: 'book_$bookId',
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  /// Upload user avatar to Cloudinary
  Future<String> uploadUserAvatar(File imageFile, String userId) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'bookswap/user_avatars',
          resourceType: CloudinaryResourceType.Image,
          publicId: 'avatar_$userId',
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Avatar upload error: $e');
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }

  /// Delete image from Cloudinary (optional - requires API credentials)
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Note: Deleting requires API credentials which are not used in public client
      // For production, implement server-side deletion or use signed uploads
      print('Image deletion requires server-side implementation: $imageUrl');
    } catch (e) {
      print('Delete error: $e');
    }
  }

  /// Show image picker dialog
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1F3A),
          title: const Text(
            'Choose Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFFF1C64A),
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromGallery();
                  if (context.mounted && file != null) {
                    Navigator.pop(context, file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFF1C64A)),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromCamera();
                  if (context.mounted && file != null) {
                    Navigator.pop(context, file);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
