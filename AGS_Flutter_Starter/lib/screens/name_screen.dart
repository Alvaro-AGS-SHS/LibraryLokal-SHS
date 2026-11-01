import 'package:flutter/material.dart';
import 'package:ags_flutter_starter/services/storage_helper.dart';
import 'home_screen.dart'; // Imported to allow navigation to HomeScreen

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

// === THIS IS THE STATE CLASS ===
class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose(); // Always clean up controllers to prevent memory leaks
    super.dispose();
  }

  // Logic to save the name and move permanently to HomeScreen
  Future<void> _saveNameAndGoHome() async {
    final enteredName = _nameController.text.trim();
    
    if (enteredName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name to proceed.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Save the name to disk
      await StorageHelper.saveUserName(enteredName);

      if (!mounted) return;

      // 2. Alert the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome aboard!'),
          backgroundColor: Color.fromARGB(255, 174, 86, 28),
        ),
      );

      // 3. Move to HomeScreen and replace NameScreen in the history stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save name: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color.fromARGB(255, 174, 86, 28);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC), // Matches your HomeScreen background
      appBar: AppBar(
        title: const Text('Setup Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: brandOrange,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: brandOrange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to LibraryLokal!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your name to start customizing your reading list.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF607D8B)),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Type your name here',
                  prefixIcon: const Icon(Icons.person, color: brandOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: brandOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: brandOrange))
                  : ElevatedButton.icon(
                      onPressed: _saveNameAndGoHome,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Get Started'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

