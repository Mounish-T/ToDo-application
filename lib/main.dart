import 'package:flutter/material.dart';
import 'package:todo/feature/toast.dart';

import 'api-handler/api-service.dart';
// import 'package:todo/api-handler/fetch-api.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isStart = true;
  List<dynamic> data = [];
  final APIService api = APIService();
  bool isBottomSheet = false;
  bool isAddData = true;
  late String selectedId;
  late String selectedData;

  TextEditingController taskInput = new TextEditingController();

  void loadData() async {
    List<dynamic>? fetchedData = await api.fetchData(context);
    setState(() {
      data = fetchedData ?? [];
      if (isStart && data.isNotEmpty) {
        showCustomToast(
            context, "Server is connected to our application", "", "", "");
        isStart = false;
      }
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ToDo",
          style: TextStyle(
              fontSize: 25, color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Count: ${data.length}",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isBottomSheet = false;
          });
        },
        // child: SingleChildScrollView(
        child: data.isEmpty
            ? Center(
                child: Text(
              "Currently, you have no pending tasks!!!",
              style: TextStyle(fontSize: 17),
            ))
            : Padding(
                padding: const EdgeInsets.only(top: 8, left: 5),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // onTap: () {},
                        title: Text(data[index]['task_name']),
                        trailing: Wrap(
                          spacing: 25,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isBottomSheet = true;
                                  taskInput.text = data[index]['task_name'];
                                  isAddData = false;
                                  selectedId = data[index]['_id'];
                                  selectedData = data[index]['task_name'];
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: const Color.fromARGB(255, 237, 110, 6),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: RichText(
                                          text: TextSpan(
                                              text:
                                                  "Do you want to delete the task  ",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                              children: [
                                            TextSpan(
                                                text: data[index]['task_name'],
                                                style: TextStyle(
                                                    color: Colors.tealAccent,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await api.deleteData(
                                                  context,
                                                  data[index]['_id'],
                                                  data[index]['task_name']);
                                              loadData();
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: const Color.fromARGB(255, 44, 159, 194),
                              ),
                            )
                          ],
                        ));
                  },
                ),
              ),
        // ),
      ),
      floatingActionButton: !isBottomSheet
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isBottomSheet = true;
                  taskInput.text = "";
                  isAddData = true;
                });
              },
              child: Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomSheet: isBottomSheet
          ? BottomSheet(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 130,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            autofocus: true,
                            onSubmitted: (value) async {
                              if (taskInput.text.trim() == "")
                                showCustomToast(context,
                                    "Task can't be Empty!!!", "", "", "");
                              else {
                                isAddData
                                    ? await api.postData(context, value)
                                    : await api.updateData(context, selectedId,
                                        value, selectedData);
                              }
                              setState(() {
                                isBottomSheet = false;
                                isAddData = true;
                                taskInput.text = "";
                                loadData();
                              });
                            },
                            controller: taskInput,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusColor: Colors.amber),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (taskInput.text.trim() == "")
                                  showCustomToast(context,
                                      "Task can't be Empty!!!", "", "", "");
                                else {
                                  isAddData
                                      ? await api.postData(
                                          context, taskInput.text)
                                      : await api.updateData(
                                          context,
                                          selectedId,
                                          taskInput.text,
                                          selectedData);
                                }
                                setState(() {
                                  isBottomSheet = false;
                                  isAddData = true;
                                  taskInput.text = "";
                                  loadData();
                                });
                              },
                              child: Text(
                                isAddData ? "Add" : "Update",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isBottomSheet = false;
                                  isAddData = true;
                                  taskInput.text = "";
                                });
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onClosing: () {
                // print("Closing");
              },
            )
          : null,
    );
  }
}
