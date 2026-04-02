import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/customer_model.dart';
import 'review_screen.dart';

class SignatureCaptureScreen extends StatefulWidget {
  final Customer customer;

  const SignatureCaptureScreen({
    super.key,
    required this.customer,
  });

  @override
  State<SignatureCaptureScreen> createState() => _SignatureCaptureScreenState();
}

class _SignatureCaptureScreenState extends State<SignatureCaptureScreen> {
  late GlobalKey<_SignaturePainterState> _signatureKey;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _signatureKey = GlobalKey();
  }

  Future<void> _saveSignature() async {
    setState(() => _isLoading = true);

    try {
      final signatureImage = await _signatureKey.currentState?.exportImage();
      if (signatureImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/signature_${widget.customer.id}.png';
        await signatureImage.writeAsBytes(filePath);

        final updatedCustomer = widget.customer.copyWith(
          signaturePath: filePath,
        );

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReviewScreen(customer: updatedCustomer),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving signature: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearSignature() {
    _signatureKey.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Signature'),
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
                child: const Text(
                  'Please sign below. Use your finger or stylus to draw your signature.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: SignaturePainter(key: _signatureKey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _clearSignature,
                icon: const Icon(Icons.refresh),
                label: const Text('Clear Signature'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveSignature,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Next: Review & Package'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends StatefulWidget {
  const SignaturePainter({super.key});

  @override
  State<SignaturePainter> createState() => _SignaturePainterState();
}

class _SignaturePainterState extends State<SignaturePainter> {
  final List<Offset?> _points = [];

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _points.add(details.localPosition);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _points.add(null);
    });
  }

  void clear() {
    setState(() {
      _points.clear();
    });
  }

  Future<File> exportImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const Rect.fromLTWH(0, 0, 400, 250));

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 400, 250),
      Paint()..color = Colors.white,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
      } else if (_points[i] != null && _points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [_points[i]!],
          paint,
        );
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(400, 250);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/signature_temp.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: CustomPaint(
        painter: _SignatureCustomPainter(_points),
        size: Size.infinite,
      ),
    );
  }
}

class _SignatureCustomPainter extends CustomPainter {
  final List<Offset?> points;

  _SignatureCustomPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignatureCustomPainter oldDelegate) => true;
}
