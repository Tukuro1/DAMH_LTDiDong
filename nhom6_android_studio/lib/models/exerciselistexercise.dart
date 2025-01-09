class Exerciselistexercise {
  Exerciselistexercise({
    required this.exerciseListId,
    required this.exerciseId,
    required this.exerciseList,
    required this.exerciseDto,
  });

  final int? exerciseListId;
  final int? exerciseId;
  final dynamic exerciseList;
  final dynamic exerciseDto;

  factory Exerciselistexercise.fromJson(Map<String, dynamic> json){
    return Exerciselistexercise(
      exerciseListId: json["exerciseListId"],
      exerciseId: json["exerciseId"],
      exerciseList: json["exerciseList"],
      exerciseDto: json["exerciseDto"],
    );
  }

  Map<String, dynamic> toJson() => {
    "exerciseListId": exerciseListId,
    "exerciseId": exerciseId,
    "exerciseList": exerciseList,
    "exerciseDto": exerciseDto,
  };

}
