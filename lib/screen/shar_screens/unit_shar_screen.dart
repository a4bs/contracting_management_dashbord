import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/screen/shar_screens/customer_shar_screen.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitSharScreen extends StatelessWidget {
  final UnitModel unit;
  const UnitSharScreen({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Softer background

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 16), // Reduced spacing
            if (unit.percentage != null) ...[
              _buildPercentageSection(),
              const SizedBox(height: 16),
            ],
            _buildCustomersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12), // Reduced radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Softer shadow
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12), // Reduced padding
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withOpacity(0.08), // Softer opacity
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_work_outlined,
              size: 28, // Reduced from 48
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name ?? 'وحدة بدون اسم',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16, // Reduced from 24
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightOnSurface,
                  ),
                ),
                if (unit.project?.name != null)
                  Text(
                    unit.project!.name!,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12, // Reduced from 16
                      color: AppColors.lightOutline,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.lightOutline.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          _buildHeaderStat('التكلفة', '${unit.cost ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: AppColors.lightOutline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16, // Reduced from 24
            fontWeight: FontWeight.bold,
            color: AppColors.lightPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightPrimary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.percent, color: AppColors.lightPrimary, size: 20),
          const SizedBox(width: 12),
          Text(
            unit.percentage?.name ?? 'نسبة',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
          const Spacer(),
          Text(
            '${unit.percentage?.percent ?? 0}%',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: const Text(
            'العملاء',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14, // Reduced from 20
              fontWeight: FontWeight.bold,
              color: AppColors.lightOutline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (unit.customers == null || unit.customers!.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 32,
                  color: AppColors.lightOutline.withOpacity(0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'لا يوجد عملاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.lightOutline.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: unit.customers!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final customer = unit.customers![index];
              return InkWell(
                onTap: () =>
                    Get.to(() => CustomerSharScreen(customer: customer)),
                child: Container(
                  padding: const EdgeInsets.all(12), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (customer.name ?? 'C')[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name ?? 'بدون اسم',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.lightOnSurface,
                                height: 1.2,
                              ),
                            ),
                            if (customer.phone1 != null)
                              Text(
                                customer.phone1!,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: AppColors.lightOutline,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (customer.debit != null && customer.debit! > 0)
                            _buildMiniStat(
                              'مدين',
                              '${customer.debit}',
                              Colors.red,
                            ),
                          if (customer.credit != null && customer.credit! > 0)
                            _buildMiniStat(
                              'دائن',
                              '${customer.credit}',
                              Colors.green,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: color.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
