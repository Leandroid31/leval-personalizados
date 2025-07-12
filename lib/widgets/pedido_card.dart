import 'package:flutter/material.dart';
import '../models/pedido_model.dart';
import '../screens/new_pedido_screen.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  PedidoCard({required this.pedido});

  final ScreenshotController screenshotController = ScreenshotController();

  void _exportarJPG(BuildContext context) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/${pedido.nome}_${pedido.data}.jpg');

    final image = await screenshotController.capture();
    await file.writeAsBytes(image!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exportado para ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: pedido.imageUrl != null
              ? Image.network(pedido.imageUrl!, width: 60, fit: BoxFit.cover)
              : Icon(Icons.cake),
          title: Text('${pedido.nome} - ${pedido.topo}'),
          subtitle: Text('Data: ${pedido.data} | Status: ${pedido.status}'),
          trailing: PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'editar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewPedidoScreen(pedido: pedido),
                  ),
                );
              } else if (val == 'exportar') {
                _exportarJPG(context);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'exportar', child: Text('Exportar JPG')),
            ],
          ),
        ),
      ),
    );
  }
}
