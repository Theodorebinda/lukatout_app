// To parse this JSON data, do
//     final iFormulary = iFormularyFromJson(jsonString);

import 'dart:convert';

List<IFormulary> iFormularyFromJson(String str) =>
    List<IFormulary>.from(json.decode(str).map((x) => IFormulary.fromJson(x)));

String iFormularyToJson(List<IFormulary> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IFormulary {
  String type;
  String property;
  String verbose;
  Constraints constraints;
  List<String>? fields;
  String? modelPath;
  List<String>? displayColumns;

  IFormulary({
    required this.type,
    required this.property,
    required this.verbose,
    required this.constraints,
    this.fields,
    this.modelPath,
    this.displayColumns,
  });

  factory IFormulary.fromJson(Map<String, dynamic> json) => IFormulary(
        type: json["type"],
        property: json["property"],
        verbose: json["verbose"],
        constraints: Constraints.fromJson(json["constraints"]),
        fields: json["fields"] == null
            ? []
            : List<String>.from(json["fields"]!.map((x) => x)),
        modelPath: json["modelPath"],
        displayColumns: json["displayColumns"] == null
            ? []
            : List<String>.from(json["displayColumns"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "property": property,
        "verbose": verbose,
        "constraints": constraints.toJson(),
        "fields":
            fields == null ? [] : List<dynamic>.from(fields!.map((x) => x)),
        "modelPath": modelPath,
        "displayColumns": displayColumns == null
            ? []
            : List<dynamic>.from(displayColumns!.map((x) => x)),
      };
}

class Constraints {
  bool? isString;
  bool isList;
  bool isMultipleChoice;
  bool? isOptional;
  bool? isUrl;
  int? maxLength;
  bool? isEnum;
  bool? isUuid;
  bool? isEmail;

  Constraints({
    this.isString,
    required this.isList,
    required this.isMultipleChoice,
    this.isOptional,
    this.isUrl,
    this.maxLength,
    this.isEnum,
    this.isUuid,
    this.isEmail,
  });

  factory Constraints.fromJson(Map<String, dynamic> json) => Constraints(
        isString: json["isString"],
        isList: json["isList"],
        isMultipleChoice: json["isMultipleChoice"],
        isOptional: json["isOptional"],
        isUrl: json["isUrl"],
        maxLength: json["maxLength"],
        isEnum: json["isEnum"],
        isUuid: json["isUuid"],
        isEmail: json["isEmail"],
      );

  Map<String, dynamic> toJson() => {
        "isString": isString,
        "isList": isList,
        "isMultipleChoice": isMultipleChoice,
        "isOptional": isOptional,
        "isUrl": isUrl,
        "maxLength": maxLength,
        "isEnum": isEnum,
        "isUuid": isUuid,
        "isEmail": isEmail,
      };
}
