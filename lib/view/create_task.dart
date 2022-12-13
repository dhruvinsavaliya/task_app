import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:task_app/utils/shared_pref_utils.dart';
import 'package:task_app/view/home_screen.dart';

import '../model/req_model/task_req_model.dart';

class CreateTask extends StatefulWidget {
  CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController descriptionController = TextEditingController();
  String? selectedItem = 'Done';
  final formKey = GlobalKey<FormState>();
  TaskReqModel reqModel = TaskReqModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.w),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '****';
                      }
                    },
                    maxLines: 20,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Start writing here...',
                      filled: true,
                      fillColor: Colors.cyanAccent,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.w),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  DropdownButton<String>(
                      value: selectedItem,
                      items: ['Done', 'Pending'].map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e), value: e);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });
                      }),
                  SizedBox(height: 5.w),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        reqModel.description = descriptionController.text;
                        reqModel.status =
                            selectedItem == 'Done' ? 'true' : 'false';

                        log('CREATE TASK REQ MODEL===>>${reqModel.toJson()}');

                        //log('=====>${reqModel.status}');
                        bool? status =
                            await createTaskRepo(reqBody: reqModel.toJson());

                        if (status == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text('Task created Successfully')))
                              .closed
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('invalid'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Create'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<bool>? createTaskRepo({Map<String, dynamic>? reqBody}) async {
    Map<String, String> header = {
      'x-access-token': SharedPreferenceUtils.getToken()
    };

    http.Response response = await http.post(
        Uri.parse('http://tasks-demo.herokuapp.com/api/tasks'),
        headers: header,
        body: reqBody);

    //var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
