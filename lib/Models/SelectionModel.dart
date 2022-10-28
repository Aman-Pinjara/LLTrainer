final SELECTIONTABLENAME = "selectiontable";

class SelectionModelDBFields {
  static const String llcase = "llcase"; //This is the ID
  static const String lltype = "lltype";
  static const String selectionType = "selectiontype"; //either 0 1 2 3
  static const String alg = "alg";
}

class SelectionModel {
  final String lltype;
  final String llcase;
  final int selectionType;
  final String? alg;

  const SelectionModel({
    required this.llcase,
    required this.lltype,
    required this.selectionType,
    this.alg,
  });

  Map<String, Object?> toJson() => {
        SelectionModelDBFields.llcase: llcase,
        SelectionModelDBFields.lltype: lltype,
        SelectionModelDBFields.selectionType: selectionType,
        SelectionModelDBFields.alg: alg,
      };

  static SelectionModel fromJson(json) {
    return SelectionModel(
      lltype: json[SelectionModelDBFields.lltype] as String,
      llcase: json[SelectionModelDBFields.llcase] as String,
      selectionType: json[SelectionModelDBFields.selectionType] as int,
      alg: json[SelectionModelDBFields.alg] as String?,
    );
  }
}
