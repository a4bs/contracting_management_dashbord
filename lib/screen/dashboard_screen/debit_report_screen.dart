import 'package:contracting_management_dashbord/constant/enum/rol_enum.dart';
import 'package:contracting_management_dashbord/constant/enum/transaction_type_enum.dart';
import 'package:contracting_management_dashbord/controller/bond_controller/bond_controller.dart';
import 'package:contracting_management_dashbord/model/bond/filter_bond.dart';
import 'package:contracting_management_dashbord/screen/filter_app/filter_bound.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/display_groub_file.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:contracting_management_dashbord/widget/cards/cards_bound.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:contracting_management_dashbord/widget/dilog_check_user.dart';
import 'package:contracting_management_dashbord/widget/futuer_pagnation_page_widget.dart';
import 'package:contracting_management_dashbord/widget/future_pagination_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DebitReportScreen extends GetView<BondController> {
  DebitReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("الموافقة على سندات السحب", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      text: 'بحث  ',
                      icon: Icons.search,
                      backgroundColor: Colors.teal,
                      onPressed: () async {
                        Get.dialog(
                          Dialog(
                            child: FilterBondDilog(
                              onFilterSubmit: (data) async {
                                await controller.pageDataPagnationController3
                                    .refreshItems(
                                      (page, limit) => controller.filterBonds(
                                        FilterBond(
                                          notApprovedBy: UserTool.getUser().id,
                                          bondTypeId:
                                              TransactionTypeEnum.debit.id,
                                        ),
                                      ),
                                    );
                                Get.back();
                              },
                              filterBond: FilterBond(
                                bondTypeId: TransactionTypeEnum.debit.id,
                                notApprovedBy: UserTool.getUser().id,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      text: 'تحديث البيانات',
                      icon: Icons.refresh,
                      backgroundColor: Colors.teal,
                      onPressed: () async {
                        controller.pageDataPagnationController3.refreshItems(
                          (page, limit) => controller.filterBonds(
                            FilterBond(
                              page: page,
                              limit: limit,
                              bondTypeId: TransactionTypeEnum.debit.id,
                              notApprovedBy: UserTool.getUser().id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmallScreen = constraints.maxHeight < 500;

                    return isSmallScreen
                        ? FutuerPagnationPageWidget(
                            handelData: (page, limit) => controller.filterBonds(
                              FilterBond(
                                page: page,
                                limit: limit,
                                bondTypeId: TransactionTypeEnum.debit.id,
                                notApprovedBy: UserTool.getUser().id,
                              ),
                            ),
                            cardInfo: (item, index) => CardsBound(
                              bond: item,
                              isShowButtonProvite: true,
                            ),
                            controller: controller.pageDataPagnationController3,
                          )
                        : FuturePaginationTableWidget(
                            handelData: (page, limit) => controller.filterBonds(
                              FilterBond(
                                page: page,
                                limit: limit,
                                bondTypeId: TransactionTypeEnum.debit.id,
                                notApprovedBy: UserTool.getUser().id,
                              ),
                            ),
                            columns: [
                              DataColumn(label: Text('اسم')),
                              DataColumn(label: Text('النوع')),
                              DataColumn(label: Text('المبلغ')),
                              DataColumn(label: Text('التاريخ')),
                              DataColumn(label: Text('الملاحظات')),
                              DataColumn(label: Text('المرفقات')),
                              DataColumn(label: Text('موافقة')),
                            ],
                            buildRow: (item, index) => DataRow(
                              cells: [
                                DataCell(Text(item.title.toString())),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        TransactionTypeEnum.credit.id ==
                                                item.bondTypeId
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color:
                                            TransactionTypeEnum.credit.id ==
                                                item.bondTypeId
                                            ? Colors.green
                                            : Colors.red,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        TransactionTypeEnum.credit.id ==
                                                item.bondTypeId
                                            ? "ايداع"
                                            : "سحب",
                                        style: TextStyle(
                                          color:
                                              TransactionTypeEnum.credit.id ==
                                                  item.bondTypeId
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    AppTool.formatMoney(item.amount.toString()),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.createdAt != null
                                        ? AppTool.formatDate(
                                            DateTime.parse(
                                              item.createdAt.toString(),
                                            ),
                                          )
                                        : '',
                                  ),
                                ),
                                DataCell(Text(item.note.toString())),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      Get.dialog(
                                        Scaffold(
                                          backgroundColor: Colors.black
                                              .withOpacity(0.5),
                                          appBar: AppBar(
                                            title: const Text('المرفقات'),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            elevation: 0,
                                          ),
                                          body: DisplayGroubFile(
                                            files: item.filePaths!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.file_upload,
                                          color:
                                              (item.filePaths ?? []).isNotEmpty
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          (item.filePaths ?? []).isNotEmpty
                                              ? 'عرض المرفقات'
                                              : 'لا يوجد مرفقات',
                                          style: TextStyle(
                                            color:
                                                (item.filePaths ?? [])
                                                    .isNotEmpty
                                                ? Colors.blue
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  UserTool.checkPer(PermeationEnum.approveBond)
                                      ? (!item.hasUserApproved(
                                              UserTool.getUser().id ?? 0,
                                            )
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  showConfirmationDialog(
                                                    title: "تأكيد",
                                                    message:
                                                        "هل انت متاكد من الموافقة على السند",
                                                    onConfirm: () async {
                                                      await controller
                                                          .proviteBound(
                                                            item.id!,
                                                          );
                                                      controller
                                                          .pageDataPagnationController3
                                                          .refreshItems(
                                                            (
                                                              page,
                                                              limit,
                                                            ) => controller.filterBonds(
                                                              FilterBond(
                                                                notApprovedBy:
                                                                    UserTool.getUser()
                                                                        .id,
                                                                page: page,
                                                                limit: limit,
                                                                bondTypeId:
                                                                    TransactionTypeEnum
                                                                        .debit
                                                                        .id,
                                                              ),
                                                            ),
                                                          );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue[600],
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text('موافقة'),
                                              )
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'تمت الموافقة',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                            controller: controller.pageDataPagnationController3,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
