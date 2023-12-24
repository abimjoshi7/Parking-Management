import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestScreen extends StatefulWidget {
  static const name = 'test';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  void sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      channel.sink.add(_textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
            child: TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: sendMessage, child: const Icon(Icons.send)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
    _textEditingController.dispose();
  }
}
