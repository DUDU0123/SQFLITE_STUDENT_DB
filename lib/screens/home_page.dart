import 'dart:typed_data';
import 'package:database_practice/data/db_functions.dart';
import 'package:database_practice/model/student_database_model.dart';
import 'package:database_practice/screens/add_student.dart';
import 'package:database_practice/screens/common_widgets/text_widget_common.dart';
import 'package:database_practice/screens/edit_studentprofile.dart';
import 'package:database_practice/screens/student_profile_page.dart';
import 'package:database_practice/services/db_servicer.dart';
import 'package:database_practice/utils/colors.dart';
import 'package:database_practice/utils/height_width.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<StudentDataBaseModel> _studentDataList = <StudentDataBaseModel>[];
  final _dbService = DbServicer();
  var searchValueController = TextEditingController();

  getAllStudentDetails() async {
    var students = await _dbService.getAllStudentsFromDB();
    _studentDataList = <StudentDataBaseModel>[];
    students.forEach((student) {
      setState(() {
        var studentModel = StudentDataBaseModel();
        studentModel.id = student['id'];
        studentModel.name = student['name'];
        studentModel.age = student['age'];
        studentModel.place = student['place'];
        studentModel.standard = student['standard'];

        try {
          Uint8List? imageBytes = student['profileimage'];

          if (imageBytes != null) {
            studentModel.profileimage = imageBytes;
          }
        } catch (e) {
          // Handle decoding error
          print('Error decoding profile image: $e');
        }

        _studentDataList.add(studentModel);
      });
    });
  }

  showSnackbarAfterDataFetch(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kBlack,
        duration: const Duration(
          seconds: 2,
        ),
        behavior: SnackBarBehavior.fixed,
        content: TextWidgetCommon(
          text: text,
          color: kWhite,
        ),
      ),
    );
  }

  void deleteAlertDialog(BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidgetCommon(
            text: "Delete",
            color: kBlack,
          ),
          content: TextWidgetCommon(
            text: "Do you want to delete the student?",
            color: kBlack,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: TextWidgetCommon(
                text: "Close",
                color: kBlack,
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await _dbService.deleteStudentData(userId);

                if (result != null) {
                  Navigator.pop(context);
                  getAllStudentDetails();
                  showSnackbarAfterDataFetch("Data Successfully Deleted");
                }
                getAllStudentDetails();
              },
              child: TextWidgetCommon(
                text: "Delete",
                color: kRed,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getAllStudentDetails();
    super.initState();
  }

  DbFunctions dbFn = DbFunctions();

  void searchStudents(String query) async {
    var students = await _dbService
        .getOneStudentFromDbList(StudentDataBaseModel(name: query));
    if (students != null) {
      _studentDataList = <StudentDataBaseModel>[];
      students.forEach((student) {
        setState(() {
          // Populate _studentDataList with search results
          var studentModel = StudentDataBaseModel();
          studentModel.id = student['id'];
          studentModel.name = student['name'];
          studentModel.age = student['age'];
          studentModel.place = student['place'];
          studentModel.standard = student['standard'];

          try {
            Uint8List? imageBytes = student['profileimage'];

            if (imageBytes != null) {
              studentModel.profileimage = imageBytes;
            }
          } catch (e) {
            // Handle decoding error
            print('Error decoding profile image: $e');
          }

          _studentDataList.add(studentModel);
        });
      });
    } else {
      setState(() {
        // Clear the _studentDataList
        _studentDataList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TextWidgetCommon(
          text: "Student Record",
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(
              bottom: 30,
              left: 30,
              right: 30,
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(217, 195, 195, 195),
            ),
            child: TextField(
              onChanged: (searchedWord) {
                searchStudents(searchedWord);
              },
              controller: searchValueController,
              style: TextStyle(
                color: kBlack,
                fontSize: 21,
              ),
              cursorColor: kBlack,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTransparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTransparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTransparent,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTransparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _studentDataList.isEmpty
          ? Center(
              child: TextWidgetCommon(
                text: "No student available",
                color: kBlack,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            )
          : ListView.separated(
              itemCount: _studentDataList.length,
              separatorBuilder: (context, index) => kHeight10,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    color: kBlackOpacity,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfilePage(
                            studentModel: _studentDataList[index]),
                      ),
                    );
                  },
                  leading: _studentDataList[index].profileimage != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(
                              _studentDataList[index].profileimage!),
                        )
                      : const CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ),
                          // child
                          //  Container(
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     image: DecorationImage(
                          //         image: _studentDataList[index].profileimage != null
                          // ? MemoryImage(
                          //     _studentDataList[index].profileimage!)
                          //             : MemoryImage(
                          //                 Uint8List(0),
                          //               ),
                          //         fit: BoxFit.cover,
                          //         scale: 10),
                          //   ),
                          // ),
                        ),
                  title: TextWidgetCommon(
                    overflow: TextOverflow.ellipsis,
                    text: _studentDataList[index].name ?? '',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => EditStudentProfilePage(
                                  studentModel: _studentDataList[index]),
                            ),
                          )
                              .then((value) {
                            if (value != null) {
                              getAllStudentDetails();
                              showSnackbarAfterDataFetch(
                                  "Data Successfully Saved");
                            }
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: kBlack,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteAlertDialog(
                              context, _studentDataList[index].id);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: kBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlack,
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const AddStudent(),
            ),
          )
              .then((value) {
            if (value != null) {
              getAllStudentDetails();
              showSnackbarAfterDataFetch("Data Successfully Saved");
            }
          });
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: kWhite,
        ),
      ),
    );
  }

  Widget buildGrid(int index) {
    return Container(
      // height: 10,
      // width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration:
          BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: _studentDataList[index].profileimage != null
                        ? MemoryImage(_studentDataList[index].profileimage!)
                        : MemoryImage(
                            Uint8List(0),
                          ),
                    fit: BoxFit.cover,
                    scale: 10),
              ),
            ),
          ),
          TextWidgetCommon(
            overflow: TextOverflow.ellipsis,
            text: _studentDataList[index].name ?? '',
            color: Colors.black,
            fontSize: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => EditStudentProfilePage(
                          studentModel: _studentDataList[index]),
                    ),
                  )
                      .then((value) {
                    if (value != null) {
                      getAllStudentDetails();
                      showSnackbarAfterDataFetch("Data Successfully Saved");
                    }
                  });
                  ;
                },
                icon: Icon(
                  Icons.edit,
                  color: kBlack,
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteAlertDialog(context, _studentDataList[index].id);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: kBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
