import 'package:database_practice/model/student_database_model.dart';
import 'package:database_practice/screens/common_widgets/text_widget_common.dart';
import 'package:database_practice/utils/colors.dart';
import 'package:database_practice/utils/height_width.dart';
import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key, required this.studentModel});

  final StudentDataBaseModel studentModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(
          text: "Student Record",
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgetCommon(
              text: " Full Details",
              color: kGreen,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
            kHeight25,
            Center(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kGreen, width: 5)),
                child: CircleAvatar(
                    radius: 80,
                    backgroundImage: studentModel.profileimage != null
                        ? MemoryImage(studentModel.profileimage!)
                        : null),
              ),
            ),
            kHeight20,
            StudentDataRowWidget(
              fieldName: "Name",
              text: studentModel.name ?? '',
            ),
            kHeight15,
            StudentDataRowWidget(
              fieldName: "Age",
              text: studentModel.age ?? '',
            ),
            kHeight15,
            StudentDataRowWidget(
              fieldName: "Place",
              text: studentModel.place ?? '',
            ),
            kHeight15,
            StudentDataRowWidget(
              fieldName: "Class",
              text: studentModel.standard ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

class StudentDataRowWidget extends StatelessWidget {
  const StudentDataRowWidget({
    super.key,
    required this.text,
    required this.fieldName,
  });

  final String text;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kWhite,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 4),
              color: Color.fromARGB(143, 177, 177, 177),
            )
          ]),
      child: ListTile(
        leading: TextWidgetCommon(
          fontSize: 20,
          text: '$fieldName:',
          fontWeight: FontWeight.bold,
          color: kBlack,
        ),
        trailing: TextWidgetCommon(
          text: text,
          color: kBlack,
          fontSize: 20,
        ),
      ),
    );
  }
}
