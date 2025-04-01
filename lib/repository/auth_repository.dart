import 'package:flutter_app/data/network/base_services.dart';
import 'package:flutter_app/data/network/networkApiServices.dart';

import '../res/app_url.dart';

class AuthRepository{
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data)async{
    try{
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> signUpApi(dynamic data)async{
    try{
      dynamic response  = await _apiServices.getPostApiResponse(AppUrl.registerApiEndPoint, data);
      return  response;
    }catch(e){
      throw e;
    }
  }
}