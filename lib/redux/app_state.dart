import 'package:todo_redux/model/Todo.dart';

class AppState {
  final List<ToDoItem> todos;
  final ListState listState;

  AppState(this.todos, this.listState);

  factory AppState.initial() => AppState(List.unmodifiable([]), ListState.listOnly);
}

enum ListState {
  listOnly, listWithNewItem
}