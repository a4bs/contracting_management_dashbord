import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contracting_management_dashbord/controller/project_controller/project_controller.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';

class ProjectInfoScreen extends GetView<ProjectController> {
  const ProjectInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getProjectById(
        controller.selectedProject.value.id.toString(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Use the selected project directly effectively or updating it from snapshot if your logic requires
        // Here we assume controller.selectedProject is updated or we use the snapshot data if available
        // For now, let's use OBX or the controller's value if not null.
        return Obx(() {
          final project = controller.selectedProject.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(project),
                const SizedBox(height: 24),
                _buildFinancialSection(project),
                const SizedBox(height: 24),
                _buildStatsGrid(project),
                const SizedBox(height: 24),
                _buildUnitsProgress(project),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildHeaderSection(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.apartment,
              size: 32,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name ?? 'بدون اسم',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (project.projectType?.name != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.lightOutlineVariant,
                          ),
                        ),
                        child: Text(
                          project.projectType!.name!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.lightOutline,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (project.isEnable == 1)
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (project.isEnable == 1) ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (project.isEnable == 1)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSection(ProjectModel project) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            title: 'الرصيد الحالي',
            value: '${project.balance ?? 0}',
            icon: Icons.account_balance_wallet,
            color: AppColors.lightPrimary,
            isCurrency: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            title: 'التكلفة الكلية',
            value: '${project.cost ?? 0}',
            icon: Icons.monetization_on,
            color: AppColors.lightTertiary, // Use a distinct color
            isCurrency: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightSurfaceDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل مالية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatDetail(
                'إجمالي الإيداع',
                '${project.credit ?? 0}',
                Colors.green,
              ),
              _buildStatDetail(
                'إجمالي السحب',
                '${project.debit ?? 0}',
                Colors.red,
              ),
              _buildStatDetail(
                'الصافي',
                '${project.balance ?? 0}',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsProgress(ProjectModel project) {
    final int sold = project.soldUnitsCount ?? 0;
    final int total = project.unitsCount ?? 0;
    final double progress = (total > 0) ? sold / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightSurfaceDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'حالة الوحدات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnSurface,
                ),
              ),
              Text(
                '$sold / $total',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.lightPrimary,
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تم بيع ${(progress * 100).toStringAsFixed(1)}% من إجمالي الوحدات',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: AppColors.lightOutline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isCurrency = false,
  }) {
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
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.lightOutline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnSurface,
            ),
          ),
          if (isCurrency)
            const Text(
              'د.ع',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: AppColors.lightOutline,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: AppColors.lightOutline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
