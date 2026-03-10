import 'package:contracting_management_dashbord/constant/app_api.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';

class BillRepo {
  Future<ResponseModel> getAllBills() async {
    final response = await DioNetwork.get(path: AppApi.bill.filter);
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> getBillById(id) async {
    final response = await DioNetwork.get(path: AppApi.bill.one(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addBill(data) async {
    final response = await DioNetwork.post(
      path: AppApi.bill.bills,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> updateBill(id, data) async {
    final response = await DioNetwork.put(
      path: AppApi.bill.update(id),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> deleteBill(id) async {
    final response = await DioNetwork.delete(path: AppApi.bill.delete(id));
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> filterBills(BillFilter billFilter) async {
    final response = await DioNetwork.get(
      path: AppApi.bill.filter,
      queryParameters: Map<String, dynamic>.from(billFilter.toJson()),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> addAdvanceBonds(data) async {
    final response = await DioNetwork.post(
      path: AppApi.bill.advance,
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> syncBonds(idBill, data) async {
    final response = await DioNetwork.put(
      path: AppApi.bill.syncBonds(idBill),
      data: Map<String, dynamic>.from(data),
    );
    return ResponseModel.fromJson(response.data);
  }
}
