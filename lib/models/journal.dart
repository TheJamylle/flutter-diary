import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId
  });

  Journal.empty({ required int id })
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        userId = id;

  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["createdAt"]),
        updatedAt = DateTime.parse(map["updatedAt"]),
        userId = map["userId"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "content": content,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString()
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
