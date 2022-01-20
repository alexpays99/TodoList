import 'package:flutter/material.dart';
import 'package:flutter_inherited_widget/boxes.dart';
import 'package:flutter_inherited_widget/model/todo_model.dart';
import 'package:flutter_inherited_widget/screens/add_todo_screen.dart';
import 'package:flutter_inherited_widget/screens/todo_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void  main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(HiveTodoBox.todo);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
        ),
        home: TodoListScreenWidget(title: 'Todo List',), 
      );
  }
}
