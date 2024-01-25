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
        studentModel.profileImage = student['profileimage'];
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
                color: Color.fromARGB(217, 249, 249, 249)),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: searchValueController,
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 21,
                    ),
                    cursorColor: kBlack,
                    decoration: InputDecoration(
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
                Expanded(
                  child: IconButton(
                    onPressed: () async {
                      // final searchValue = searchValueController.text;
                      // await _dbService.getOneStudentFromDbList();
                    },
                    icon: Icon(
                      Icons.search,
                      color: kBlack,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _studentDataList.length,
        separatorBuilder: (context, index) => kHeight10,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              color: kBlue.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      StudentProfilePage(studentModel: _studentDataList[index]),
                ),
              );
            },
            leading:  CircleAvatar(
              radius: 50,
              backgroundImage:_studentDataList[index].profileImage!=null? AssetImage(_studentDataList[index].profileImage!):null,
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlack,
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddStudent(),
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
}
