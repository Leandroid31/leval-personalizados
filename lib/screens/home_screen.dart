import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'new_pedido_screen.dart';
import '../models/pedido_model.dart';
import '../widgets/pedido_card.dart';

class HomeScreen extends StatelessWidget {
   String filtroStatus = 'Todos';
  double? valorMin;
  double? valorMax;
  final auth = FirebaseAuth.instance;
  
  void logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final uid = auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('LeVal Personalizados'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => NewPedidoScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('pedidos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final pedido = Pedido.fromMap(docs[i].id, docs[i].data() as Map<String, dynamic>);
              return PedidoCard(pedido: pedido);
            },
          );
        },
      ),
    );
  }
}
