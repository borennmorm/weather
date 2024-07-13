import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final String telegramBotToken =
      '7497426866:AAEUBauT0Yev4WwdctpRg5gGxOvmMfvZqk8';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String feedback = _feedbackController.text;

      // Example: Replace with your Telegram chat ID
      const String chatId = '-4219390905';

      // Construct the message text
      String messageText = '*Feedback Submission*\n'
          'Name: $name\n'
          'Feedback: $feedback\n'
          'Rating: $_rating ⭐️';

      // Construct the Telegram bot API endpoint
      final String url =
          'https://api.telegram.org/bot$telegramBotToken/sendMessage';

      // Send a POST request to the Telegram bot API
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'chat_id': chatId,
          'text': messageText,
          'parse_mode': 'Markdown',
        }),
      );

      if (response.statusCode == 200) {
        // Successfully sent feedback to Telegram
        Get.snackbar('Success', 'Feedback submitted successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Failed to send feedback to Telegram
        Get.snackbar('Error', 'Failed to submit feedback',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 129, 163),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    labelText: 'Feedback',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Rating:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 129, 163),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
