import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/utils/routes/routes_name.dart';
import '../repository/auth_repository.dart';
import '../utils/utils.dart';


class AuthViewModel with ChangeNotifier{
  final _myRepo = AuthRepository();

  bool _loading = false;
bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }


  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setSignUpLoading(bool value){
    _signUpLoading = value;
    notifyListeners();
  }


  Future<void> loginApi(dynamic data , context)async{
    setLoading(true);
    _myRepo.loginApi(data).then((value){
      setLoading(false);
      final userPreference = Provider.of<UserViewModel>(context , listen: false);
      userPreference.saveUser(
        UserModel(
          token: value['token'].toString()
        )
      );
      Utils.flushBarErrorMessage('Login Successfully' , context);
      Navigator.pushNamed(context, RoutesName.home);
      if(kDebugMode){
        print(value.toString());
      }
    }).onError((error , stackTrace) {
      setLoading(false);
      if(kDebugMode){
        Utils.flushBarErrorMessage(error.toString() , context);
        print(error.toString());
      }
    });
  }


  Future<void> signUpApi(dynamic data , context)async{
    setSignUpLoading(true);
    _myRepo.signUpApi(data).then((value){
      setSignUpLoading(false);
      final userPreference = Provider.of<UserViewModel>(context , listen: false);
      userPreference.saveUser(
          UserModel(
              token: value['token'].toString()
          )
      );
      Utils.flushBarErrorMessage('Login Successfully' , context);
      Navigator.pushNamed(context, RoutesName.home);
      if(kDebugMode){
        print(value.toString());
      }
    }).onError((error , stackTrace) {
      setSignUpLoading(false);
      if(kDebugMode){
        Utils.flushBarErrorMessage(error.toString() , context);
        print(error.toString());
      }
    });
  }
}