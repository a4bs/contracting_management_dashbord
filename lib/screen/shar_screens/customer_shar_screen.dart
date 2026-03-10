import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomerSharScreen extends StatelessWidget {
  final CustomerModel customer;
  const CustomerSharScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'تفاصيل العميل',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildContactInfo(),
            const SizedBox(height: 16),
            _buildFinancialStats(),
            if (customer.files != null && customer.files!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildFilesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.lightPrimary.withOpacity(0.1),
            child: Text(
              (customer.name ?? 'C')[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            customer.name ?? 'بدون اسم',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (customer.idCard != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ID: ${customer.idCard}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.lightOutline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightSurfaceDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الاتصال',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOutline,
            ),
          ),
          const SizedBox(height: 12),
          if (customer.phone1 != null)
            _buildInfoRow(Icons.phone, 'هاتف 1', customer.phone1!),
          if (customer.phone2 != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            _buildInfoRow(Icons.phone_iphone, 'هاتف 2', customer.phone2!),
          ],
          if (customer.address != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            _buildInfoRow(Icons.location_on, 'العنوان', customer.address!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.lightPrimary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: AppColors.lightOutline,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'مدين',
            '${customer.debit ?? 0}',
            Colors.red,
            Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'دائن',
            '${customer.credit ?? 0}',
            Colors.green,
            Icons.arrow_upward,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: color),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'المرفقات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOutline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: customer.files!.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final file = customer.files![index];
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightSurfaceDim),
                ),
                child: Center(
                  child: file.toLowerCase().endsWith('.pdf')
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text('PDF', style: TextStyle(fontSize: 10)),
                          ],
                        )
                      : const Icon(
                          Icons.image,
                          color: AppColors.lightOutline,
                          size: 32,
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
