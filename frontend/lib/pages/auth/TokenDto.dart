class TokenDto {
  String? sub;
  int? exp;
  int? iat;

  TokenDto({this.sub, this.exp, this.iat});

  TokenDto.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    exp = json['exp'];
    iat = json['iat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sub'] = sub;
    data['exp'] = exp;
    data['iat'] = iat;
    return data;
  }
}