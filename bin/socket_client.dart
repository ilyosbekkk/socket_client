import 'dart:io';
import 'dart:typed_data';

void main() async {
  // connect to the socket server
  final socket = await Socket.connect('localhost', 4567);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (Uint8List data) {
      print("yessss");

      print(String.fromCharCodes(data).trim());
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  stdin
      .listen((data) => socket.write(String.fromCharCodes(data).trim() + '\n'));
}
