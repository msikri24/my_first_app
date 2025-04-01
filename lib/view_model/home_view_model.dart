
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/response/api_response.dart';
import 'package:flutter_app/model/user_list.dart';
import 'package:flutter_app/repository/home_repository.dart';


class HomeViewModel with ChangeNotifier{
  final _myRepo = HomeRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

ApiResponse<UserList> userList = ApiResponse.loading();


setUserList(ApiResponse<UserList> response){
     userList = response;
     notifyListeners();
  }

  Future<void> fetchUserListApi() async{
    setUserList(ApiResponse.loading());
    _myRepo.fetchUserList().then((value){
      setUserList(ApiResponse.completed(value));
    }).onError((error , stackTrace){
      setUserList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _myRepo.deleteUser(userId); // Call the delete method from repository
      fetchUserListApi();  // Refresh the user list after deletion
    } catch (e) {
      print("Error deleting user: $e");
      throw Exception("Error deleting user: $e");
    }
  }


  Future<void> createUser(Map<String, dynamic> userData) async {
    setLoading(true);
    try {
      setLoading(false);
      await _myRepo.createUser(userData); // Call the create user method from repository
      fetchUserListApi(); // Refresh the user list after creation
    } catch (e){
      setLoading(false);
      print("Error creating user: $e");
      throw Exception("Error creating user: $e");
    }
  }

  // Update User
/*  Future<void> updateUser(int userId, Map<String, dynamic> updatedData) async {
    try {
      await _myRepo.updateUser(userId, updatedData); // Call the update user method from repository
      fetchUserListApi(); // Refresh the user list after updating
    } catch (e) {
      print("Error updating user: $e");
      throw Exception("Error updating user: $e");
    }
  }*/

}

