import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> _appStateKey = GlobalKey<_MyAppState>();

  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: MyApp._appStateKey,
      home: Scaffold(
        appBar: AppBar(
          title:const Text('Settings'),
        ),
        body:const SettingsPage(),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int rating = 0;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      children: [
        ElevatedButton(
          onPressed: _showRatingDialog,
          style: ElevatedButton.styleFrom(
            padding:const EdgeInsets.all(20),
          ),
          child:const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate this app',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Icon(
                Icons.star,
                size: 30,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showContactInformation,
          style: ElevatedButton.styleFrom(
            padding:const EdgeInsets.all(20),
          ),
          child:const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Icon(
                Icons.phone,
                size: 30,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showFeedbackDialog,
          style: ElevatedButton.styleFrom(
            padding:const EdgeInsets.all(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feedback',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Icon(
                Icons.edit,
                size: 30,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRatingDialog() {
    _showDialogWithTransition(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Rate this app'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
                  (index) => IconButton(
                onPressed: () {
                  setState(() {
                    rating = index + 1;
                  });
                  Navigator.pop(context);
                  _showThankYouPrompt();
                },
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 40,
                ),
                color: Colors.amber,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showThankYouPrompt() {
    _showDialogWithTransition(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Thank You!'),
          content:const Text('Thank you for rating us.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showContactInformation() {
    _showDialogWithTransition(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Contact Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: sapota@sapota.com'),
              SizedBox(height: 10),
              Text('Phone: +1234567890'),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackDialog() {
    _showDialogWithTransition(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Feedback'),
          content: TextField(
            controller: feedbackController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                feedbackController.clear();
                Navigator.pop(context);
                _showFeedbackReceivedPrompt();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackReceivedPrompt() {
    _showDialogWithTransition(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your feedback has been received.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogWithTransition({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).moreButtonTooltip,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
