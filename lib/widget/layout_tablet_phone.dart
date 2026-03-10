import 'package:flutter/material.dart';

class LayoutTabletPhone extends StatelessWidget {
  final List<Widget> children;
  const LayoutTabletPhone({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (isMobile)
                children[i]
              else if (children[i] is Flexible)
                children[i]
              else
                Expanded(child: children[i]),
              if (i < children.length - 1)
                isMobile
                    ? const SizedBox(height: 16)
                    : const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}
