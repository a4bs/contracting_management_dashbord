import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/widget/master_detail.dart';
import 'package:flutter/material.dart';

class DisplayGroubFile extends StatelessWidget {
  final List<String> files;
  DisplayGroubFile({super.key, required this.files});
  final PaginationController<String> controller =
      PaginationController<String>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveMasterDetail(
      handelData: () async => files,
      cardInfo: (item, index) {
        if (item.toLowerCase().endsWith('.pdf')) {
          return const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red);
        }
        return Image.network(
          '${item.toString().replaceAll('http', 'http')}',
          height: 100,
          width: 100,
        );
      },
      controller: controller,
      showAppBar: false,
      detailBuilder: (context, data) {
        return SingleChildScrollView(
          child: Container(
            child: Image.network(
              data.toString().replaceAll('http', 'http'),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
