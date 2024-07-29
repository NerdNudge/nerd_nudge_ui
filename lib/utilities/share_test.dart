import 'package:flutter/material.dart';
//import 'package:share_plus/share_plus.dart';

class ShareExample extends StatelessWidget {
  const ShareExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Share.share('Check out this amazing content!');
          },
          child: Text('Share'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShareExample(),
  ));
}