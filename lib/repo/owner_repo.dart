import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class OwnerRepo {
  Future<ResponseModel> getFullReport() async {
    final response = await DioNetwork.get(path: AppApi.ownerApi.fullReport);

    return ResponseModel.fromJson(response.data);
  }
}
