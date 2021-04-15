import 'package:todo_redux/model/Todo.dart';

class RemoveItemAction {
  final ToDoItem item;

  RemoveItemAction(this.item);
}

class AddItemAction {
  final ToDoItem item;

  AddItemAction(this.item);
}

class DisplayListOnlyAction {}

class DisplayListWithNewItemAction {}

class SaveListAction {}