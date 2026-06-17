import '../models/usuario.dart';

class AuthService {
  static List<Usuario> usuarios = [
    Usuario('admin', 'Administrador', '123456'),
    Usuario('joao', 'Joao Silva', 'joao123'),
    Usuario('maria', 'Maria Souza', 'maria123'),
  ];

  static Usuario? usuarioLogado;

  static bool login(String usuario, String senha) {
    for (var u in usuarios) {
      if (u.usuario == usuario && u.senha == senha) {
        usuarioLogado = u;
        return true;
      }
    }
    return false;
  }

  static void logout() {
    usuarioLogado = null;
  }
}
