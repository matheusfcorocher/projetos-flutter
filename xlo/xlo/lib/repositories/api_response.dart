import 'api_error.dart';

class ApiResponse {

  bool sucess;
  dynamic result;
  ApiError error;

  ApiResponse.sucess({this.result}) {
    sucess = true;
  }

  ApiResponse.error({this.error}) {
    sucess = false;
  }

}