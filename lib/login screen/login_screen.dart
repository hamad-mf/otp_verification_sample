import 'dart:async'; // Import to use Timer
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:otp_verification_sample/home%20screen/home_screen.dart';
import 'package:otp_verification_sample/otp%20screen/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  String _otp = '';
  bool _isButtonEnabled = false; // State to track button enabled/disabled
  OverlayEntry? _overlayEntry; // Reference to the overlay entry
  Timer? _overlayTimer; // Reference to the timer

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(
        _updateButtonState); // Add listener to TextEditingController
  }

  @override
  void dispose() {
    _phoneNumberController
        .removeListener(_updateButtonState); // Remove listener
    _phoneNumberController.dispose();
    _removeNotification(); // Clean up the overlay and timer
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _phoneNumberController
          .text.isNotEmpty; // Enable button if text is not empty
    });
  }

  void _generateOTP() {
    // Generate a random 6-digit OTP
    _otp = List.generate(6, (_) => Random().nextInt(10)).join();

    // Show a custom pop-up notification at the top
    _showCustomTopNotification('OTP: $_otp');
  }

  void _showCustomTopNotification(String message) {
    _removeNotification(); // Remove any existing overlay

    // Create an overlay entry to show at the top of the screen
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0, // Set position from the top
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay into the Overlay widget
    Overlay.of(context).insert(_overlayEntry!);

    // Set up a timer to remove the overlay after 60 seconds
    _overlayTimer = Timer(Duration(seconds: 60), _removeNotification);
  }

  void _removeNotification() {
    // Remove the overlay if it exists
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Cancel the timer if it exists
    if (_overlayTimer != null) {
      _overlayTimer!.cancel();
      _overlayTimer = null;
    }
  }

  void _navigateToOTP() {
    _generateOTP(); // Ensure OTP is generated before navigating

    // Navigate to the OTP screen without removing the notification
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
          otp: _otp,
          onOTPVerified: () {
            // Remove the notification and navigate to home screen if OTP is correct
            _removeNotification(); // Ensure overlay is removed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
              ),
              onPressed: _isButtonEnabled
                  ? _navigateToOTP
                  : null, // Check the state to enable or disable
              child: Text('Get OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
