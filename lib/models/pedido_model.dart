class Pedido {
  String? id;
  String data;
  String topo;
  String bolo;
  String kg;
  String nome;
  String idade;
  String? imageUrl;
  String status;

  Pedido({
    this.id,
    required this.data,
    required this.topo,
    required this.bolo,
    required this.kg,
    required this.nome,
    required this.idade,
    required this.status,
    this.imageUrl,
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
    };
  }

  static Pedido fromMap(String id, Map<String, dynamic> map) {
    return Pedido(
      id: id,
      data: map['data'],
      topo: map['topo'],
      bolo: map['bolo'],
      kg: map['kg'],
      nome: map['nome'],
      idade: map['idade'],
      status: map['status'],
      imageUrl: map['imageUrl'],
    );
  }
}
