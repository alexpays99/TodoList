import 'package:flutter/material.dart';
import 'package:flutter_inherited_widget/boxes.dart';
import 'package:flutter_inherited_widget/model/todo_model.dart';
import 'package:hive/hive.dart';

class AddTodoScreenWidget extends StatefulWidget {
  AddTodoScreenWidget({Key? key}) : super(key: key);

  @override
  _AddTodoScreenWidgetState createState() => _AddTodoScreenWidgetState();
}

class _AddTodoScreenWidgetState extends State<AddTodoScreenWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String title;
  late String desctiption;

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

  void _onFormSubmit() {
    Box<TodoModel> todoBox = Hive.box<TodoModel>(HiveTodoBox.todo);
    todoBox.add(TodoModel(title: title, description: desctiption));
    Navigator.of(context).pop();
    print(todoBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                      )
                  ),
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
                SizedBox(height: 10,),
                TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                      )
                  ),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        onPressed: () {
          validate();
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
