class DutyStationModel {

  final String id;
  final String name;

  DutyStationModel({
    required this.id,
    required this.name
  });

  factory DutyStationModel.fromJson(Map<String, dynamic> json){
    return DutyStationModel(
      id: json['_id'],
      name: json['name']
    );
  }
}