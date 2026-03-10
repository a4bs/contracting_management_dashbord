import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveMasterDetail<T> extends StatefulWidget {
  final Future<List<T>?> Function() handelData; // Fetch data
  final Widget Function(T item, int index) cardInfo; // Display each item
  final PaginationController<T> controller;

  final Widget Function(BuildContext context, T item) detailBuilder;
  final Widget? emptyDetail;
  final double breakpoint;
  final String? title;
  final List<Widget>? actions;
  final Widget? header;
  final bool showAppBar;
  final Widget? footer;
  final Widget? Function()? defaultWidget;
  final T? selectedItem;
  final Function(T item)? onClickOnItem;

  const ResponsiveMasterDetail({
    super.key,
    required this.handelData,
    required this.cardInfo,
    required this.controller,
    required this.detailBuilder,
    this.emptyDetail,
    this.breakpoint = 600,
    this.title,
    this.actions,
    this.header,
    this.footer,
    this.defaultWidget,
    this.onClickOnItem,
    this.selectedItem,
    this.showAppBar = true,
  });

  @override
  State<ResponsiveMasterDetail<T>> createState() =>
      _ResponsiveMasterDetailState<T>();
}

class _ResponsiveMasterDetailState<T> extends State<ResponsiveMasterDetail<T>> {
  T? _selectedItem;
  bool _isMasterVisible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.items.isEmpty &&
        !widget.controller.showLoader.value) {
      widget.controller.fetchData(widget.handelData);
    }

    return Obx(() {
      if (widget.controller.showLoader.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.lightPrimary),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= widget.breakpoint) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      );
    });
  }

  Widget _buildTabletLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;
        return Scaffold(
          appBar: !isDesktop || !widget.showAppBar
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: false,
                      title: Text(
                        widget.title ?? '',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              setState(() {
                                _isMasterVisible = !_isMasterVisible;
                              });
                            },
                            child: Icon(
                              _isMasterVisible ? Icons.menu_open : Icons.menu,
                              color: const Color(0xFF64748B),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      actions: widget.actions,
                    ),
                  ),
                ),

          body: Row(
            children: [
              // Master Pane (Sidebar)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                width: _isMasterVisible ? 400 : 0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isMasterVisible
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(4, 0),
                          ),
                        ]
                      : null,
                ),
                child: Obx(
                  () =>
                      widget.controller.items.isEmpty &&
                          widget.header == null &&
                          widget.footer == null
                      ? const SizedBox.shrink()
                      : ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.centerRight,
                            maxWidth: 400,
                            child: SizedBox(
                              width: 400,
                              child: Column(
                                children: [
                                  if (widget.header != null)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: widget.header!,
                                    ),
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async => await widget
                                          .controller
                                          .fetchData(widget.handelData),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        itemCount:
                                            widget.controller.items.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 4),
                                        itemBuilder: (context, index) {
                                          final item =
                                              widget.controller.items[index];
                                          final isSelected =
                                              _selectedItem == item;
                                          return AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFFEFF6FF)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: Colors.blue
                                                          .withOpacity(0.3),
                                                    )
                                                  : null,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onTap: () {
                                                  setState(() {
                                                    _selectedItem = item;
                                                  });
                                                  widget.onClickOnItem?.call(
                                                    item,
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  child: widget.cardInfo(
                                                    item,
                                                    index,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (widget.footer != null)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: widget.footer!,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              // Detail Pane
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(4, 0),
                      ),
                    ],
                  ),
                  child: () {
                    final defaultW = widget.defaultWidget?.call();
                    // Check if defaultWidget has the 'empty_default' key
                    final isEmptyDefault =
                        defaultW is Container &&
                        defaultW.key == const ValueKey('empty_default');
                    final shouldShowDefault =
                        defaultW != null && !isEmptyDefault;

                    if (_selectedItem == null && shouldShowDefault) {
                      return defaultW;
                    } else if (_selectedItem == null) {
                      return widget.emptyDetail ??
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dashboard_customize_outlined,
                                  size: 64,
                                  color: const Color(
                                    0xFF94A3B8,
                                  ).withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'اختر عنصرًا لعرض التفاصيل',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xFF64748B),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                    } else {
                      return KeyedSubtree(
                        key: ValueKey(_selectedItem),
                        child: widget.detailBuilder(
                          context,
                          _selectedItem as T,
                        ),
                      );
                    }
                  }(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: Column(
        children: [
          if (widget.header != null) widget.header!,
          if (widget.defaultWidget != null)
            Builder(
              builder: (context) {
                final defaultW = widget.defaultWidget!.call();
                if (defaultW is Container &&
                    defaultW.key == const ValueKey('empty_default')) {
                  return const SizedBox.shrink();
                }
                // Wrap in SizedBox with fixed height or flexible to avoid unbounded height error
                // Since this is mobile, we'll give it a fixed height relative to screen or make it flexible
                return SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      0.7, // 70% of screen height
                  child: defaultW ?? const SizedBox.shrink(),
                );
              },
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  await widget.controller.fetchData(widget.handelData),
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.controller.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = widget.controller.items[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            widget.onClickOnItem?.call(item);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  backgroundColor: const Color(0xFFF8FAFC),
                                  appBar: AppBar(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    iconTheme: const IconThemeData(
                                      color: Color(0xFF64748B),
                                    ),
                                    title: const Text(
                                      'التفاصيل',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  body: widget.detailBuilder(context, item),
                                ),
                              ),
                            );
                          },
                          child: widget.cardInfo(item, index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }
}
