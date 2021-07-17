import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController mensajeController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<Data> messages = [
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
    Data(receiverID: "15", senderID: "11", message: 'ola mi ciela'),
    Data(receiverID: "10", senderID: "01", message: 'ola mi ciela'),
  ];
  late Socket socket;
  @override
  void initState() {
    connectToServer();
    super.initState();
  }

  void connectToServer() async {
    // Dart client
    print("hola2");
    try {
      print("hola3");
      socket = io(
          'http://192.168.1.7:3001',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .enableForceNewConnection() // necessary because otherwise it would reuse old connection

              .setQuery(<String, dynamic>{'chatID': '12345'})
              .build());
      socket.connect();
      socket.onConnect((socket) {
        print('connect');
      });
      print(socket.connected);
      socket.on('chat:message', (data) {
        print(data);
        setState(() => messages.add(Data.fromJson(data)));

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 1,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
      socket.onDisconnect((_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print("error: $e");
    }
  }

  void sendMessage({required String data}) {
    socket.emit('chat:message',
        {'receiverID': "12345", 'senderID': "1311", 'message': data});
    mensajeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: new Text("App para chat con socket tio")),
        body: SafeArea(
          child: Container(
              child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10.0,
                  );
                },
                reverse: false,
                shrinkWrap: true,
                itemCount: messages.length,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (BuildContext context, int index) {
                  Data m = messages[index];
                  if (m.senderID == "11")
                    return _buildMessageRow(m, current: true);
                  return _buildMessageRow(m, current: false);
                },
              )),
              _bottomBar(context)
            ],
          )),
        ));
  }

  Container _bottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: mensajeController,
              decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () => sendMessage(data: mensajeController.text),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  Row _buildMessageRow(Data data, {required bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: current ? 30.0 : 20.0,
        ),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color:
                  current ? Theme.of(context).primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              data.message!,
              style: TextStyle(
                  color: current ? Colors.white : Colors.black, fontSize: 18),
            )),
        SizedBox(
          width: current ? 20.0 : 30.0,
        )
      ],
    );
  }
}

/*
todo lo grs debe de ser color del logo= azul
en la parte de empresa, hay que mostrar más información sobre la empresa,
la imagen de perfil que sea vea grande(ahorita no)
cambiar al color corporativo
categoría de usuario se debe cargar en el panel y mostrar en la app...
agregar tipos de usuario en el panel => y que se carguen en la app al momento de registrar y de editar mis datos.
si voy a mis cotizaciones y no tengo clientes o productos entonces hay que mostrarle un mensaje al usuario que debe agregar cliente y(o) producto.

si agrego un producto a la cotización, que se agregue correctamente y que se quite de la lista de productos a agregar...
creación de la liga.


crud en el panel para el tipo de usuario...
*/

class Data {
  Data({
    this.receiverID,
    this.senderID,
    this.message,
  });

  String? receiverID;
  String? senderID;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        receiverID: json["receiverID"],
        senderID: json["senderID"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "senderID": senderID,
        "receiverID": receiverID,
        "message": message,
      };
}
