import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        builder: (logic) {
          return ListView.builder(
            itemCount: controller.todoList.length,
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey<String>(controller.todoList[index].id),
              onDismissed: (direction) =>
                  controller.deleteTodo(controller.todoList[index].id),
              background: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  )
                ],
              ),
              child: controller.todoList.isNotEmpty
                  ? Card(
                      child: ListTile(
                        title: Text(controller.todoList[index].tasks),
                        trailing: Checkbox(
                          onChanged: (value) => controller.updatePost(
                              controller.todoList[index].id, value),
                          value: controller.todoList[index].isDone,
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                      'No tasks!',
                    )),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.taskController,
                        decoration: const InputDecoration(
                          hintText: 'Your next task',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'You should write your task before you save it';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            controller
                                .addNewTask(controller.taskController.text);
                            controller.readTasksData();
                            controller.taskController.clear();
                            Get.back();
                          }
                        },
                        child: const Text('Add task'),
                      )
                    ],
                  )));
        },
      ),
    );
  }
}
