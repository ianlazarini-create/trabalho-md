import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';

class DataService {
  static List<Cliente> clientes = [];
  static List<Produto> produtos = [];
  static List<Pedido> pedidos = [];

  static int proximoIdCliente = 1;
  static int proximoIdProduto = 1;
  static int proximoIdPedido = 1;

  static bool jaInicializou = false;

  static void adicionarCliente(String nome, String cpfCnpj, String telefone) {
    var novo = Cliente(proximoIdCliente, nome, cpfCnpj, telefone);
    clientes.add(novo);
    proximoIdCliente++;
  }

  static void removerCliente(int id) {
    for (int i = 0; i < clientes.length; i++) {
      if (clientes[i].id == id) {
        clientes.removeAt(i);
        return;
      }
    }
  }

  static void adicionarProduto(String descricao, double preco, int estoque) {
    var novo = Produto(proximoIdProduto, descricao, preco, estoque);
    produtos.add(novo);
    proximoIdProduto++;
  }

  static void removerProduto(int id) {
    for (int i = 0; i < produtos.length; i++) {
      if (produtos[i].id == id) {
        produtos.removeAt(i);
        return;
      }
    }
  }

  static void adicionarPedido(Cliente cliente, List<ItemPedido> itens) {
    var novo = Pedido(proximoIdPedido, cliente, itens, DateTime.now());
    pedidos.add(novo);
    proximoIdPedido++;

    for (var item in itens) {
      item.produto.estoque = item.produto.estoque - item.quantidade;
    }
  }

  static double getTotalFaturado() {
    double total = 0;
    for (var p in pedidos) {
      total = total + p.getTotal();
    }
    return total;
  }

  static int getTotalProdutosVendidos() {
    int total = 0;
    for (var p in pedidos) {
      total = total + p.getTotalItens();
    }
    return total;
  }

  static void carregarDadosIniciais() {
    if (jaInicializou) return;
    jaInicializou = true;

    adicionarCliente('Carlos Pereira', '123.456.789-00', '(43) 99999-1111');
    adicionarCliente('Ana Lima', '987.654.321-00', '(43) 99999-2222');
    adicionarCliente('Empresa XYZ Ltda', '12.345.678/0001-90', '(43) 3333-4444');

    adicionarProduto('Notebook Dell', 3500.00, 10);
    adicionarProduto('Mouse Logitech', 89.90, 50);
    adicionarProduto('Teclado Mecanico', 250.00, 30);
    adicionarProduto('Monitor 24 polegadas', 950.00, 15);
  }
}
