import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widget/custom_search_deleget.dart';
import 'package:todoapp/widget/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _alltask;
  late LocalStorage _localStorage;
  @override
  void initState() {
    _alltask = [];
    super.initState();
    _localStorage = locator<LocalStorage>();

    _getallTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showaddtaskBottomSheet(context);
          },
          child: const Text(
            "Bugün Neler Yapıcaksın? ",
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showsearchPage(context);
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                showaddtaskBottomSheet(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _alltask.isNotEmpty
          ? ListView.builder(
              itemCount: _alltask.length,
              itemBuilder: (context, index) {
                var oankieleman = _alltask[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    height: 10.h,
                    width: 100.w,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Sil",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  key: Key(oankieleman.id),
                  onDismissed: (direction) async {
                    setState(() {
                      _alltask.removeAt(index);
                      _localStorage.deleteTask(task: oankieleman);
                    });
                  },
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        color: Colors.white,
                        child: TaskItem(
                          task: oankieleman,
                        )),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Hadi yeni görev ekleyelim",
                style: GoogleFonts.gentiumBookPlus(
                    fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          showaddtaskBottomSheet(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 75),
      ),
    );
  }

  void showaddtaskBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                  hintText: "Ne yapıcaksın", border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                DatePicker.showTimePicker(
                  context,
                  showSecondsColumn: false,
                  onConfirm: (time) {
                    var yenigorev = Task.create(name: value, createdAt: time);

                    setState(() {
                      _alltask.add(yenigorev);
                      _localStorage.addTask(task: yenigorev);
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _getallTaskFromDb() async {
    _alltask = await _localStorage.getAllTask();
    setState(() {});
  }

  void showsearchPage(BuildContext context) async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(alltask: _alltask));
    _getallTaskFromDb();
  }
}
