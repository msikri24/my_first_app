
import 'package:flutter_app/data/network/base_services.dart';
import 'package:flutter_app/data/network/networkApiServices.dart';
import 'package:flutter_app/model/user_list.dart';
import 'package:flutter_app/res/app_url.dart';

class HomeRepository{
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<UserList> fetchUserList()async{
    try{
      dynamic response  = await _apiServices.getGetApiResponse(AppUrl.userListEndPoint);
      return response = UserList.fromJson(response);
    }catch(e){
      throw e;
    }
  }


  Future<void> deleteUser(int userId) async {
    try {
      String deleteUrl = "${AppUrl.deleteUserEndPoint}/$userId";  // Ensure this is correct
      await _apiServices.getDeleteApiResponse(deleteUrl);
    } catch (e) {
      print("Error deleting user: $e");
      throw Exception("Error deleting user: $e");  // Rethrow the error for the ViewModel to handle
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _apiServices.getPostApiResponse(AppUrl.createUserEndPoint, userData);
    } catch (e) {
      throw Exception("Error creating user: $e");
    }
  }

  // Update an existing user's information
/*  Future<void> updateUser(int userId, Map<String, dynamic> updatedData) async {
    try {
      // Define the URL for updating a user
      String updateUrl = "${AppUrl.deleteUserEndPoint}/$userId";  // Ensure this endpoint is correct

      // Perform a PUT request to update the user
      await _apiServices.getPostApiResponse(updateUrl, updatedData);
    } catch (e) {
      print("Error updating user: $e");
      throw Exception("Error updating user: $e");  // Rethrow the error for the ViewModel to handle
    }
  }*/
}

