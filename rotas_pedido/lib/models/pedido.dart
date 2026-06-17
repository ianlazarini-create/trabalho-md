import 'cliente.dart';
import 'produto.dart';

class ItemPedido {
  Produto produto;
  int quantidade;

  ItemPedido(this.produto, this.quantidade);

  double getSubtotal() {
    return produto.preco * quantidade;
  }
}

class Pedido {
  int id;
  Cliente cliente;
  List<ItemPedido> itens;
  DateTime data;

  Pedido(this.id, this.cliente, this.itens, this.data);

  double getTotal() {
    double total = 0;
    for (var item in itens) {
      total = total + item.getSubtotal();
    }
    return total;
  }

  int getTotalItens() {
    int total = 0;
    for (var item in itens) {
      total = total + item.quantidade;
    }
    return total;
  }
}
