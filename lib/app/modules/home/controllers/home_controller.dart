import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../amplifyconfiguration.dart';
import '../../../../models/ModelProvider.dart';

class HomeController extends GetxController {
  bool _amplifyConfigured = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var todoList = <Todos>[].obs;

  TextEditingController taskController = TextEditingController();

  @override
  void onInit() {
    _amplifyConfigured?null : _configureAmplify();
    super.onInit();
  }

  void _configureAmplify() async {
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));

    await Amplify.configure(amplifyconfig);
    await Amplify.addPlugin(AmplifyAPI());
    try {
      _amplifyConfigured = true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> readTasksData() async {
    try {
      todoList = RxList(await Amplify.DataStore.query(Todos.classType));
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addNewTask(String? task) async {
    try {
      Todos _newTodo = Todos(tasks: task!, isDone: false);

      await Amplify.DataStore.save(_newTodo);
      readTasksData();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateTask(String? task) async {
    try {
      Todos _newTodo = Todos(tasks: task!, isDone: false);

      await Amplify.DataStore.save(_newTodo);
      readTasksData();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updatePost(String? id, bool? isDone) async {
    try {
      Todos _oldTodo = (await Amplify.DataStore.query(Todos.classType,
          where: Todos.ID.eq(id)))[0];

      Todos _newTodo =
          _oldTodo.copyWith(id: id!, tasks: _oldTodo.tasks, isDone: isDone!);

      await Amplify.DataStore.save(_newTodo);
      readTasksData();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  Future<void> deleteTodo(String? id) async {
    (await Amplify.DataStore.query(Todos.classType, where: Todos.ID.eq(id)))
        .forEach((element) async {
      try {
        await Amplify.DataStore.delete(element);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    readTasksData();
  }
}
