import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/customer_model.dart';
import 'signature_capture_screen.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String captureType;
  final Customer? customer;

  const CameraCaptureScreen({
    super.key,
    required this.captureType,
    this.customer,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final _imagePicker = ImagePicker();
  File? _capturedImage;
  bool _isLoading = false;

  String get _title {
    switch (widget.captureType) {
      case 'passport':
        return 'Capture Passport Photo';
      case 'id':
        return 'Capture ID Card';
      default:
        return 'Capture Photo';
    }
  }

  String get _instruction {
    switch (widget.captureType) {
      case 'passport':
        return 'Take a clear photo of the customer\'s face. Ensure good lighting and the face is centered.';
      case 'id':
        return 'Capture the front side of the ID card. Ensure all text is clearly visible.';
      default:
        return 'Capture a clear photo.';
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _capturedImage = File(photo.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing photo: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _capturedImage = File(photo.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking photo: $e')),
      );
    }
  }

  void _proceed() {
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture or select a photo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Customer updatedCustomer = widget.customer ?? Customer(
        firstName: 'Unknown',
        lastName: 'Unknown',
        email: 'unknown@example.com',
        phone: 'N/A',
        dateOfBirth: '2000-01-01',
        address: 'N/A',
        city: 'N/A',
        state: 'N/A',
        zipCode: 'N/A',
        country: 'N/A',
        idType: 'Passport',
        idNumber: 'N/A',
        agentId: 'unknown',
      );

      if (widget.captureType == 'passport') {
        updatedCustomer = updatedCustomer.copyWith(
          passportPhotoPath: _capturedImage!.path,
        );
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CameraCaptureScreen(
                captureType: 'id',
                customer: updatedCustomer,
              ),
            ),
          );
        }
      } else if (widget.captureType == 'id') {
        updatedCustomer = updatedCustomer.copyWith(
          idCardPhotoPath: _capturedImage!.path,
        );
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SignatureCaptureScreen(
                customer: updatedCustomer,
              ),
            ),
          );
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _instruction,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),
              if (_capturedImage != null)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(
                    _capturedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'No photo captured',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _capturePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Capture Photo'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.image),
                label: const Text('Choose from Gallery'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _proceed,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(widget.captureType == 'passport'
                        ? 'Next: Capture ID Card'
                        : 'Next: Digital Signature'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
