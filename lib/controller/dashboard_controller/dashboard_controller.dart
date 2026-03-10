import 'package:contracting_management_dashbord/model/dashboard/dashboard_model.dart';
import 'package:contracting_management_dashbord/repo/dashboard_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final DashboardRepo _repo = DashboardRepo();

  Future<TotalBalance> getBalance() async {
    try {
      final response = await _repo.getBalance();
      return TotalBalance.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return TotalBalance();
    }
  }

  Future<BoxDashboardModel> getBoxesTotal() async {
    try {
      final response = await _repo.getBoxesTotal();
      return BoxDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return BoxDashboardModel();
    }
  }

  Future<CustomerDashboardModel> getCustomersTotal() async {
    try {
      final response = await _repo.getCustomersTotal();
      return CustomerDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return CustomerDashboardModel();
    }
  }

  Future<UnitDashboardModel> getUnitsTotal() async {
    try {
      final response = await _repo.getUnitsTotal();
      return UnitDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return UnitDashboardModel();
    }
  }

  Future<UserDashboardModel> getUsersTotal() async {
    try {
      final response = await _repo.getUsersTotal();
      return UserDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return UserDashboardModel();
    }
  }

  Future<ProjectDashboardModel> getProjectsTotal() async {
    try {
      final response = await _repo.getProjectsTotal();
      return ProjectDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return ProjectDashboardModel();
    }
  }

  Future<DebitCustomersDashboardModel> getDebitCustomersCount() async {
    try {
      final response = await _repo.getDebitCustomersCount();
      return DebitCustomersDashboardModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return DebitCustomersDashboardModel();
    }
  }

  Future<DebitCreditBalanceModel> getDebitCreditBalance() async {
    try {
      final response = await _repo.getDebitCreditBalance();
      return DebitCreditBalanceModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return DebitCreditBalanceModel();
    }
  }
}
