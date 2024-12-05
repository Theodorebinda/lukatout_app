// ignore_for_file: non_constant_identifier_names

import 'package:lukatout/models/user.dart';

class ITaxPayer {
  final String id;
  final String? type;
  final String personId;
  final String fiscalNumber;
  // final IPerson person;
  final String? taxAccountId;
  final String userId;
  final String description;
  final IUser user;
  // final List<ICorporation> corporation;
  // final List<IPossession> possessions;
  final DateTime createdAt;
  late DateTime? updatedAt;
  late dynamic updatedBy;
  final dynamic createBy;
  final Object? meta;
  // final List<ITransaction> transaction; //ITransaction
  // final List<IOperation> operations; //IOperation
  // final List<ISectors> sectors; //IAccount

  ITaxPayer(
      {required this.id,
      required this.type,
      required this.personId,
      required this.fiscalNumber,
      // required this.person,
      required this.taxAccountId,
      required this.userId,
      required this.description,
      required this.user,
      required this.createdAt,
      required this.createBy,
      required this.meta,
      // required this.transaction,
      // required this.operations,
      // required this.sectors,
      // required this.corporation,
      // required this.possessions,
      required this.updatedAt,
      required this.updatedBy});

  factory ITaxPayer.fromJson(Map<String, dynamic> json) {
    // List<ICorporation> corporationList = [];
    // if (json.containsKey('corporation') &&
    //     json['corporation'] != null &&
    //     json['corporation'] is List) {
    //   corporationList = (json['corporation'] as List)
    //       .map((corporationMap) => ICorporation.fromJson(corporationMap))
    //       .toList();
    // } else {
    //   corporationList = [];
    // }

    //Déserialisation de Transaction
    // List<ITransaction> transactionsList = [];
    // if (json.containsKey('transactions') &&
    //     json['transactions'] != null &&
    //     json['transactions'] is List) {
    //   transactionsList = (json['transactions'] as List)
    //       .map((transactionsMap) => ITransaction.fromJson(transactionsMap))
    //       .toList();
    // } else {
    //   transactionsList = [];
    // }

    //Déserialisation des operations
    // List<IOperation> operationList = [];
    // if (json.containsKey('operations') &&
    //     json['operations'] != null &&
    //     json['operations'] is List) {
    //   operationList = (json['operations'] as List)
    //       .map((operationMap) => IOperation.fromJson(operationMap))
    //       .toList();
    // } else {
    //   operationList = [];
    // }

    // Désérialisation des secteurs
    // List<ISectors>? sectorsList = [];
    // if (json.containsKey('sectors') &&
    //     json['sectors'] != null &&
    //     json['sectors'] is List) {
    //   sectorsList = (json['sectors'] as List)
    //       .map((sector) => ISectors.fromJson(sector))
    //       .toList();
    // } else {
    //   sectorsList = [];
    // }
    // List<IPossession> possessionList = [];
    // if (json.containsKey('possessions') &&
    //     json['possessions'] != null &&
    //     json['possessions'] is List) {
    //   possessionList = (json['possessions'] as List)
    //       .map((possessionMap) => IPossession.fromJson(possessionMap))
    //       .toList();
    // } else {
    //   possessionList = [];
    // }

    return ITaxPayer(
        id: json.containsKey('id') ? json['id'] : '-',
        type: json.containsKey('type') ? json['type'] : '-',
        personId: json.containsKey('personId') ? json['personId'] : '-',
        fiscalNumber:
            json.containsKey('fiscalNumber') && json['fiscalNumber'] != null
                ? json['fiscalNumber']
                : '-',
        // person: json.containsKey('person') && json['person'] != null
        //     ? IPerson.fromJSON(json['person'])
        //     : IPerson.empty(),
        taxAccountId:
            json.containsKey('taxAccountId') ? json['taxAccountId'] : '-',
        userId: json.containsKey('userId') ? json['userId'] : '-',
        user: json.containsKey('user')
            ? IUser.fromJson(json['user'])
            : IUser.empty(),
        // corporation: corporationList,
        // possessions: possessionList,
        // operations: operationList,
        // transaction: transactionsList,
        // sectors: sectorsList,
        createdAt: json.containsKey('createdAt')
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        createBy: json.containsKey('createBy') ? json['createBy'] : '',
        meta: json.containsKey('meta') ? json['meta'] : {},
        updatedAt: json.containsKey('updatedAt')
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedBy: json.containsKey('updatedBy') ? json['updatedBy'] : '',
        description:
            json.containsKey('description') ? json['description'] : '-');
  }

  factory ITaxPayer.fromData(
    Map<String, dynamic> json,
  ) {
    return ITaxPayer(
        id: json.containsKey('id') ? json['id'] : '-',
        type: json.containsKey('type') ? json['type'] : '',
        personId: json.containsKey('personId') ? json['personId'] : '',
        fiscalNumber:
            json.containsKey('fiscalNumber') && json['fiscalNumber'] != null
                ? json['fiscalNumber']
                : '',
        // person: json.containsKey('person') && json['person'] != null
        //     ? json['person']
        //     : '-',
        taxAccountId: json.containsKey('taxAccountId')
            ? json['taxAccountId'] as String
            : "",
        userId: json.containsKey('userId') ? json['userId'] : '',
        user: json.containsKey('user')
            ? IUser.fromJson(json['user'])
            : IUser.empty(),
        // corporation: json.containsKey('corporation') && json['corporation'] != null
        //     ? List<ICorporation>.from(
        //         json['corporation'].map((corp) => ICorporation.fromJson(corp)))
        //     : [],
        // possessions: json.containsKey('possessions') && json['possessions'] != null
        //     ? List<IPossession>.from(
        //         json['possessions'].map((poss) => IPossession.fromJson(poss)))
        //     : [],
        // operations: json.containsKey('operations') && json['operations'] != null
        //     ? List<IOperation>.from(
        //         json['operations'].map((op) => IOperation.fromJson(op)))
        //     : [],
        // transaction: json.containsKey('transactions') && json['transactions'] != null
        //     ? List<ITransaction>.from(json['transactions']
        //         .map((trans) => ITransaction.fromJson(trans)))
        //     : [],
        // sectors: json.containsKey('sectors') && json['sectors'] != null
        //     ? List<ISectors>.from(json['sectors'].map((sector) => ISectors.fromJson(sector)))
        //     : [],
        createdAt: json.containsKey('createdAt')
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        createBy: json.containsKey('createBy') ? json['createBy'] : '',
        meta: json.containsKey('meta') ? json['meta'] : {},
        updatedAt: json.containsKey('updatedAt')
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedBy: json.containsKey('updatedBy') ? json['updatedBy'] : '',
        description:
            json.containsKey('description') ? json['description'] : '-');
  }

  @override
  String toString() {
    return '''
        ITaxPayer(
          id: $id,
          type: $type,
          personId: $personId,
          taxAccountId: $taxAccountId,
          userId: $userId,
          description : $description
          User: $user,
          createdAt: $createdAt,
          createBy: $createBy,
          updatedAt: $updatedAt,
          updatedBy: $updatedBy,
          meta: $meta,

        )
    ''';
  }

  // Object? toJson() {}

  static empty() {
    return ITaxPayer(
      id: '-',
      type: '-',
      personId: '-',
      fiscalNumber: '-',
      // person: IPerson.empty(),
      taxAccountId: '-',
      userId: '-',
      user: IUser.empty(),
      // corporation: [],
      // operations: List<IOperation>.empty(),
      // possessions: [],
      // transaction: List<ITransaction>.empty(),
      // sectors: [],
      createdAt: DateTime.now(),
      createBy: '-',
      meta: {},
      updatedAt: DateTime.now(),
      updatedBy: '',
      description: '-',
    );
  }
}
