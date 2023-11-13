import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';

import '../../constants/colors.dart';

String? detail;
bool isChangeDetail = false;
ToDo? toDo;

class AddToDo extends StatefulWidget {
  static const routeName = 'add_detail';

  const AddToDo({super.key});

  String getDetail() {
    return detail!;
  }

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  var _isLoading = false;
  String? _errorMessage;

  final _todoController = TextEditingController();
  final _todoDetailController = TextEditingController();

  validateToDoForm() {
    return _todoController.text.isNotEmpty;
  }

  validateDetailForm() {
    return _todoDetailController.text.isNotEmpty;
  }

  saveTodo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    try {
      var todo = _todoController.text;
      var todoDetail = validateDetailForm() ? _todoDetailController.text : '';

      await ToDoRepository().addToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todo,
        todoDetail: todoDetail,
        isDone: false,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        debugPrint(_errorMessage);
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
          child: const Center(child: CircularProgressIndicator()),
        );

    handleClickSave() {
      if (validateToDoForm()) {
        saveTodo();
      }
    }

    buildForm() => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 20, bottom: 0, right: 25, left: 25),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _todoController,
                decoration: const InputDecoration(
                  hintText: 'Add a new todo item',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.only(bottom: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _todoDetailController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: 'Your ToDo Detail',
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: handleClickSave,
              child: const Text('SAVE'),
            ),
          ],
        );

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: tdBGColor,
      body: Stack(
        children: [
          buildForm(),
          if (_isLoading) buildLoadingOverlay(),
        ],
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
          Container(),
          const Text('Add ToDo Detail'),
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
