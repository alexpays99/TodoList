import 'package:flutter/material.dart';
import 'package:flutter_inherited_widget/boxes.dart';
import 'package:flutter_inherited_widget/model/todo_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoEditScreen extends StatefulWidget {
  TodoEditScreen({Key? key}) : super(key: key);

  @override
  _TodoEditScreenState createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {

  final model = TodoModel(title: '', description: '');
  @override
  Widget build(BuildContext context) {
    return TodoModelProvider(
      model: model,
      child: TodoEditBody()
    );
  }
}

class TodoEditBody extends StatefulWidget {
  TodoEditBody({Key? key}) : super(key: key);

  @override
  State<TodoEditBody> createState() => _TodoEditBodyState();
}

class _TodoEditBodyState extends State<TodoEditBody> {
  late String title;
  late String desctiption;

  @override
  Widget build(BuildContext context) {
    final TodoModel model = TodoModelProvider.of(context)!.model;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(model.title),
          subtitle: Text(model.description),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        onPressed: () {},
        child: Icon(Icons.done),
      ),
    );
  }
}
