import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class DashboardRepo {
  Future<ResponseModel> getBalance() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.balance);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getBoxesTotal() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.boxes);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getCustomersTotal() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.customers);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUnitsTotal() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.units);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getUsersTotal() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.users);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getProjectsTotal() async {
    final response = await DioNetwork.get(path: AppApi.dashboard.projects);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getDebitCustomersCount() async {
    final response = await DioNetwork.get(
      path: AppApi.dashboard.debitCustomersCount,
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getDebitCreditBalance() async {
    final response = await DioNetwork.get(
      path: AppApi.dashboard.debitCreditBalance,
    );
    return ResponseModel.fromJson(response.data);
  }
}
