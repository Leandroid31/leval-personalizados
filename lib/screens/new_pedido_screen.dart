import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido_model.dart';

class NewPedidoScreen extends StatefulWidget {
  final Pedido? pedido;

  NewPedidoScreen({this.pedido});

  @override
  _NewPedidoScreenState createState() => _NewPedidoScreenState();
}

class _NewPedidoScreenState extends State<NewPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final _dataController = TextEditingController();
  final _topoController = TextEditingController();
  final _boloController = TextEditingController();
  final _kgController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _valorController = TextEditingController();
  final _valorController = TextEditingController();

  File? _image;
  String _status = 'Pedido em andamento';

  @override
  void initState() {
    super.initState();
    if (widget.pedido != null) {
      final p = widget.pedido!;
      _dataController.text = p.data;
      _topoController.text = p.topo;
      _boloController.text = p.bolo;
      _kgController.text = p.kg;
      _nomeController.text = p.nome;
      _idadeController.text = p.idade;
      _status = p.status;
      _valorController.text = p.valor;
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(String userId, String pedidoId) async {
    if (_image == null) return widget.pedido?.imageUrl;
    final ref = FirebaseStorage.instance
        .ref('pedidos/$userId/$pedidoId.jpg');
    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

  void _savePedido() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final pedidoId = widget.pedido?.id ??
        FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .collection('pedidos')
            .doc()
            .id;

    final imageUrl = await _uploadImage(userId, pedidoId);

    final pedido = Pedido(
      id: pedidoId,
      data: _dataController.text,
      topo: _topoController.text,
      bolo: _boloController.text,
      kg: _kgController.text,
      nome: _nomeController.text,
      idade: _idadeController.text,
      valor: _valorController.text,
      status: _status,
      imageUrl: imageUrl,
      
    );

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .collection('pedidos')
        .doc(pedidoId)
        .set(pedido.toMap());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: _dataController, decoration: InputDecoration(labelText: 'Data')),
                TextFormField(controller: _topoController, decoration: InputDecoration(labelText: 'Topo')),
                TextFormField(controller: _boloController, decoration: InputDecoration(labelText: 'Bolo')),
                TextFormField(controller: _kgController, decoration: InputDecoration(labelText: 'Kg')),
                TextFormField(controller: _nomeController, decoration: InputDecoration(labelText: 'Nome')),
                TextFormField(controller: _idadeController, decoration: InputDecoration(labelText: 'Idade')),
                TextFormField(controller: _valorController, decoration: InputDecoration(labelText: 'Valor (R\$)'),keyboardType: TextInputType.number,),
                DropdownButton<String>(
                  value: _status,
                  items: ['Pedido em andamento', 'Pedido pronto']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => _status = val!);
                  },
                ),
                SizedBox(height: 10),
                _image != null
                    ? Image.file(_image!, height: 100)
                    : widget.pedido?.imageUrl != null
                        ? Image.network(widget.pedido!.imageUrl!, height: 100)
                        : Text('Sem imagem'),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text('Selecionar Foto'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _savePedido,
                  child: Text('Salvar Pedido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
