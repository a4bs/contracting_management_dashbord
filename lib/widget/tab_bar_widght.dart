import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabBarWidget extends StatelessWidget {
  List<String> tabs;
  List<Widget> children;
  int length;
  TabBarWidget({
    super.key,
    required this.tabs,
    required this.children,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: length,
        child: Column(
          children: [
            // TabBar Container مع تصميم جميل
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.darkOnPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightSurface,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightPrimary,
                      AppColors.lightPrimary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightPrimary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.lightOnPrimary,
                unselectedLabelColor: const Color.fromARGB(255, 245, 245, 245),
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                tabs: tabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
            // TabBarView
            Expanded(child: TabBarView(children: children)),
          ],
        ),
      ),
    );
  }
}
