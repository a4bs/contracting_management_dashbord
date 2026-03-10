import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class AuthRepo {
  Future<ResponseModel> login(data) async {
    final response = await DioNetwork.post(
      path: AppApi.login,
      data: Map<String, dynamic>.from(data),
    );

    return ResponseModel.fromJson(response.data);
  }
}
