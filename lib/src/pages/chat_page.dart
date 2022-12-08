import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/services/auth_services.dart';
import 'package:chat_app/src/services/socket_services.dart';
import 'package:chat_app/src/widget/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/chat_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  ChatServices? chatServ;
  SocketService? socketService;
  AuthService? authService;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatServ = Provider.of<ChatServices>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService!.getSocket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatServ!.usuarioPara!.uid);
  }

  void _escucharMensaje(dynamic payload) {
    print(payload['mensaje']);
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje>? chat = await chatServ!.getChat(usuarioId);

/* 
*nota
Crear un arreglo tipo ChatMessage

*/

    final history = chat!.map((m) => ChatMessage(
          texto: '${m.mensaje}',
          uid: '${m.de}',
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatServ!.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(usuarioPara!.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.nombre,
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
      uid: authService!.usuario!.uid, //user logeado
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketService?.getSocket.emit('mensaje-personal', {
      'de': authService?.usuario!.uid,
      'para': chatServ!.usuarioPara!.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
// desconectar del canal
    socketService!.getSocket.off('mensaje-personal');

    super.dispose();
  }
}
