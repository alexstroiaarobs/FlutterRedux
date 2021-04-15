import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:todo_redux/model/Todo.dart';
import 'package:todo_redux/redux/actions/actions.dart';
import 'package:todo_redux/redux/app_state.dart';

class ToDoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ViewModel>(
    converter: (Store<AppState> store) => ViewModel.create(store),
    builder: (BuildContext context, ViewModel viewModel) => Scaffold(
      appBar: AppBar(
        title: Text(viewModel.pageTitle),
      ),
      body: ListView(children: viewModel.items.map((_ItemViewModel item) => _createWidget(item)).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.newItemAction,
        tooltip: viewModel.newItemToolTip,
        child: Icon(viewModel.newItemIcon),
      ),
    ),
  );

  Widget _createWidget(_ItemViewModel item) {
    if (item is _EmptyItemViewModel) {
      return _createEmptyItemWidget(item);
    } else {
      return _createToDoItemWidget(item);
    }
  }

  Widget _createEmptyItemWidget(_EmptyItemViewModel item) => Column(
    children: [
      TextField(
        onSubmitted: item.onCreateItem,
        autofocus: true,
        decoration: InputDecoration(
          hintText: item.createItemToolTip,
        ),
      )
    ],
  );

  Widget _createToDoItemWidget(_ToDoItemViewModel item) => Row(
    children: [
      Text(item.title),
      FlatButton(
        onPressed: item.onDeleteItem,
        child: Icon(
          item.deleteItemIcon,
          semanticLabel: item.deleteItemToolTip,
        ),
      )
    ],
  );
}

class ViewModel {
  final String pageTitle;
  final List<_ItemViewModel> items;
  final VoidCallback newItemAction;
  final String newItemToolTip;
  final IconData newItemIcon;

  ViewModel(this.pageTitle, this.items, this.newItemAction,this.newItemToolTip, this.newItemIcon);

  factory ViewModel.create(Store<AppState> store) {
    print("Creating store");
    List<_ItemViewModel> items = store.state.todos
        .map((ToDoItem item) => _ToDoItemViewModel(item.title, () {
      store.dispatch(RemoveItemAction(item));
      store.dispatch(SaveListAction());
    }, 'Delete', Icons.delete) as _ItemViewModel)
        .toList();

    if (store.state.listState == ListState.listWithNewItem) {
      print("List is a list with new item");
      items.add(_EmptyItemViewModel('Type the next task here', (String title) {
        print("Title is $title");
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(ToDoItem(title)));
        store.dispatch(SaveListAction());
      }, 'Add'));
    }

    return ViewModel('To Do', items, () => {store.dispatch(DisplayListWithNewItemAction())}, 'Add new to-do item', Icons.add);
  }
}

abstract class _ItemViewModel {}

@immutable
class _EmptyItemViewModel extends _ItemViewModel {
  final String hint;
  final Function(String) onCreateItem;
  final String createItemToolTip;

  _EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);
}

@immutable
class _ToDoItemViewModel extends _ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemToolTip;
  final IconData deleteItemIcon;

  _ToDoItemViewModel(this.title, this.onDeleteItem, this.deleteItemToolTip, this.deleteItemIcon);
}