class IEntity {
  final String id;
  final String name;
  final String description;
  final String label;
  final String namedEntityId;
  final List<IEntity> childrens;
  final bool isActive;
  final int number;
  final int parentNumber;

  final DateTime createdAt;
  DateTime? updatedAt;
  dynamic updatedBy;
  final dynamic createBy;
  Object? meta;

  IEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.label,
    required this.namedEntityId,
    required this.number,
    required this.parentNumber,
    required this.isActive,
    required this.createdAt,
    required this.createBy,
    required this.childrens,
    this.updatedAt,
    this.updatedBy,
    this.meta,
  });

  factory IEntity.fromJson(Map<String, dynamic> json) {
    return IEntity(
      id: json['id'] ?? '-',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      label: json['label'] ?? '',
      namedEntityId: json['namedEntityId'] ?? '',
      number: json['number'] ?? 0, // Provide a default value
      parentNumber: json['parentNumber'] ?? 0, // Provide a default value
      isActive: json['isActive'] ?? false, // Provide a default value
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      childrens: json.containsKey('childrens') && json['childrens'] != null
          ? List<IEntity>.from(
              json['childrens'].map((x) => IEntity.fromJson(x)))
          : [],
      createBy: json['createBy'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']) // Correct key
          : null,
      updatedBy: json['updatedBy'],
      meta: json['meta'],
    );
  }

  factory IEntity.empty() {
    return IEntity(
      id: '',
      name: '',
      description: '',
      label: '',
      namedEntityId: '',
      childrens: [],
      number: 0,
      parentNumber: 0,
      isActive: false,
      createdAt: DateTime.now(),
      createBy: '',
      updatedAt: null,
      updatedBy: null,
      meta: null,
    );
  }
  @override
  String toString() {
    return '''
      IEntity(
        id: $id,
        name: $name,
        description: $description,
        label: $label,
        namedEntityId: $namedEntityId,
        number: $number,
        parentNumber: $parentNumber,
        childrens: $childrens,
        isActive: $isActive,
        createdAt: $createdAt,
        createBy: $createBy,
        updatedAt: $updatedAt,
        updatedBy: $updatedBy,
        meta: $meta,
      )
    ''';
  }
}
