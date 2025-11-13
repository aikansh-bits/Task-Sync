import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_sync/models/tasks.dart';

class TaskService {
  // CREATE
  Future<bool> addTask(String title, String description) async {
    final user = await ParseUser.currentUser() as ParseUser?;
    final task = Task()
      ..title = title
      ..description = description
      ..set('userEmail', user?.get<String>('email'));

    final response = await task.save();
    return response.success;
  }

  // UPDATE
  Future<bool> updateTask(
    String objectId,
    String newTitle,
    String newDesc,
  ) async {
    final task = Task()
      ..objectId = objectId
      ..title = newTitle
      ..description = newDesc;
    final response = await task.save();
    return response.success;
  }

  // DELETE
  Future<bool> deleteTask(String objectId) async {
    final task = Task()..objectId = objectId;
    final response = await task.delete();
    return response.success;
  }

  final LiveQuery _liveQuery = LiveQuery();
  Subscription? _subscription;

  /// Fetch all tasks for the current user once
  Future<List<Task>> getTasks() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    final query = QueryBuilder(Task())
      ..whereEqualTo('userEmail', user?.get<String>('email'));
    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!.cast<Task>();
    } else {
      return [];
    }
  }

  /// Subscribe for real-time updates (create, update, delete)
  Future<void> subscribeToUserTasks({required Function onTaskChanged}) async {
    final user = await ParseUser.currentUser() as ParseUser?;
    final query = QueryBuilder(Task())
      ..whereEqualTo('userEmail', user?.get<String>('email'));

    _subscription = await _liveQuery.client.subscribe(query);

    _subscription!.on(LiveQueryEvent.create, (task) => onTaskChanged());
    _subscription!.on(LiveQueryEvent.update, (task) => onTaskChanged());
    _subscription!.on(LiveQueryEvent.delete, (task) => onTaskChanged());
  }

  /// Cancel the live query when leaving the page
  Future<void> unsubscribe() async {
    if (_subscription != null) {
      _liveQuery.client.unSubscribe(_subscription!);
      _subscription = null;
    }
  }
}
