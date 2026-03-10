import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/app_controller/page_data_pagnation_controller.dart';

class FuturePaginationTableWidget<T> extends StatefulWidget {
  final List<DataColumn> columns; // Table columns
  final DataRow Function(T item, int index) buildRow; // Map item to DataRow
  final Future<List<T>?> Function(int page, int limit) handelData; // Fetch data
  final PageDataPagnationController<T> controller;

  FuturePaginationTableWidget({
    super.key,
    required this.columns,
    required this.buildRow,
    required this.handelData,
    required this.controller,
  });

  @override
  State<FuturePaginationTableWidget<T>> createState() =>
      _FuturePaginationTableWidgetState<T>();
}

class _FuturePaginationTableWidgetState<T>
    extends State<FuturePaginationTableWidget<T>> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.page.value = 1;
      widget.controller.limit.value = 10;
      widget.controller.items.clear();
      widget.controller.fetchData(widget.handelData);
    });
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () async {
          await widget.controller.refreshItems(widget.handelData);
        },
        child: Column(
          children: [
            if (widget.controller.showLoader.value)
              const LinearProgressIndicator(),
            if (widget.controller.items.isEmpty &&
                !widget.controller.showLoader.value)
              Expanded(
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Text(
                            'لا يوجد معلومات',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.no_sim_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.controller.items.isNotEmpty)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Scrollbar(
                      controller: _verticalScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: Scrollbar(
                          controller: _horizontalScrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  cardTheme: CardThemeData(
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  dataTableTheme: DataTableThemeData(
                                    headingRowColor: MaterialStateProperty.all(
                                      const Color(0xFFFAFAFA),
                                    ),
                                    dataRowColor:
                                        MaterialStateProperty.resolveWith<
                                          Color?
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.selected,
                                          )) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08);
                                          }
                                          if (states.contains(
                                            MaterialState.hovered,
                                          )) {
                                            return Colors.grey.withOpacity(
                                              0.04,
                                            );
                                          }
                                          return null;
                                        }),
                                    headingTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF424242),
                                      fontSize: 13,
                                    ),
                                    dataTextStyle: const TextStyle(
                                      color: Color(0xFF212121),
                                      fontSize: 13,
                                    ),
                                    dividerThickness: 0.5,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.08),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: DataTable(
                                    headingRowHeight: 52,
                                    dataRowMinHeight: 52,
                                    dataRowMaxHeight: 52,
                                    columnSpacing: 20,
                                    horizontalMargin: 20,
                                    columns: widget.columns,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                    rows: widget.controller.items
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          int index = entry.key;
                                          T item = entry.value;
                                          return widget.buildRow(item, index);
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Pagination controls
            if (widget.controller.items.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                    left: BorderSide(color: Colors.grey.shade200),
                    right: BorderSide(color: Colors.grey.shade200),
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'عرض ${widget.controller.page.value} من ${widget.controller.limit.value}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        _buildPaginationButton(
                          icon: Icons.chevron_right,
                          onPressed: widget.controller.page.value > 1
                              ? () {
                                  widget.controller.page.value--;
                                  widget.controller.items.clear();
                                  widget.controller.fetchData(
                                    widget.handelData,
                                  );
                                }
                              : null,
                        ),
                        const SizedBox(width: 8),
                        _buildPaginationButton(
                          icon: Icons.chevron_left,
                          onPressed:
                              widget.controller.page.value <
                                  widget.controller.limit.value
                              ? () {
                                  widget.controller.page.value++;
                                  widget.controller.items.clear();
                                  widget.controller.fetchData(
                                    widget.handelData,
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null
              ? Colors.grey.shade300
              : Colors.grey.shade200,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: onPressed != null ? Colors.black87 : Colors.grey.shade400,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        splashRadius: 20,
      ),
    );
  }
}
