import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task extends ParseObject implements ParseCloneable {
  Task() : super('Task');
  Task.clone() : this();

  @override
  clone(Map<String, dynamic> map) => Task.clone()..fromJson(map);

  String get title => get<String>('title') ?? '';
  set title(String value) => set<String>('title', value);

  String get description => get<String>('description') ?? '';
  set description(String value) => set<String>('description', value);
}
