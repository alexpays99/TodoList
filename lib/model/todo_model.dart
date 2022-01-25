import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  TodoModel({ required this.title, required this.description });
  

}

class TodoModelProvider extends InheritedWidget {
  final TodoModel model;
  TodoModelProvider({Key? key, required this.child, required this.model}) : super(key: key, child: child);

  final Widget child;

  static TodoModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoModelProvider>();
  }

  @override
  bool updateShouldNotify(TodoModelProvider oldWidget) {
    return  oldWidget.model != model;
  }
}
