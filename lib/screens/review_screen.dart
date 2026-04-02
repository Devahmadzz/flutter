import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import '../models/customer_model.dart';
import 'dashboard_screen.dart';

class ReviewScreen extends StatefulWidget {
  final Customer customer;

  const ReviewScreen({
    super.key,
    required this.customer,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isGenerating = false;
  String _generationStatus = '';

  Future<void> _generatePackage() async {
    setState(() {
      _isGenerating = true;
      _generationStatus = 'Generating documents...';
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final packageDir = Directory('${directory.path}/kyc_packages');
      if (!await packageDir.exists()) {
        await packageDir.create(recursive: true);
      }

      // Create JSON file
      setState(() => _generationStatus = 'Creating JSON data...');
      final jsonFile = File('${packageDir.path}/${widget.customer.id}_data.json');
      await jsonFile.writeAsString(
        jsonEncode(widget.customer.toJson()),
      );

      // Create archive
      setState(() => _generationStatus = 'Packaging files...');
      final archive = Archive();

      // Add JSON file
      archive.addFile(ArchiveFile(
        '${widget.customer.id}_data.json',
        await jsonFile.readAsBytes(),
      ));

      // Add photos if they exist
      if (widget.customer.passportPhotoPath.isNotEmpty &&
          await File(widget.customer.passportPhotoPath).exists()) {
        final passportBytes = await File(widget.customer.passportPhotoPath).readAsBytes();
        archive.addFile(ArchiveFile(
          'passport_photo.jpg',
          passportBytes,
        ));
      }

      if (widget.customer.idCardPhotoPath.isNotEmpty &&
          await File(widget.customer.idCardPhotoPath).exists()) {
        final idBytes = await File(widget.customer.idCardPhotoPath).readAsBytes();
        archive.addFile(ArchiveFile(
          'id_card_photo.jpg',
          idBytes,
        ));
      }

      if (widget.customer.signaturePath.isNotEmpty &&
          await File(widget.customer.signaturePath).exists()) {
        final signatureBytes = await File(widget.customer.signaturePath).readAsBytes();
        archive.addFile(ArchiveFile(
          'signature.png',
          signatureBytes,
        ));
      }

      // Save ZIP file
      setState(() => _generationStatus = 'Saving package...');
      final zipFile = File('${packageDir.path}/${widget.customer.id}_kyc.zip');
      await zipFile.writeAsBytes(ZipEncoder().encode(archive)!);

      setState(() => _generationStatus = 'Package created successfully!');

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('KYC package created successfully!'),
                const SizedBox(height: 12),
                Text(
                  'File: ${widget.customer.id}_kyc.zip',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${zipFile.path}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => _generationStatus = 'Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating package: $e')),
        );
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Package'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _ReviewItem(
                label: 'Name',
                value: '${widget.customer.firstName} ${widget.customer.lastName}',
              ),
              _ReviewItem(
                label: 'Email',
                value: widget.customer.email,
              ),
              _ReviewItem(
                label: 'Phone',
                value: widget.customer.phone,
              ),
              _ReviewItem(
                label: 'Date of Birth',
                value: widget.customer.dateOfBirth,
              ),
              _ReviewItem(
                label: 'Address',
                value:
                    '${widget.customer.address}, ${widget.customer.city}, ${widget.customer.state} ${widget.customer.zipCode}',
              ),
              _ReviewItem(
                label: 'ID Type',
                value: widget.customer.idType,
              ),
              _ReviewItem(
                label: 'ID Number',
                value: widget.customer.idNumber,
              ),
              const SizedBox(height: 24),
              Text(
                'Documents',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _DocumentItem(
                label: 'Passport Photo',
                isPresent: widget.customer.passportPhotoPath.isNotEmpty,
              ),
              _DocumentItem(
                label: 'ID Card Photo',
                isPresent: widget.customer.idCardPhotoPath.isNotEmpty,
              ),
              _DocumentItem(
                label: 'Digital Signature',
                isPresent: widget.customer.signaturePath.isNotEmpty,
              ),
              const SizedBox(height: 24),
              if (_isGenerating)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _generationStatus,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _generatePackage,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Generate KYC Package'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String label;
  final bool isPresent;

  const _DocumentItem({
    required this.label,
    required this.isPresent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
