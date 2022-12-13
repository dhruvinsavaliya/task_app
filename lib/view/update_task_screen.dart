// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/model/req_model/task_req_model.dart';
import 'package:task_app/view/home_screen.dart';
import '../utils/shared_pref_utils.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen(
      {Key? key,
      required this.description,
      required this.status,
      required this.id})
      : super(key: key);

  final String? description;
  final bool? status;
  final String? id;

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  String? description;
  bool? status;
  String? id;

  ///----------

  String? selectedItem;
  TextEditingController? descriptionController;
  final formKey = GlobalKey<FormState>();
  TaskReqModel reqModel = TaskReqModel();

  ///----

  @override
  void initState() {
    id = widget.id;
    selectedItem = widget.status == true ? 'Done' : 'Pending';

    description = widget.description;
    descriptionController = TextEditingController(text: description);
    super.initState();
  }

  /// ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                SizedBox(height: 20.w),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '****';
                    }
                    return null;
                  },
                  maxLines: 20,
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
                SizedBox(height: 20.w),
                DropdownButton<String>(
                    value: selectedItem,
                    items: ['Done', 'Pending'].map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    }),
                SizedBox(height: 10.w),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        reqModel.description = descriptionController!.text;

                        reqModel.status =
                            selectedItem == 'Done' ? 'true' : 'false';

                        bool? status = await updateTaskRepo(
                            reqBody: reqModel.toJson(), id: id);

                        if (status == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                                const SnackBar(
                                  content: Text('Updated Successfully'),
                                ),
                              )
                              .closed
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Update'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///update response methods
  Future updateTaskRepo({Map<String, dynamic>? reqBody, String? id}) async {
    Map<String, String> header = {
      'x-access-token': SharedPreferenceUtils.getToken()
    };

    http.Response response = await http.put(
        Uri.parse('http://tasks-demo.herokuapp.com/api/tasks/$id'),
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
