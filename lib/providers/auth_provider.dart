import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:elite/core/constants.dart';
import 'package:elite/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/helper_methods.dart';
import '../models/city_area_model.dart';
import '../models/city_model.dart';
import '../models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../screens/auth_pages/create_account_page.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();

  UserModel? _userInformation;

  UserModel? get userInformation {
    return _userInformation;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('access_token') && !prefs.containsKey('is_guest')) {
      print("There is no Data");
      return false;
    }
    print("tryAutoLoginMethod");
    return true;
  }

  Future<List<CityModel>> getCities({
    required BuildContext context,
  }) async {
    List<CityModel> tempList = [];

    try {
      // print(employModel.toJson().toString());
      // print(token.toString());
      // return employees;
      final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}City/get_all_cities",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": token
          },
          // responseType: ResponseType.json ,
        ),
      );
      // queryParameters: {"country_identifier": countryIdenifier});
      var loadedList = response.data as List;
      for (var cities in loadedList) {
        tempList.add(CityModel.fromJson(cities, context));
      }

      return tempList;
    } on DioError {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }

  Future<List<CityRegionModel>> getCityAreas(
      {required BuildContext context, required String cityIdenifier}) async {
    List<CityRegionModel> tempList = [];

    try {
      // print(employModel.toJson().toString());
      // print(token.toString());
      // return employees;
      final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}Area/$cityIdenifier",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            // "Authorization": token
          },
          // responseType: ResponseType.json ,
        ),
      );
      // queryParameters: {"country_identifier": countryIdenifier});
      final loadedList = response.data as List;
      for (var cities in loadedList) {
        tempList.add(CityRegionModel.fromJson(cities, context));
      }

      return tempList;
    } catch (e) {
      // print(e.toString());

      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }

  Future<bool> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return false;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
      log(user.toString());
      if (user == null) {
        return false;
      }
      Response checkResponse = await _dio.get(
        "${API_URL}Login/Get_email?Email=${user.email.toString()}",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          },
        ),
      );
      print(checkResponse.data);
      print(checkResponse.statusCode);
      if (checkResponse.statusCode == 200) {
        Response googleResponse = await _dio.post(
          "${API_URL}Login/GoogleSignin?Email=${user.email.toString()}",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
          ),
        );
        UserModel userModel = UserModel.fromJson(googleResponse.data["users1"]);
        await saveAccessTokenlocaly(
            accessToken: googleResponse.data["tokenString"]);
        await saveUserDatalocaly(userModel: userModel);

        return true;
      }

      // print(user!.displayName.toString());
      // print(user.photoURL.toString());
      // print(user.uid.toString());
      // print(user.email.toString());
      //  print(user..toString());

      return true;
    } on DioError catch (e) {
      log(e.toString());
      if (e.response!.statusCode == 404) {
        _userInformation = UserModel(
            firstName: user!.displayName.toString(),
            lastName: "",
            email: user.email.toString(),
            password: "",
            age: '',
            loginType: 2,
            cityId: "",
            userGender: "",
            areaId: "",
            userId: "",
            userPhone:
                user.phoneNumber == null ? "" : user.phoneNumber.toString());
        print("Account not exists");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateAccountPage(
                    userModel: _userInformation,
                    fromGoogle: true,
                  )),
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future createGoogleAccount(
      {required UserModel user,
      required CityModel selectedCity,
      required CityRegionModel selectedRegionCity,
      required BuildContext context}) async {
    try {
      var response = await http.post(
          Uri.parse('${API_URL}Login/GoogleSignin?Email=${user.email}'),
          body: {
            'RoleID': "1",
            'FirstName': user.firstName,
            "LastName": user.lastName,
            'Email': user.email,
            "PhoneNo": user.userPhone,
            // 'Password': user.password!,
            'Age': user.age,
            "SexID": user.userGender,
            "CityID": selectedCity.id,
            "AreaID": selectedRegionCity.id,
            "IsApprove": "True",
            "Image": ""
          });
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        print('body : $jsonResponse.');
        UserModel userModel = UserModel.fromJson(jsonResponse["userID"]);
        await saveAccessTokenlocaly(accessToken: jsonResponse["tokenString"]);
        await saveUserDatalocaly(userModel: userModel);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      Response loginResponse = await _dio.post("${API_URL}Login",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
          ),
          data: {
            'username': email,
            'password': password,
          });
      print(loginResponse.data.toString());

      UserModel userModel = UserModel.fromJson(loginResponse.data["user"]);

      await saveAccessTokenlocaly(
          accessToken: loginResponse.data["tokenString"]);
      await saveUserDatalocaly(userModel: userModel);
      return true;
    } catch (e) {
      print(e.toString());
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // if (e.response != null) {
      //   // print(e.response?.data);
      //   print(e.response?.data["error_messages"]);
      //   print(e.response?.statusCode);
      // String errorMessages = "";
      // for (var element in e.response?.data["error_messages"]) {
      //   errorMessages += element + "\n";
      // }
      // _helperMethods.showErrorDilog(errorText: errorMessages, context: context);

      BotToast.showText(
          text:
              "Something went Wrong! \n under development!"); //popup a text toast;
      // //   // cancel();
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return false;
    }
  }

  Future<bool> logout({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      // final token = await _helperMethods.getToken();

      // Response resendResponse = await _dio.post("$API_URL/auth/logout",
      //     options: Options(
      //       headers: {
      //         "Accept": "application/json",
      //         "content-type": "application/json",
      //         "Authorization": token
      //       },
      //     ),
      //     data: {});
      prefs.remove("access_token");
      prefs.remove("is_guest");

      notifyListeners();
      return true;
    } on DioError {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      // return false;
      prefs.remove("access_token");
      prefs.remove("is_guest");

      notifyListeners();
      return true;
    }
  }

  Future<bool> deleteAccount({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final token = await _helperMethods.getToken();

      Response deleteResponse = await _dio
          .delete("${API_URL}Users/${_userInformation?.userId.toString()}",
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  "Authorization": token
                },
              ),
              data: {});
      log(deleteResponse.data.toString());
      // prefs.remove("access_token");
      // prefs.remove("is_guest");
      // notifyListeners();

      return true;
    } catch (e) {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      // return false;
      log(e.toString());
      return false;
    }
  }

  Future<bool> signUp(
      {required UserModel user,
      required CityModel selectedCity,
      required CityRegionModel selectedRegionCity,
      required BuildContext context}) async {
    try {
      // Await the http get response, then decode the json-formatted response.
      var response =
          await http.post(Uri.parse('${API_URL}Login/create'), body: {
        'RoleID': "1",
        'FirstName': user.firstName,
        "LastName": user.lastName,
        'Email': user.email,
        "PhoneNo": user.userPhone,
        'Password': user.password!,
        'Age': user.age,
        "SexID": user.userGender,
        "CityID": selectedCity.id,
        "AreaID": selectedRegionCity.id,
        "IsApprove": "True",
        "Image": ""
      });
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        // print('Number of books about http: $jsonResponse.');
        UserModel userModel = UserModel.fromJson(jsonResponse["userID"]);
        await saveAccessTokenlocaly(accessToken: jsonResponse["tokenString"]);
        await saveUserDatalocaly(userModel: userModel);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
      // var request =
      //     http.MultipartRequest('POST', Uri.parse('$API_URL/Login/create'));
      // request.fields.addAll({
      //   'RoleID': "1",
      //   'FirstName': user.firstName,
      //   "LastName": user.lastName,
      //   'Email': user.email,
      //   "PhoneNo": user.userPhone,
      //   'Password': user.password!,
      //   'Age': user.age,
      //   "SexID": user.userGender,
      //   "CityID": selectedCity.id,
      //   "AreaID": selectedRegionCity.id,
      //   "IsApprove": "True",
      //   "Image": ""
      // });
      // // request.files.add(await http.MultipartFile.fromPath('Image', null));

      // http.StreamedResponse response = await request.send();
      // print(response.stream..toString());
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print(await response.stream.bytesToString());
      //   // var jsonResponse =
      //   //     convert.jsonDecode(response.stream.bytesToString()) as Map<String, dynamic>;
      // } else {
      //   print(response.reasonPhrase);
      // }

      // Response loginResponse = await _dio.post("${API_URL}Login/create",
      //     options: Options(
      //       headers: {
      //         "Accept": "application/json",
      //         "Content-Type": "application/json",
      //         // "contentType": "application/x-www-form-urlencoded",
      //       },
      //     ),
      //     data: {
      //       'RoleID': 1,
      //       'FirstName': user.firstName,
      //       "LastName": user.lastName,
      //       'Email': user.email,
      //       "PhoneNo": user.userPhone,
      //       'Password': user.password,
      //       'Age': user.age,
      //       "SexID": user.userGender,
      //       "CityID": selectedCity.id,
      //       "AreaID": selectedRegionCity.id,
      //       "IsApprove": "True",
      //       "Image": ""
      //     });
      // print(loginResponse.toString());
      // UserModel userModel = UserModel.fromJson(loginResponse.data["userID"]);
      // await saveAccessTokenlocaly(
      //     accessToken: loginResponse.data["tokenString"]);
      // await saveUserDatalocaly(userModel: userModel);
      // UserModel userModel = UserModel.fromJson(loginResponse.data["user"]);
      // saveAccessTokenlocaly("asdasd", );
    } on DioError catch (e) {
      // print(e.toString());
      print(e.requestOptions.data.toString());
      print(e.error);
      print(e.response);

      BotToast.showText(text: "Something went Wrong! \n under development!");
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // if (e.response != null) {
      //   // print(e.response?.data);
      //   print(e.response?.data["error_messages"]);
      //   print(e.response?.statusCode);
      // String errorMessages = "";
      // for (var element in e.response?.data["error_messages"]) {
      //   errorMessages += element + "\n";
      // }
      // _helperMethods.showErrorDilog(errorText: errorMessages, context: context);

      //   BotToast.showText(text: _errorMessages); //popup a text toast;
      //   // cancel();
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return false;
    }
  }

  Future<bool> updateUserData(
      {required UserModel user,
      XFile? userImage,
      required BuildContext context}) async {
    try {
      // Await the http get response, then decode the json-formatted response.

      Map<String, dynamic> dataMap = {
        'RoleID': "1",
        'FirstName': user.firstName,
        "LastName": user.lastName,
        'Email': user.email,
        "PhoneNo": user.userPhone,
        'Password': user.password!,
        'Age': user.age,
        "SexID": user.userGender,
        "CityID": user.cityId,
        "AreaID": user.areaId,
        "UserID": user.userId,
      };
      if (userImage != null) {
        dataMap["Image"] = await MultipartFile.fromFile(
          userImage.path,
          filename: userImage.name,
        );
        // await http.MultipartFile.fromPath("Image", userImage.path);
        print("imagePath:${userImage.path}");
      }

      FormData formdata = FormData.fromMap(dataMap);
      final token = await _helperMethods.getToken();
      Response response = await _dio.post('${API_URL}Users/${user.userId}',
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": token
            },
          ),
          data: formdata);
      print(response.data);
      await getUserInformation(context);

      return true;
    } on DioError catch (e) {
      // print(e.toString());
      print(e.requestOptions.data.toString());
      print(e.error);
      print(e.response);

      BotToast.showText(text: "Something went Wrong! \n under development!");

      return false;
    }
  }

  Future saveAccessTokenlocaly({
    required String accessToken,
    UserModel? userModel,
  }) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("access_token", accessToken);
    pref.setBool("is_guest", false);
    // pref.setString("userData", json.encode(userModel.toJson()));
  }

  Future<bool> signInAsGuest() async {
    try {
      final pref = await SharedPreferences.getInstance();
      pref.setBool("is_guest", true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future saveUserDatalocaly({
    required UserModel? userModel,
  }) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString("userData", json.encode(userModel!.toJson()));
  }

  Future<void> getUserInformation(BuildContext context) async {
    try {
      final token = await _helperMethods.getToken();
      UserModel? userModel = await _helperMethods.getUser();

      if (userModel == null) return;
      // print(token);
      Response response = await _dio.get(
          "${API_URL}Users/Get_UserID?UserID=${userModel.userId}",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": token
            },
          ));

      _userInformation = UserModel.fromGetUserIdJson(response.data[0]);
      saveUserDatalocaly(userModel: _userInformation);

      notifyListeners();
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserNotification({
    required BuildContext context,
    required int pageNumber,
  }) async {
    List<NotificationModel> tempList = [];
    try {
      UserModel? userModel = await _helperMethods.getUser();
      // print(userModel!.toJson().toString());
      if (userModel == null) {
        return {"list": tempList, "isThereNextPage": false};
      }
      Response response =
          await _dio.get("${API_URL}Notification?UserID=${userModel.userId}",
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  // "Authorization": token
                },
              ));
      // print("response" + response.data.toString());

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        tempList.add(NotificationModel.fromJson(item));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.response.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }
}
