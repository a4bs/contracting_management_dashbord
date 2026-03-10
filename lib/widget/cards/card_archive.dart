import 'package:contracting_management_dashbord/model/archive/archive_model.dart';
import 'package:contracting_management_dashbord/tool/app_tool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardArchive extends StatelessWidget {
  final ArchiveModel archive;
  final Function(ArchiveModel)? onEdit;
  final Function(ArchiveModel)? onDelete;

  const CardArchive({
    super.key,
    required this.archive,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Archive Number & Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (archive.archiveNumber != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${archive.archiveNumber}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                if (archive.date != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppTool.formatDate(
                          DateTime.tryParse(archive.date!) ?? DateTime.now(),
                        ),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: context.theme.primaryColor,
                    ),
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) {
                        onEdit!(archive);
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!(archive);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        if (onEdit != null)
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('تعديل'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('حذف'),
                              ],
                            ),
                          ),
                      ];
                    },
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (archive.title != null)
                  Text(
                    archive.title ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                if (archive.details != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    archive.details ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Footer Info (Project, Unit, Type)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (archive.project?.name != null)
                      _buildChip(
                        context,
                        icon: Icons.business_outlined,
                        label: archive.project!.name!,
                        color: Colors.blue,
                      ),
                    if (archive.unit?.name != null)
                      _buildChip(
                        context,
                        icon: Icons.home_outlined,
                        label: archive.unit!.name!,
                        color: Colors.orange,
                      ),
                    if (archive.archiveType?.name != null)
                      _buildChip(
                        context,
                        icon: Icons.folder_open_outlined,
                        label: archive.archiveType?.name ?? "",
                        color: Colors.purple,
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

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
