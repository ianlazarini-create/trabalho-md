import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/cliente_screen.dart';
import '../screens/produto_screen.dart';
import '../screens/pedido_screen.dart';
import '../screens/dashboard_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String menu = '/menu';
  static const String cliente = '/cliente';
  static const String produto = '/produto';
  static const String pedido = '/pedido';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    menu: (context) => const MenuScreen(),
    cliente: (context) => const ClienteScreen(),
    produto: (context) => const ProdutoScreen(),
    pedido: (context) => const PedidoScreen(),
    dashboard: (context) => const DashboardScreen(),
  };
}
