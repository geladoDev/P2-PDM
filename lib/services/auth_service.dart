import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Usuario? get usuarioAtual {
    final user = _auth.currentUser;
    if (user == null) return null;
    return Usuario(
      uid: user.uid,
      nome: user.displayName ?? 'Usuário',
      email: user.email ?? '',
    );
  }

  Future<Usuario?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      final user = cred.user;
      if (user != null) {
        await user.updateDisplayName(nome.trim());
        await user.reload();
        final novoUsuario = Usuario(
          uid: user.uid,
          nome: nome.trim(),
          email: email.trim(),
        );
        await _db.child('usuarios').child(user.uid).set(novoUsuario.toMap());
        return novoUsuario;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _traduzirErroAuth(e.code);
    }
  }

  Future<Usuario?> login({
    required String email,
    required String senha,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      final user = cred.user;
      if (user != null) {
        return Usuario(
          uid: user.uid,
          nome: user.displayName ?? 'Usuário',
          email: user.email ?? '',
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _traduzirErroAuth(e.code);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _traduzirErroAuth(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      default:
        return 'Erro na autenticação ($code). Tente novamente.';
    }
  }
}
