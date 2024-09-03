import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  final String otp;
  final VoidCallback onOTPVerified;

  const OTPScreen({required this.otp, required this.onOTPVerified, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
              onChanged: (value) {
                if (value == otp) {
                  onOTPVerified();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality if required
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
