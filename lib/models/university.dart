class IOption {
  final String? name;

  IOption({this.name});

  factory IOption.fromJson(String json) {
    return IOption(name: json);
  }

  String toJson() {
    return name ?? '-';
  }

  factory IOption.empty() {
    return IOption(
      name: '',
    );
  }
}

class IFaculty {
  final String name;
  final List<IOption> options;

  IFaculty({required this.name, required this.options});

  factory IFaculty.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<IOption> optionList =
        optionsFromJson.map((option) => IOption.fromJson(option)).toList();

    return IFaculty(
      name: json['name'],
      options: optionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }

  factory IFaculty.empty() {
    return IFaculty(
      name: '',
      options: [],
    );
  }
}

class IUniversity {
  final String? name;
  final String? image;
  final List<IFaculty>? faculties;

  IUniversity({this.name, this.image, this.faculties});

  factory IUniversity.fromJson(Map<String, dynamic> json) {
    var facultiesFromJson = json['faculties'] as List;
    List<IFaculty> facultyList =
        facultiesFromJson.map((faculty) => IFaculty.fromJson(faculty)).toList();

    return IUniversity(
      name: json['name'] ?? '-',
      image: json['image'] ?? '-',
      faculties: facultyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'faculties': faculties!.map((faculty) => faculty.toJson()).toList(),
    };
  }

  factory IUniversity.empty() {
    return IUniversity(
      name: '',
      image: '',
      faculties: [],
    );
  }
}
