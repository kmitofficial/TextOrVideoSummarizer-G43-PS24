import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GetStartedPage(), 
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    const apiUrl = "https://api-inference.huggingface.co/models/Manu1507/Llama-2-7b-finetunee";
    final headers = {
      "Authorization": "Bearer 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",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: json.encode({"inputs": userInput}));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          final summaryText = responseData[0]["summary_text"] as String?;
          if (summaryText != null) {
            return summaryText;
          } else {
            debugPrint("API Error Response Body: ${response.body}");
            throw Exception("Invalid response format: 'summary_text' field is missing or null");
          }
        } else {
          debugPrint("API Error Response Body: ${response.body}");
          throw Exception("Invalid response format: response body is not a non-empty list");
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

  void _openDocument(BuildContext context) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      debugPrint('Document picked: ${result.files.single.path}');
      _showCustomDialog(context, 'Document selected from drive');
    }
  }

  void _showCustomDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          message: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'SAPOTA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4E80A8), Color(0xFF416D98)], // Blue Gradient
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
            TabBarView(
              children: [
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
                                hintText: 'Enter your Text to Summarize ',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _openDocument(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insert_drive_file),
                              SizedBox(width: 8),
                              Text('Select Document'),
                            ],
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
                const SettingsPage(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String message;

  const CustomDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

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
