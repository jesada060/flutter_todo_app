import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/colors.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/home/add_todo.dart';
import 'package:flutter_todo_app/screens/home/update_todo.dart';
import 'package:flutter_todo_app/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo>? todosList;
  List<ToDo>? _foundToDo;
  var _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getToDos();
  }

  getToDos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    try {
      var todos = await ToDoRepository().getToDos();
      debugPrint('Number of todos: ${todos.length}');

      setState(() {
        todosList = todos;
        _foundToDo = todosList;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    buildLoadingOverlay() => Container(
          color: Colors.black.withOpacity(0.2),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );

    buildError() => Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage ?? '',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(onPressed: getToDos, child: const Text('Retry'))
              ],
            ),
          ),
        );

    buildList() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 20),
                      child: const Text(
                        'All ToDos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    for (ToDo todo in _foundToDo!)
                      ToDoItem(
                        todo: todo,
                        onToDoChanged: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                        onToDoUpdate: _updateToDoItem,
                      ),
                  ],
                ),
              )
            ],
          ),
        );

    buildAddBox() => Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _addToDoItem();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          if (todosList?.isNotEmpty ?? false) buildList(),
          if (_errorMessage != null) buildError(),
          if (_isLoading) buildLoadingOverlay(),
          buildAddBox(),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      ToDoRepository().updateToDo(
        id: todo.id,
        todoText: todo.todoText,
        todoDetail: todo.todoDetail,
        isDone: !todo.isDone,
      );
      getToDos();
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      ToDoRepository().deleteToDo(id: id);
      getToDos();
    });
  }

  void _runFilter(String enteredKeyboard) {
    List<ToDo> results = [];
    if (enteredKeyboard.isEmpty) {
      results = todosList!;
    } else {
      results = todosList!
          .where((item) => item.todoText
              .toLowerCase()
              .contains(enteredKeyboard.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _addToDoItem() {
    Navigator.pushNamed(context, AddToDo.routeName).whenComplete(() {
      getToDos();
    });
  }

  void _updateToDoItem(ToDo todo) {
    Navigator.pushNamed(
      context,
      UpdateToDo.routeName,
      arguments: const UpdateToDo().setToDo(todo),
    ).whenComplete(() {
      getToDos();
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/catCry.jpg'),
            ),
          )
        ],
      ),
    );
  }
}
