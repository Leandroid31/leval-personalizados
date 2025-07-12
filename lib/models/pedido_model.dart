class Pedido {
  final String id;
  final String data;
  final String topo;
  final String bolo;
  final String kg;
  final String nome;
  final String idade;
  final String status;
  final String? imageUrl;
  final String valor; // Novo campo

  Pedido({
    required this.id,
    required this.data,
    required this.topo,
    required this.bolo,
    required this.kg,
    required this.nome,
    required this.idade,
    required this.status,
    this.imageUrl,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'topo': topo,
      'bolo': bolo,
      'kg': kg,
      'nome': nome,
      'idade': idade,
      'status': status,
      'imageUrl': imageUrl,
      'valor': valor,
    };
  }

  factory Pedido.fromMap(String id, Map<String, dynamic> map) {
    return Pedido(
      id: id,
      data: map['data'] ?? '',
      topo: map['topo'] ?? '',
      bolo: map['bolo'] ?? '',
      kg: map['kg'] ?? '',
      nome: map['nome'] ?? '',
      idade: map['idade'] ?? '',
      status: map['status'] ?? '',
      imageUrl: map['imageUrl'],
      valor: map['valor'] ?? '0',
    );
  }
}
}
