import 'dart:io';

import 'package:chat_app/src/widget/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;

  List<ChatMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('OT', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            const Text('Oscar Tenesaca',
                style: TextStyle(color: Colors.black87, fontSize: 12)),
          ],
        ),
        elevation: 1,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) =>
                      _messages[index]),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  //TODO:
                  setState(() {
                    if (texto.trim().length > 0) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar Mensage',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _isWriting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String texto) {
    if (texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: '123',
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
