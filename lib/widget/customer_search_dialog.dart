import 'dart:async';
import 'package:contracting_management_dashbord/controller/customer_controller/customer_controller.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSearchDialog extends StatefulWidget {
  const CustomerSearchDialog({Key? key}) : super(key: key);

  @override
  State<CustomerSearchDialog> createState() => _CustomerSearchDialogState();
}

class _CustomerSearchDialogState extends State<CustomerSearchDialog> {
  final CustomerController _customerController = Get.find<CustomerController>();
  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCustomers(''); // Load initial data
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchCustomers(query);
    });
  }

  Future<void> _searchCustomers(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final filter = CustomerFilterModel(name: query.isNotEmpty ? query : null);
      filter.limit = 20;
      final results = await _customerController.getCustomerByFilter(filter);
      if (mounted) {
        setState(() {
          _customers = results ?? [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'البحث عن عميل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Input
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'اكتب اسم العميل...',
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Results List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _customers.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _customers.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final customer = _customers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Text(
                              customer.name?.substring(0, 1) ?? 'ع',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            customer.name ?? 'بدون اسم',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: customer.phone1 != null
                              ? Text(
                                  customer.phone1!,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Get.back(result: customer);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
