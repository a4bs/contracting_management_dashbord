import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/bound_creadit_screen.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/bound_debit_screen.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/bound_draft_screen.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/convert_btween_box.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/customer_baid_bound_screen.dart';
import 'package:contracting_management_dashbord/screen/bound_screens/bound_sub_screen/provid_on_debit_bound_screen.dart';
import 'package:contracting_management_dashbord/widget/app_bar_widget.dart';
import 'package:contracting_management_dashbord/widget/tab_bar_widght.dart';
import 'package:flutter/material.dart';

class BoundIndexScreen extends StatelessWidget {
  const BoundIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: " الحركة الماليه"),
      body: TabBarWidget(
        tabs: ["الايداع", "السحب", "مسودة", "التسديد", "التحويل", "الموافقة"],
        children: [
          BoundCreaditScreen(),
          BoundDebitScreen(),
          BoundDraftScreen(),
          CustomerBaidBoundScreen(),
          ConvertBtweenBox(),
          ProvidOnDebitBoundScreen(),
        ],
        length: 6,
      ),
    );
  }
}
