import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  final String qrData;

  const QRImage(this.qrData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Already Registered'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is your unique QR code',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            QrImageView(
              data: qrData,
              size: 280,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(
                  100,
                  100,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
