import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:todo/feature/toast.dart';
import 'package:todo/model/model.dart';

class APIService {
  final baseUrl = "http://127.0.0.1:1000/tasks";

  Future<List<dynamic>?> fetchData(BuildContext context) async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        if (res.body.contains("message")) {
          // print("No available tasks");
        } else {
          List<dynamic> data = jsonDecode(res.body.toString());
          // print("The available tasks are: $data");
          return data;
        }
      }
    } catch (e) {
      // print(e.toString());
      // print("Server is not connected");
      showCustomToast(context, "Server is not Connected", "", "", "");
    }
  }

  Future<void> postData(BuildContext context, String data) async {
    try {
      DataModel postModel = new DataModel(task_name: data);
      final res = await http.post(Uri.parse(baseUrl), body: postModel.toJson());
      if (res.statusCode == 201) {
        // print("Task Created => ${res.body}");
        Map<dynamic, dynamic> result = jsonDecode(res.body.toString());
        showCustomToast(
            context, "Task Created => ", result['task_name'], "", "");
      } else if (res.statusCode == 409) {
        // print("Given task is already added => ${res.body}");
        showCustomToast(context, "Given task ", data, " is already added", "");
      }
    } catch (e) {
      // print(e.toString());
      // print("Server is not Connected");
      showCustomToast(context, "Server is not Connected", "", "", "");
    }
  }

  Future<void> updateData(
      BuildContext context, String id, String data, String oldData) async {
    try {
      DataModel updateModel = new DataModel(task_name: data);
      var url = baseUrl + "/" + id;
      final res = await http.put(Uri.parse(url), body: updateModel.toJson());
      // print(res.statusCode);
      if (res.statusCode == 200) {
        Map<dynamic, dynamic> result = jsonDecode(res.body.toString());
        // print("Task is updated as" + res.body);
        showCustomToast(context, "Task is updated from ", oldData, " to ",
            result['task_name']);
      } else if (res.statusCode == 409) {
        // print("Given task is already added => ${res.body}");
        showCustomToast(
            context, "Entered task ", data, " is already added", "");
      }
    } catch (e) {
      // print(e.toString());
      // print("Server is not Connected");
      showCustomToast(context, "Server is not Connected", "", "", "");
    }
  }

  Future<void> deleteData(BuildContext context, String id, String data) async {
    try {
      var url = baseUrl + "/" + id;
      final res = await http.delete(Uri.parse(url));
      // print(res.body);
      if (res.statusCode == 200) {
        Map<dynamic, dynamic> result = jsonDecode(res.body.toString());
        // print("The task * ${res.body} * is deleted");
        showCustomToast(
            context, "The task ", result['task_name'], " is deleted", "");
      } else if (res.statusCode == 404) {
        // print("Given task is Not found => ${res.body}");
        showCustomToast(context, "Given task ", data, " is not found", "");
      }
    } catch (e) {
      // print(e.toString());
      // print("Server is not Connected");
      showCustomToast(context, "Server is not Connected", "", "", "");
    }
  }
}
