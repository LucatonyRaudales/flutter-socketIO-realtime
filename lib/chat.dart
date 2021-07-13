import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    print("hola");
    connectToServer();
    // TODO: implement initState
    super.initState();
  }

  void connectToServer() async {
    // Dart client
    print("hola2");
    try {
      print("hola3");
      IO.Socket socket = IO.io('http://192.168.1.7:3001', <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false
      });
      socket.connect();
      socket.onConnect((socket) {
        print('connect');
      });
      print(socket.connected);
      socket.on('event', (data) => print(data));
      socket.onDisconnect((_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: new Text("App para chat con socket tio")),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
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
                    onPressed: () {},
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
            ),
          ),
        ],
      ), /*
      bottomNavigationBar: new Container(
        child: new Row(children: [
          new TextField(
              onChanged: (val) => print(val),
              decoration: InputDecoration(hintText: "Escribir mensaje")),
          new ElevatedButton.icon(
              onPressed: ()=>  print("preision"), icon: Icon(Icons.send), label: Text("Enviar"))
        ]),
      ),*/
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