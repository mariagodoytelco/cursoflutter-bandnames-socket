import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            //evento: emitir-mensaje
            //{nombre: 'Flutter', mensaje: 'Hola desde Flutter'}
            socketService.emit('emitir-mensaje', 
            {'nombre': 'Flutter', 
            'mensaje': 'Hola desde Flutter'});
          }),
    );
  }
}
