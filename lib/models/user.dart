class IUser {
  final String email;
  final String id;
  final String name;
  final String phone;
  final String accessToken;
  final String refreshToken;

  // final List<dynamic> permissions;
  IUser({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    // required this.permissions
  });

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      accessToken: json.containsKey('accessToken') ? json['accessToken'] : '-',
      refreshToken: json.containsKey('refreshToken') && json['refreshToken']
          ? json['refreshToken']
          : '-',
      email: json.containsKey('email') ? json['email'] : '-',
      id: json.containsKey('id') ? json['id'] : '-',
      name: json.containsKey('name') ? json['name'] : '-',
      // permissions: json.containsKey('permissions') ? json['permissions'] : [],
      phone: json.containsKey('phone') ? json['phone'] : '-',
    );
  }
  factory IUser.fromData(Map<String, dynamic> json) {
    return IUser(
      accessToken: json.containsKey('accessToken') ? json['accessToken'] : '-',
      // json.containsKey('token') && json['token'].containsKey('accessToken')
      //     ? json['token']['accessToken']
      //     : '-',
      refreshToken: json.containsKey('refreshToken') && json['refreshToken']
          ? json['refreshToken']
          : '-',
      // json.containsKey('token') && json['token'].containsKey('refreshToken')
      //     ? json['token']['refreshToken']
      //     : '-',
      email: json.containsKey('user') && json['user'].containsKey('email')
          ? json['user']['email']
          : '-',
      id: json.containsKey('user') && json['user'].containsKey('id')
          ? json['user']['id']
          : '-',
      name: json.containsKey('user') && json['user'].containsKey('name')
          ? json['user']['name']
          : '-',
      // student: json.containsKey('user') &&
      //         json['user'].containsKey('student') &&
      //         json['user']['student'] != null
      //     ? IStudent.fromJson(json['student'])
      //     : IStudent.empty(),
      // permissions: json.containsKey('permissions') ? json['permissions'] : [],
      phone: json.containsKey('user') && json['user'].containsKey('phone')
          ? json['user']['phone']
          : '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'phone': phone,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  @override
  String toString() {
    return '''
        IUser(
          email : $email,
          id    : $id,
          name  : $name,
          phone : $phone,
          accessToken : $accessToken,
          refreshToken : $refreshToken,
        )
    ''';
  }

  factory IUser.empty() {
    return IUser(
      accessToken: '-',
      refreshToken: '-',
      email: '-',
      id: '-',
      name: '-',
      // permissions: [],
      phone: '-',
    );
  }
}
