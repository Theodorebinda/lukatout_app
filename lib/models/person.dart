// import 'township.dart';

class IPerson {
  final String id;
  final String firstName;
  final String lastName;
  final String? middlename;
  final String? birthDate;
  final String? schoolLevel;
  final String? studyField;
  final String? maritalStatus;
  final String? nationality;
  final String? gender;
  final Map<String, dynamic>? taxPayer;
  final Map<String, dynamic>? agent;
  final DateTime createdAt;
  late DateTime? updatedAt;
  late dynamic updatedBy;
  final dynamic createBy;
  final Object? meta;
  final String? townshipId;
  // final ITownship? Township;
  final String? address; // rue, avenue et numero

  final String? photoUrl;
  final String currentPhoneNumber;
  final String? currentEmailAddress;
  final String identityCard;

  IPerson(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.taxPayer,
      this.middlename,
      required this.birthDate,
      required this.schoolLevel,
      required this.studyField,
      required this.maritalStatus,
      required this.gender,
      required this.nationality,
      required this.agent,
      required this.photoUrl,
      required this.address,
      required this.currentPhoneNumber,
      required this.currentEmailAddress,
      required this.identityCard,
      required this.createdAt,
      required this.createBy,
      required this.meta,
      // required this.Township,
      required this.townshipId,
      required this.updatedAt});

  factory IPerson.fromJson(Map<String, dynamic> json) {
    return IPerson(
      id: json.containsKey('id') ? json['id'] : '-',
      firstName: json.containsKey('firstName') ? json['firstName'] : '',
      lastName: json.containsKey('lastName') ? json['lastName'] : '',
      photoUrl: json.containsKey('photoUrl') ? json['photoUrl'] : '',
      gender: json.containsKey('gender') ? json['gender'] : '',
      maritalStatus:
          json.containsKey('maritalStatus') ? json['maritalStatus'] : '',
      schoolLevel: json.containsKey('schoolLevel') ? json['schoolLevel'] : '',
      nationality: json.containsKey('nationality') ? json['nationality'] : '',
      studyField: json.containsKey('studyField') ? json['studyField'] : '',
      currentPhoneNumber: json.containsKey('currentPhoneNumber')
          ? json['currentPhoneNumber']
          : '',
      currentEmailAddress: json.containsKey('currentEmailAddress')
          ? json['currentEmailAddress']
          : '',
      address: json.containsKey('address') ? json['address'] : '',
      birthDate: json.containsKey('birthDate') ? json['birthDate'] : '',
      identityCard:
          json.containsKey('identityCard') && json['identityCard'] != null
              ? json['identityCard']
              : '',
      middlename: json.containsKey('middlename') ? json['middlename'] : '',
      taxPayer: json.containsKey('taxPayer')
          ? json['taxPayer'] as Map<String, dynamic>
          : null,
      agent: json.containsKey('agent')
          ? json['agent'] as Map<String, dynamic>
          : null,
      townshipId: json.containsKey('townshipId') ? json['townshipId'] : '',
      // Township:
      //     json.containsKey('Township') ? json['Township'] as ITownship : null,
      createdAt: json.containsKey('createdAt')
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      createBy: json.containsKey('createBy') ? json['createBy'] : '',
      meta: json.containsKey('meta') ? json['meta'] : {},
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  factory IPerson.empty() {
    return IPerson(
      id: '',
      firstName: '',
      gender: '',
      schoolLevel: '',
      studyField: '',
      maritalStatus: '',
      birthDate: '',
      nationality: '',
      lastName: '',
      taxPayer: {},
      agent: {},
      address: '',
      createdAt: DateTime.now(),
      createBy: null,
      meta: null,
      // Township: null,
      townshipId: '',
      updatedAt: null,
      identityCard: '',
      currentEmailAddress: '',
      currentPhoneNumber: '',
      photoUrl: '',
    );
  }

  @override
  String toString() {
    return '''
        IPerson(
          id: $id,
          firstName: $firstName,
          lastName: $lastName,
          gender: $gender,
          schoolLevel: $schoolLevel,
          maritalStatus: $maritalStatus,
          studyField: $studyField,
          nationality: $nationality,
          birthDate: $birthDate,
          middlename: $middlename,
          taxPayer: $taxPayer,
          agent: $agent,
          createdAt: $createdAt,
          createBy: $createBy,
          meta: $meta,
 
          townshipId: $townshipId
        )
    ''';
  }
}
