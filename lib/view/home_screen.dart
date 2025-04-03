import 'package:flutter/material.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/view_model/home_view_model.dart';
import 'package:flutter_app/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import '../data/response/status.dart';
import '../res/components/button.dart';
import '../utils/routes/routes_name.dart';
import 'package:flutter_app/knowyourland_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode jobFocusNode = FocusNode();
  HomeViewModel homeViewModel = HomeViewModel();
  @override
  void initState() {
    homeViewModel.fetchUserListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPrefernce = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              userPrefernce.remove().then((value) {
                Navigator.pushNamed(context, RoutesName.login);
              });
            },
            child: Wrap(
              children: [
                Icon(
                  Icons.logout,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
        title: Text("DashBoard"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ChangeNotifierProvider<HomeViewModel>(
            create: (BuildContext context) => homeViewModel,
            child: Consumer<HomeViewModel>(builder: (context, value, _) {
              switch (value.userList.status) {
                case Status.LOADING:
                  return CircularProgressIndicator();
                case Status.ERROR:
                  return Text(value.userList.toString());
                case Status.COMPLETED:
                  return Expanded(
                      child: ListView.builder(
                          itemCount: value.userList.data!.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: Wrap(
                                  children: [
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ClipOval(
                                      child: Image.network(
                                        value.userList.data!.data![index].avatar
                                            .toString(),
                                        errorBuilder: (context, error, stack) {
                                          return Icon(Icons
                                              .error); // If the image fails to load, show an error icon
                                        },
                                        width:
                                            50, // Set the desired width for the circle
                                        height:
                                            50, // Set the desired height for the circle (same as width to make it circular)
                                        fit: BoxFit
                                            .cover, // Ensure the image covers the circle area
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(value
                                    .userList.data!.data![index].email
                                    .toString()),
                                subtitle: Text(value
                                    .userList.data!.data![index].firstName
                                    .toString()),
                                trailing: Wrap(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return getBottomSheetWidget(
                                                  isUpdate: true,
                                                  userId: value.userList.data!
                                                      .data![index].id!,
                                                  name: value.userList.data!
                                                      .data![index].firstName!,
                                                  email: value.userList.data!
                                                      .data![index].email!,
                                                );
                                              });
                                        },
                                        child: Icon(Icons.edit,
                                            color: Colors.blue)),
                                    InkWell(
                                        onTap: () {
                                          // Call delete user method
                                          homeViewModel
                                              .deleteUser(value.userList.data!
                                                  .data![index].id!)
                                              .then((_) {
                                            Utils.flushBarErrorMessage(
                                                "User deleted Successfully",
                                                context);
                                          }).catchError((error) {
                                            Utils.flushBarErrorMessage(
                                                "Error deleting user", context);
                                          });
                                        },
                                        child: Icon(Icons.delete,
                                            color: Colors.red)),
                                  ],
                                ));
                          }));
                case null:
                  // TODO: Handle this case.
                  throw UnimplementedError();
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _nameController.clear();
                    _jobController.clear();
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return getBottomSheetWidget();
                      },
                    );
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KnowYourLandScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Know Your Land "),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getBottomSheetWidget(
      {bool isUpdate = false,
      int userId = 0,
      String name = '',
      String email = ''}) {
    if (isUpdate) {
      _nameController.text = name;
      _jobController.text = email;
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            isUpdate ? "Update User" : "Add User",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "Enter your Name",
                labelText: "Name",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                ),
              ),
              onFieldSubmitted: (value) {
                Utils.fieldFocusChange(context, emailFocusNode, jobFocusNode);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _jobController,
              focusNode: jobFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.work),
                hintText: "Enter your Job",
                labelText: "Job",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 195,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Optional: rounded corners
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                ),
                RoundButton(
                  title: isUpdate ? "Update User" : "Add User",
                  loading: homeViewModel.loading,
                  onPress: () {
                    if (_nameController.text.isEmpty ||
                        _jobController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Please Enter your form", context);
                    } else {
                      Map<String, dynamic> data = {
                        'name': _nameController.text.toString(),
                        'job': _jobController.text.toString(),
                      };

                      homeViewModel.createUser(data).then((_) {
                        Utils.flushBarErrorMessage(
                            isUpdate
                                ? "Update User successfully"
                                : "User created successfully",
                            context);
                        // Navigator.pop(context); // Close the bottom sheet
                      }).catchError((error) {
                        Utils.flushBarErrorMessage(
                            "Error creating user: $error", context);
                      });
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
