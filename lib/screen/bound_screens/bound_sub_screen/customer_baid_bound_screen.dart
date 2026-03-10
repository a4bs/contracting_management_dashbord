import 'package:contracting_management_dashbord/controller/bill_controller/bill_controller.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/model/bill/bill_filter.dart';
import 'package:contracting_management_dashbord/screen/bill_screens/bill_detail_screen.dart';
import 'package:contracting_management_dashbord/widget/customer_search_dialog.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CustomerBaidBoundScreen extends GetView<BondController> {
  CustomerBaidBoundScreen({super.key});
  final CustomerController customerController = Get.find<CustomerController>();
  final BillController billController = Get.find<BillController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Text(
                'العميل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Obx(() {
            final selectedCustomer = controller.customerModelSelected.value;
            final customerName =
                selectedCustomer.name ?? 'اضغط هنا للبحث واختيار عميل...';
            return InkWell(
              onTap: () async {
                final result = await Get.dialog<CustomerModel>(
                  const CustomerSearchDialog(),
                );
                if (result != null) {
                  // Show the loading dialog
                  Get.dialog(
                    const Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    barrierDismissible: false,
                  );

                  // setting the value will trigger the FutureBuilder
                  controller.customerModelSelected.value = result;

                  // Add a small delay then safely close ONLY if there's an open dialog
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(
                    5,
                  ), // Dropdown match style
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      customerName,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: selectedCustomer.id == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          Obx(
            () => Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: billController.filterBills(
                    BillFilter(
                      customer: controller.customerModelSelected.value.id,
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return BillDetailScreen(
                        itemBill: snapshot.data![0],
                        withoutappbar: true,
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد فواتير لهذا العميل',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
