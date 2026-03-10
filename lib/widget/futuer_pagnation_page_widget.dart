import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';
// The controller that manages the state

class FutuerPagnationPageWidget<T> extends StatefulWidget {
  final Widget Function(T item, int index) cardInfo; // Display each item
  final Future<List<T>?> Function(int page, int limit) handelData; // Fetch data
  final PageDataPagnationController<T> controller;
  FutuerPagnationPageWidget({
    super.key,
    required this.cardInfo,
    required this.handelData,
    required this.controller,
  });

  @override
  State<FutuerPagnationPageWidget<T>> createState() =>
      _FutuerPagnationPageWidgetState<T>();
}

class _FutuerPagnationPageWidgetState<T>
    extends State<FutuerPagnationPageWidget<T>> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.page.value = 1;
      widget.controller.limit.value = 10;
      widget.controller.items.clear();
      widget.controller.fetchData(widget.handelData);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          widget.controller.page.value < widget.controller.limit.value) {
        widget.controller.page.value++;
        widget.controller.fetchDatamore(widget.handelData);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use GetX controller to manage state

    return Obx(
      () => RefreshIndicator(
        onRefresh: () async {
          await widget.controller.refreshItems(widget.handelData);
        },
        child: Column(
          children: [
            if (widget.controller.showLoader.value) LinearProgressIndicator(),
            if (widget.controller.items.isEmpty)
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Text(
                          'لا يوجد معلومات',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .blue, // Use AppColors.lightPrimary here if needed
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.no_sim_outlined,
                          color: Colors
                              .blue, // Use AppColors.lightPrimary here if needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.controller.items.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap:
                      true, // This is important to make the list scrollable in a column
                  itemCount: widget.controller.items.length,
                  itemBuilder: (context, index) {
                    T item = widget.controller.items[index];
                    return widget.cardInfo(
                      item,
                      index,
                    ); // Pass both item and index to cardInfo
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
