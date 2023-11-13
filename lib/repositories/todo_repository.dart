import 'dart:convert';

import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/services/api_caller.dart';

class ToDoRepository {
  Future<List<ToDo>> getToDos() async {
    try {
      var result = await ApiCaller().get('todos');
      List list = jsonDecode(result);
      List<ToDo> todoList =
          list.map<ToDo>((item) => ToDo.fromJson(item)).toList();
      return todoList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToDo({
    required String id,
    required String todoText,
    required String todoDetail,
    required bool isDone,
  }) async {
    try {
      await ApiCaller().post('todos', params: {
        'id': id,
        'todoText': todoText,
        'todoDetail': todoDetail,
        'isDone': isDone,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateToDo({
    required String id,
    required String todoText,
    required String todoDetail,
    required bool isDone,
  }) async {
    try {
      await ApiCaller().put('todos', id: id, params: {
        'todoText': todoText,
        'todoDetail': todoDetail,
        'isDone': isDone
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteToDo({required String id}) async {
    try {
      await ApiCaller().delete('todos', id: id);
    } catch (e) {
      rethrow;
    }
  }
}
