import 'package:hive/hive.dart';
import 'package:todoapp/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskbox;
  HiveLocalStorage() {
    _taskbox = Hive.box<Task>("todoapp");
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskbox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await _taskbox.delete(task.id);
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _alltask = <Task>[];
    _alltask = _taskbox.values.toList();
    if (_alltask.isNotEmpty) {
      _alltask.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
    }
    return _alltask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskbox.containsKey(id)) {
      return _taskbox.get(id);
    } else
      return null;
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
