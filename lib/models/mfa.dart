// ignore_for_file: constant_identifier_names

enum MFaFlag {
  Email,
  PhoneNumber,
  Common2FaApp,
  Sycamore2FaApp,
  QuestionResponse,
  PassCode
}

enum MFaPurpose { LoginOnly, LoginAndResetPassword, ResetPasswordOnly }

class IMfa {
  final String id;
  final String mfaName;
  final bool isActivated;
  final String descriptionStr;
  final String descriptionCfg;
  final bool isDefault;
  final String mFaFlag;
  // final MFaPurpose mFaPurpose;

  // final List<dynamic> permissions;
  IMfa({
    required this.id,
    required this.mfaName,
    required this.isActivated,
    required this.descriptionStr,
    required this.descriptionCfg,
    required this.isDefault,
    required this.mFaFlag,
    // required this.mFaPurpose,
    // required this.permissions
  });

  factory IMfa.fromJson(Map<String, dynamic> json) {
    return IMfa(
      id: json.containsKey('id') ? json['id'] : '-',
      mfaName: json.containsKey('mfaName') ? json['mfaName'] : '-',
      isActivated: json.containsKey('isActivated') ? json['isActivated'] : '-',
      descriptionStr:
          json.containsKey('descriptionStr') ? json['descriptionStr'] : '-',
      descriptionCfg:
          json.containsKey('descriptionCfg') ? json['descriptionCfg'] : '-',
      isDefault: json.containsKey('isDefault') ? json['isDefault'] : '-',
      // permissions: json.containsKey('permissions') ? json['permissions'] : [],
      mFaFlag: json.containsKey('mFaFlag')
          ? json['mFaFlag']
          : MFaFlag.Email.toString(),
      // mFaPurpose: json.containsKey('mFaPurpose') ? json['mFaPurpose'] : '-',
    );
  }
  factory IMfa.fromData(Map<String, dynamic> json) {
    return IMfa(
      id: json.containsKey('id') ? json['id'] : '-',
      mfaName: json.containsKey('mfaName') ? json['mfaName'] : '-',
      isActivated: json.containsKey('isActivated') ? json['isActivated'] : '-',
      descriptionStr:
          json.containsKey('descriptionStr') ? json['descriptionStr'] : '-',
      descriptionCfg:
          json.containsKey('descriptionCfg') ? json['descriptionCfg'] : '-',
      isDefault: json.containsKey('isDefault') ? json['isDefault'] : '-',
      // permissions: json.containsKey('permissions') ? json['permissions'] : [],
      mFaFlag: json.containsKey('mFaFlag') ? json['mFaFlag'] : '-',
      // mFaPurpose: json.containsKey('mFaPurpose') ? json['mFaPurpose'] : '-',
    );
  }

  @override
  String toString() {
    return '''
        IMfa(
          mfaName : $mfaName,
          id    : $id,
          isActivated  : $isActivated,
          descriptionStr : $descriptionStr,
          descriptionStr : $descriptionStr,
          isDefault : $isDefault,
          mFaFlag : $mFaFlag,


        )
    ''';
  }
}

class IMFaLoginData {
  final List<IMfa> mfas;
  IMFaLoginData({required this.mfas});
}
