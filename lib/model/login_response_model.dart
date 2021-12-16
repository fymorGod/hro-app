class LoginResponseModel {
  LoginResponseModel({
    required this.refresh,
    required this.acess,
    required this.usuario,
  });
  late final String refresh;
  late final String acess;
  late final Usuario usuario;

  LoginResponseModel.fromJson(Map<String, dynamic> json){
    refresh = json['refresh'];
    acess = json['acess'];
    usuario = Usuario.fromJson(json['usuario']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['refresh'] = refresh;
    _data['acess'] = acess;
    _data['usuario'] = usuario.toJson();
    return _data;
  }
}

class Usuario {
  Usuario({
    required this.username,
    required this.papel,
    required this.avatar,
  });
  late final String username;
  late final List<Papel> papel;
  late final String avatar;

  Usuario.fromJson(Map<String, dynamic> json){
    username = json['username'];
    papel = List.from(json['papel']).map((e)=>Papel.fromJson(e)).toList();
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['papel'] = papel.map((e)=>e.toJson()).toList();
    _data['avatar'] = avatar;
    return _data;
  }
}

class Papel {
  Papel({
    required this.id,
    required this.text,
    required this.icon,
    required this.ativo,
  });
  late final int id;
  late final String text;
  late final String icon;
  late final bool ativo;

  Papel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    text = json['text'];
    icon = json['icon'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['text'] = text;
    _data['icon'] = icon;
    _data['ativo'] = ativo;
    return _data;
  }
}