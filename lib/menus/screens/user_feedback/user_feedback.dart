import 'package:flutter/material.dart';
import 'package:nerd_nudge/menus/services/user_feedback_service/user_feedback_service.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../../../utilities/colors.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedFeedbackType = 'Submit a Bug Report';
  final TextEditingController _commentsController = TextEditingController();

  final Map<String, String> _feedbackDescriptions = {
    'Submit a Bug Report': 'Spotted an anomaly? Report it so we can keep the code clean and efficient.',
    'Provide System Feedback': 'Your insights are the fuel to our innovation engine. Share your thoughts!',
    'Share an Idea': 'Got a cosmic idea? Beam it down to us! We’re all ears for your out-of-this-world suggestions.',
    'Request New Category': 'Need a new tool in your tech arsenal? Let us know what you’re missing, and we’ll get to work!',
    'Miscellaneous': 'Have something else on your mind? Drop your thoughts here and let’s geek out together!',
    'Contact Us': 'Have a question or need support? Reach out to us and we’ll be happy to help!'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20,),
              const Text(
                'Select Feedback Type: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                value: _selectedFeedbackType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFeedbackType = newValue!;
                  });
                },
                items: _feedbackDescriptions.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                _feedbackDescriptions[_selectedFeedbackType]!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _commentsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your comments here',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some comments';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Styles.showGlobalSnackbarMessageAndIcon('Feedback submitted', Icons.thumb_up, Colors.black);
                      UserFeedbackService().submitUserFeedBack(_selectedFeedbackType, _commentsController.text);
                      _commentsController.clear();
                    }
                  },
                  label: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                        color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.purpleButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }
}