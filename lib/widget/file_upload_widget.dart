import 'package:contracting_management_dashbord/controller/app_controller/file_upload_controller.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class FileUploadWidget extends StatelessWidget {
  final String name;
  final String uploadUrl;
  final String label;
  final List<String>? defaultLinks;
  final List<FormFieldValidator<List<String>>>? validator;
  const FileUploadWidget({
    super.key,
    required this.name,
    required this.uploadUrl,
    this.label = "إرفاق ملف",
    this.defaultLinks,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FileUploadController(), tag: uploadUrl);

    // Load default links once when widget first mounts
    if (defaultLinks != null && defaultLinks!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setDefaultLinks(defaultLinks!);
      });
    }

    // Ensure we handle List<String> type for the field
    return FormBuilderField<List<String>>(
      name: name,
      validator: FormBuilderValidators.compose(validator ?? []),
      builder: (FormFieldState<List<String>> field) {
        // Sync controller changes to form field
        controller.onFilesChanged = (links) {
          field.didChange(links);
        };

        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            // errorText: field.errorText,
            contentPadding: EdgeInsets.zero,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Default Links Section ──────────────────────────
                Obx(() {
                  if (controller.defaultLinks.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الملفات الحالية",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.defaultLinks
                            .map(
                              (link) => _buildDefaultLinkItem(link, controller),
                            )
                            .toList(),
                      ),
                      const Divider(height: 24),
                    ],
                  );
                }),

                // ── Upload Area + New Files ─────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive layout: Row for wide screens, Column for narrow
                    bool isWide = constraints.maxWidth > 500;

                    Widget fileList = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الملفات المرفوعة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.fileItems.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  "لم يتم اختيار ملفات بعد",
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.fileItems.length,
                            itemBuilder: (context, index) {
                              final item = controller.fileItems[index];
                              return _buildFileItem(item, controller);
                            },
                          );
                        }),
                      ],
                    );

                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drop/Upload Area
                        Container(
                          width: isWide ? 200 : double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: InkWell(
                            onTap: () =>
                                controller.pickAndUploadFile(uploadUrl),
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.file_upload_outlined,
                                    size: 32,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "اضغط لرفع الملفات",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "PDF, Images",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                if (field.errorText != null)
                                  Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isWide) const SizedBox(width: 24),
                        if (!isWide) const SizedBox(height: 24),

                        // File List Area
                        isWide ? Expanded(child: fileList) : fileList,
                      ],
                    );
                  },
                ),
                if (controller.errorMessage.isNotEmpty)
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultLinkItem(String link, FileUploadController controller) {
    final fileName = link.split('/').last.split('?').first;
    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    const double size = 80;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Preview square ────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isPdf
                ? Container(
                    width: size,
                    height: size,
                    color: Colors.red.shade50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 28,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            fileName,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.red.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : Image.network(
                    link,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: size,
                        height: size,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, _) => Container(
                      width: size,
                      height: size,
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
          ),

          // ── Delete button ────────────────────────────────
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: () => controller.removeDefaultLink(link),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 13, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(FileUploadItem item, FileUploadController controller) {
    bool isPdf = item.name.toLowerCase().endsWith('.pdf');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
              color: isPdf ? Colors.red : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Details & Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => controller.removeFile(item),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Obx(() {
                  double progress = item.progress.value;
                  String status = item.status.value;
                  Color color = AppColors.lightPrimary;
                  if (status == 'error') color = Colors.red;

                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: status == 'pending' ? 0.0 : progress,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatSize(item.size),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            status == 'success'
                                ? "Completed"
                                : status == 'error'
                                ? "Failed"
                                : "${(progress * 100).toInt()}%",
                            style: TextStyle(
                              color: status == 'error'
                                  ? Colors.red
                                  : Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }
}
