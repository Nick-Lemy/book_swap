import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      return null;
    }
  }

  /// Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return image;
    } catch (e) {
      return null;
    }
  }

  /// Upload book cover to Cloudinary
  Future<String> uploadBookCover(XFile imageFile, String bookId) async {
    try {
      CloudinaryResponse response;

      if (kIsWeb) {
        // For web, read bytes from XFile
        final bytes = await imageFile.readAsBytes();
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: imageFile.name,
            folder: 'bookswap/book_covers',
            resourceType: CloudinaryResourceType.Image,
            publicId: 'book_$bookId',
          ),
        );
      } else {
        // For mobile, use file path
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            imageFile.path,
            folder: 'bookswap/book_covers',
            resourceType: CloudinaryResourceType.Image,
            publicId: 'book_$bookId',
          ),
        );
      }

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  /// Upload user avatar to Cloudinary
  Future<String> uploadUserAvatar(XFile imageFile, String userId) async {
    try {
      CloudinaryResponse response;

      if (kIsWeb) {
        // For web, read bytes from XFile
        final bytes = await imageFile.readAsBytes();
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: imageFile.name,
            folder: 'bookswap/user_avatars',
            resourceType: CloudinaryResourceType.Image,
            publicId: 'avatar_$userId',
          ),
        );
      } else {
        // For mobile, use file path
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            imageFile.path,
            folder: 'bookswap/user_avatars',
            resourceType: CloudinaryResourceType.Image,
            publicId: 'avatar_$userId',
          ),
        );
      }

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }

  /// Delete image from Cloudinary (optional - requires API credentials)
  Future<void> deleteImage(String imageUrl) async {}

  /// Show image picker dialog
  Future<XFile?> showImageSourceDialog(BuildContext context) async {
    final XFile? result = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext dialogContext) {
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
                  final file = await pickImageFromGallery();
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, file);
                  }
                },
              ),
              if (!kIsWeb) // Camera not available on web
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFF1C64A),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final file = await pickImageFromCamera();
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext, file);
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
    return result;
  }
}
