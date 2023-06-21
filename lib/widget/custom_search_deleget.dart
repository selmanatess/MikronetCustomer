import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:responsive_sizer/responsive_sizer.dart";
import "package:todoapp/data/local_storage.dart";
import "package:todoapp/main.dart";
import "package:todoapp/models/task_model.dart";
import "package:todoapp/widget/task_list_item.dart";

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> alltask;

  CustomSearchDelegate({required this.alltask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.arrow_back_ios),
      onTap: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = alltask
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var oankieleman = filteredList[index];
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
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: oankieleman);
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
              "Aradığınız Sonuç Malesef Bulunamadı",
              style: GoogleFonts.gentiumBookPlus(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container(child: Text("selman"));
  }
}
