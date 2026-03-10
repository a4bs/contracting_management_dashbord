import 'package:contracting_management_dashbord/controller/dashboard_controller/dashboard_controller.dart';
import 'package:contracting_management_dashbord/model/dashboard/dashboard_model.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ReportNumberScreen extends StatelessWidget {
  ReportNumberScreen({super.key});
  final DashboardController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalBalance(),
            _buildBoxesTotal(),
            _buildCustomersTotal(),
            _buildUnitsTotal(),
            _buildUsersTotal(),
            _buildProjectsTotal(),
            _buildDebitCustomersCount(),
            _buildDebitCreditBalance(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalance() {
    return FutureBuilder<TotalBalance>(
      future: controller.getBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading(count: 4);
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Column(
            children: [
              _buildListTile(
                " مجموع الفواتير",
                '${AppTool.formatMoney(data.totalBillsDebit.toString())}',
                Colors.orange,
                Icons.receipt_long,
              ),

              _buildListTile(
                " مجموع الميزانية",
                '${AppTool.formatMoney(data.balance.toString())}',
                Colors.purple,
                Icons.account_balance_wallet,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBoxesTotal() {
    return FutureBuilder<BoxDashboardModel>(
      future: controller.getBoxesTotal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            " مجموع الصناديق",
            snapshot.data!.totalBoxes,
            Colors.brown,
            Icons.inventory_2,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCustomersTotal() {
    return FutureBuilder<CustomerDashboardModel>(
      future: controller.getCustomersTotal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            " مجموع العملاء",
            snapshot.data!.totalCustomers,
            Colors.teal,
            Icons.people,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUnitsTotal() {
    return FutureBuilder<UnitDashboardModel>(
      future: controller.getUnitsTotal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            "مجموع الوحدات",
            snapshot.data!.totalUnits,
            Colors.indigo,
            Icons.apartment,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUsersTotal() {
    return FutureBuilder<UserDashboardModel>(
      future: controller.getUsersTotal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            "مجموع المستخدمين",
            snapshot.data!.totalUsers,
            Colors.cyan,
            Icons.person,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProjectsTotal() {
    return FutureBuilder<ProjectDashboardModel>(
      future: controller.getProjectsTotal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            "مجموع المشاريع",
            snapshot.data!.totalProjects,
            Colors.deepOrange,
            Icons.work,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDebitCustomersCount() {
    return FutureBuilder<DebitCustomersDashboardModel>(
      future: controller.getDebitCustomersCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasData) {
          return _buildListTile(
            "مجموع العملاء المدين",
            snapshot.data!.debitCustomersCount,
            Colors.redAccent,
            Icons.money_off,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDebitCreditBalance() {
    return FutureBuilder<DebitCreditBalanceModel>(
      future: controller.getDebitCreditBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading(count: 2);
        }
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Column(
            children: [
              _buildListTile(
                "سحوبات  ",
                '${AppTool.formatMoney(data.credit.toString())}',
                Colors.red,
                Icons.trending_down,
              ),
              _buildListTile(
                "إيداعات",
                '${AppTool.formatMoney(data.debit.toString())}',
                Colors.green,
                Icons.trending_up,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildListTile(
    String title,
    String? value,
    Color color,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Text(
          "${value ?? 0}",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading({int count = 1}) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Column(
        children: List.generate(
          count,
          (index) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0, // Flat during loading looks cleaner
            color: Colors.grey[100], // Light background for the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              trailing: Container(
                width: 60,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
