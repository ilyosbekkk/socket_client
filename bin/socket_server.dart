import 'dart:io';

List<ChatClient> clients = [];

void main() async {
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 4567);

  // listen for client connections to the server
  server.listen((client) {
    handleConnection(client);
  });
}

void handleConnection(Socket client) {
  print(
      'Connection from' '${client.remoteAddress.address}:${client.remotePort}');

  clients.add(ChatClient(client));

  client.write("Welcome to our chat! there are ${clients.length} participants here!");
}

class ChatClient {
  Socket? _socket;
  String? address;
  int? port;

  ChatClient(Socket socket) {
    _socket = socket;
    address = _socket!.remoteAddress.address;
    port = _socket!.remotePort;

     _socket!.listen(messageHandler,
        onError: errorHandler,
        onDone: finishedHandler);
  }

  void messageHandler(Iterable<int> data) {
    String message = String.fromCharCodes(data).trim();
    distributeMessage(this, '$address:$port Message: $message');
  }

  void errorHandler(error) {
    print('$address:$port Error: $error');
    removeClient(this);
    _socket!.close();
  }

  void finishedHandler() {
    print('$address:$port Disconnected');
    removeClient(this);
    _socket!.close();
  }

  void distributeMessage(ChatClient client, String message) {
    for (ChatClient c in clients) {
      if (c != client) {
        c.write(message + "\n");
      }
    }
  }

  void removeClient(ChatClient client) {
    clients.remove(client);
  }

  void write(String message) {
    _socket!.write(message);
  }
}
