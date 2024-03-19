import 'dart:convert';
import 'dart:io';

import 'package:database_practice/model/student_database_model.dart';
import 'package:database_practice/screens/common_widgets/text_field_common_widget.dart';
import 'package:database_practice/screens/common_widgets/text_widget_common.dart';
import 'package:database_practice/services/db_servicer.dart';
import 'package:database_practice/utils/colors.dart';
import 'package:database_practice/utils/height_width.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStudentProfilePage extends StatefulWidget {
  const EditStudentProfilePage({super.key, required this.studentModel});
  final StudentDataBaseModel studentModel;

  @override
  State<EditStudentProfilePage> createState() => _EditStudentProfilePageState();
}

class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
  var _nameController = TextEditingController();
  var _ageController = TextEditingController();
  var _placeController = TextEditingController();
  var _standardController = TextEditingController();

  bool _namevalidate = true;
  bool _agevalidate = true;
  bool _placevalidate = true;
  bool _standardvalidate = true;
  var _dbServicer = DbServicer();

  @override
  void initState() {
    setState(() {
      _nameController.text = widget.studentModel.name ?? '';
      _ageController.text = widget.studentModel.age ?? '';
      _placeController.text = widget.studentModel.place ?? '';
      _standardController.text = widget.studentModel.standard ?? '';
    });
    super.initState();
  }

  File? studentImage;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: studentImage != null
                    ? MemoryImage(studentImage!.readAsBytesSync())
                    : MemoryImage(widget.studentModel.profileimage!),
                child: Center(
                  child: studentImage != null
                      ? null
                      : IconButton(
                          onPressed: () async {
                            final pickedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedImage != null) {
                              setState(() {
                                studentImage = File(pickedImage.path);
                              });
                            }
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 35,
                            color: kBlack,
                          ),
                        ),
                ),
              ),
              TextWidgetCommon(
                text: "Edit Student Details",
                color: kBlack,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              kHeight15,
              TextFieldCommonWidget(
                errorText: !_namevalidate ? "Name can't be Empty" : null,
                keyboardType: TextInputType.text,
                nameController: _nameController,
                hintText: "Name",
                labelText: "Enter name",
              ),
              kHeight15,
              TextFieldCommonWidget(
                errorText: !_agevalidate ? "Age can't be Empty" : null,
                keyboardType: TextInputType.number,
                nameController: _ageController,
                hintText: "Age",
                labelText: "Enter age",
              ),
              kHeight15,
              TextFieldCommonWidget(
                errorText: !_placevalidate ? "Place can't be Empty" : null,
                keyboardType: TextInputType.text,
                nameController: _placeController,
                hintText: "Place",
                labelText: "Enter place",
              ),
              kHeight15,
              TextFieldCommonWidget(
                errorText: !_standardvalidate ? "Class can't be Empty" : null,
                keyboardType: TextInputType.text,
                nameController: _standardController,
                hintText: "Class",
                labelText: "Enter class",
              ),
              kHeight15,
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kBlack),
                    onPressed: () async {
                      setState(() {
                        _nameController.text.isEmpty
                            ? _namevalidate = false
                            : _namevalidate = true;
                        _ageController.text.isEmpty
                            ? _agevalidate = false
                            : _agevalidate = true;
                        _placeController.text.isEmpty
                            ? _placevalidate = false
                            : _placevalidate = true;
                        _standardController.text.isEmpty
                            ? _standardvalidate = false
                            : _standardvalidate = true;
                      });

                      RegExp regExp =
                          RegExp(r"^(0?[1-9]|[1-9][0-9]|[1][01][0-9]|120)$");
                      RegExp stringRegExp = RegExp(r"^[^0-9,]*$");
                      if (_namevalidate &&
                          _agevalidate &&
                          _placevalidate &&
                          _standardvalidate &&
                          regExp.hasMatch(_ageController.text) &&
                          stringRegExp.hasMatch(_nameController.text) &&
                          stringRegExp.hasMatch(_placeController.text)) {
                        var _student = StudentDataBaseModel();
                        _student.profileimage = studentImage != null
                            ? await File(studentImage!.path).readAsBytes()
                            : null;
                        _student.id = widget.studentModel.id;
                        _student.name = _nameController.text;
                        _student.age = _ageController.text;
                        _student.place = _placeController.text;
                        _student.standard = _standardController.text;
                        var result =
                            await _dbServicer.updateStudentData(_student);
                        Navigator.pop(context, result);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(
                              seconds: 2,
                            ),
                            content: TextWidgetCommon(
                              color: kWhite,
                              text: "Fill all fields correctly",
                            ),
                          ),
                        );
                      }
                    },
                    child: TextWidgetCommon(
                      text: "Save",
                      color: kWhite,
                    ),
                  ),
                  kWidth15,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kBlack),
                    onPressed: () {
                      _nameController.text = '';
                      _ageController.text = '';
                      _placeController.text = '';
                      _standardController.text = '';
                    },
                    child: TextWidgetCommon(
                      text: "Clear",
                      color: kWhite,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
