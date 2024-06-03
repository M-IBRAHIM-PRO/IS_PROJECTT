import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// void main() => runApp(MyApp());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Microphone Permission Apps'),
        ),
        body: MicrophoneApps(),
      ),
    );
  }
}

class MicrophoneApps extends StatefulWidget {
  @override
  _MicrophoneAppsState createState() => _MicrophoneAppsState();
}

class _MicrophoneAppsState extends State<MicrophoneApps> {
  List<String> _apps = [];

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      await Permission.microphone.request();
    }

    if (await Permission.microphone.isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // TODO: Implement platform-specific code to list apps with microphone permission
    }

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_apps[index]),
        );
      },
    );
  }
}
