import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/utils/shared_pref_utils.dart';
import 'package:task_app/view/update_task_screen.dart';
import '../model/res_model/taskapp_res_model.dart';
import 'create_task.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              await SharedPreferenceUtils.clearLocalData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<TaskappResModel>>(
        future: getAllTask(),
        builder: (context, AsyncSnapshot<List<TaskappResModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    deleteTaskRepo(id: snapshot.data![index].id.toString());
                  },
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return UpdateTaskScreen(
                            id: '${snapshot.data![index].id}',
                            description: '${snapshot.data![index].description}',
                            status: snapshot.data![index].status,
                          );
                        },
                      ));
                    },
                    title: Text('${snapshot.data![index].description}'),
                    subtitle: Text(snapshot.data![index].status == true
                        ? 'Done'
                        : 'Pending'),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTask(),
            )),
      ),
    );
  }

  Future<List<TaskappResModel>> getAllTask() async {
    Map<String, String> headers = {
      'x-access-token': SharedPreferenceUtils.getToken()
    };

    http.Response response = await http.get(
        Uri.parse('http://tasks-demo.herokuapp.com/api/tasks/'),
        headers: headers);

    List<TaskappResModel> result = List<TaskappResModel>.from(
        json.decode(response.body).map((x) => TaskappResModel.fromJson(x)));

    return result;
  }

  Future deleteTaskRepo({String? id}) async {
    Map<String, String> header = {
      'x-access-token': SharedPreferenceUtils.getToken()
    };

    http.Response response = await http.delete(
        Uri.parse('http://tasks-demo.herokuapp.com/api/tasks/$id'),
        headers: header);

    //var result = jsonDecode(response.body);
    if (response.statusCode == 200) {}
  }
}
