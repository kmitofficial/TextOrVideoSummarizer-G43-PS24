import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VideoSummarizerPage extends StatefulWidget {
  const VideoSummarizerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoSummarizerPageState createState() => _VideoSummarizerPageState();
}

class _VideoSummarizerPageState extends State<VideoSummarizerPage> {
  final TextEditingController _textController = TextEditingController();
  String summary = '';
  bool _isSummaryVisible = false;

  void _summarizeText() async {
    final userInput = _textController.text;
    if (userInput.isNotEmpty) {
      final output = await query(userInput);
      setState(() {
        summary = output;
        _isSummaryVisible = true;
      });
    }
  }

  Future<String> query(String userInput) async {
    final apiUrl = dotenv.env['API_URL'];
    final apiKey = dotenv.env['API_KEY'];
    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(Uri.parse(apiUrl!),
          headers: headers, body: json.encode({"inputs": userInput}));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          final generatedText = responseData[0]["generated_text"] as String?;
          if (generatedText != null) {
            return generatedText;
          } else {
            debugPrint("API Error Response Body: ${response.body}");
            throw Exception(
                "Invalid response format: 'generated_text' field is missing or null");
          }
        } else {
          debugPrint("API Error Response Body: ${response.body}");
          throw Exception(
              "Invalid response format: response body is not a non-empty list");
        }
      } else {
        debugPrint("API Error Response Body: ${response.body}");
        throw Exception("Failed to call LLM API: ${response.statusCode}");
      }
    } on Exception catch (error) {
      debugPrint("Error calling LLM API: $error");
      rethrow;
    }
  }


  void _showCustomDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4E80A8), Color(0xFF416D98)], 
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Enter your vifeo url to Summarize ',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _summarizeText,
                    child: const Text('Summarize'),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _isSummaryVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Transform.scale(
                      scale: _isSummaryVisible ? 1.05 : 0.0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Text(
                          summary,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String message;

  const CustomDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
