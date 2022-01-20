import 'package:flutter/material.dart';
import 'package:flutter_inherited_widget/boxes.dart';
import 'package:flutter_inherited_widget/model/todo_model.dart';
import 'package:flutter_inherited_widget/screens/add_todo_screen.dart';
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
  late String title;
  late String desctiption;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

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
                         borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
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
             SizedBox(height: 5,),
             TextFormField(
                   autofocus: false,
                   decoration: InputDecoration(
                       labelText: 'Description',
                       prefixIcon: Icon(Icons.description),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
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
          if(box.values.isEmpty) {
            return Center(child: Text('Todo list is empry'),);
          }
          return ListView.builder(
          itemCount: box.values.length,
          itemBuilder: (BuildContext context, int index) {
            TodoModel? res = box.getAt(index);
            return InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => TodoDescription()));
              },
              child: Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Delete', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  key: UniqueKey(), 
                  onDismissed: (direction) {
                    res!.delete();
                  },
                  child: ListTile(
                    title: Text(res!.title),
                    subtitle: Text(res.description),
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
        child:  Icon(Icons.add),
        onPressed: () {
          _displayDialog();//Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoScreenWidget()));
        },
      ),
    );
  }
}