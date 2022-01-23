class Usuario {
  String nome;
  String email;
  String senha;
  String confirmarSenha;
  String id;
  bool isAdmin = false;

  Usuario();

  bool get isSamePassword => senha == confirmarSenha;

  Usuario.fromJson(Map<String, dynamic> map) {
    this.nome = map['nome'];
    this.email = map['email'];
    this.id = map['id'];
    this.isAdmin = map['isAdmin'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nome': this.nome,
      'email': this.email,
      'id': this.id,
      'isAdmin': this.isAdmin
    };

    return map;
  }
}
