import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';

class GenAi extends StatefulWidget {
  const GenAi({Key? key}) : super(key: key);

  @override
  State<GenAi> createState() => _GenAiState();
}

class _GenAiState extends State<GenAi> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  Future<void> _generateAIResponse(String query) async {
    String apiKey = "AIzaSyB2M-kf1d_bZgyTQ_hpME01z9JDETat2gg";
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      return;
    }
    // For text-only input, use the gemini-pro model
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [Content.text(query)];
    final response = await model.generateContentStream(content);
    await for (final chunk in response) {
      setState(() {
        _messages.add("AI: ${chunk.text ?? ''}");
      });
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });
      _generateAIResponse(message);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GenAI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Align(
                    alignment: _messages[index].startsWith('AI:') ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: _messages[index].startsWith('AI:') ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomLeft: _messages[index].startsWith('AI:') ? Radius.circular(0) : Radius.circular(12.0),
                          bottomRight: _messages[index].startsWith('AI:') ? Radius.circular(12.0) : Radius.circular(0),
                        ),
                      ),
                      child: Text(
                        _messages[index].replaceAll('AI:', '').trim(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(_textController.text),
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

