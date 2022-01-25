import 'package:flutter/material.dart';
import 'package:flutter_inherited_widget/boxes.dart';
import 'package:flutter_inherited_widget/model/todo_model.dart';
import 'package:flutter_inherited_widget/screens/add_todo_screen.dart';
import 'package:flutter_inherited_widget/screens/todo_edit_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoListScreenWidget extends StatefulWidget {
  final String title;

  TodoListScreenWidget({Key? key, required this.title}) : super(key: key);

  @override
  _TodoScreenWidgetState createState() => _TodoScreenWidgetState();
}

class _TodoScreenWidgetState extends State<TodoListScreenWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String title; // название задачи
  late String desctiption; // описание задачи
  final bool _isDone = false;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  //валидация формы
  validate() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'New task was added.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black26,
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Form not validated.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black26,
        ),
      );
    }
  }

  // добавление в бокс заполненые поля формы и возврат на предыдущий скрин
  void _onFormSubmit() {
    Box<TodoModel> todoBox = Hive.box<TodoModel>(HiveTodoBox.todo);
    todoBox.add(TodoModel(title: title, description: desctiption));
    Navigator.of(context).pop();
    print(todoBox);
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.blue.shade300, width: 1),
                      )),
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().length == 0) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.blue.shade300, width: 1),
                      )),
                  onChanged: (value) {
                    desctiption = value;
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().length == 0) {
                      return "Required";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                validate();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoModel>(HiveTodoBox.todo).listenable(),
        builder: (context, Box<TodoModel> box, _) {
          //проверка на наличие записей в боксе
          if (box.values.isEmpty) {
            return Center(
              child: Text('Todo list is empry'),
            );
          }
          //список задач
          return ListView.builder(
            itemCount: box.values.length, //длина записей в боксе
            itemBuilder: (BuildContext context, int index) {
              TodoModel? res = box.getAt(index); //получение записи по индексу
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TodoEditScreen())); //редирект на страницу описания
                },
                child: Slidable(
                  key: UniqueKey(),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      SlidableAction(
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        onPressed: (direction) {
                          res!.delete(); //удаление задачи
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Color(0xEFEE6A49),
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        onPressed: (BuildContext context) {
                          setState(() {
                            _isDone != _isDone;
                          });
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      res!.title,
                      style: TextStyle(decoration: _isDone ? TextDecoration.lineThrough: null), 
                    ),
                    subtitle: Text(
                      res.description,
                      style: TextStyle(decoration: _isDone ? TextDecoration.lineThrough: null),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoEditScreen()));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
        onPressed: () {
          _displayDialog(); //Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoScreenWidget()));
        },
      ),
    );
  }
}
