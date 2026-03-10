import 'package:contracting_management_dashbord/constant/app_pages.dart';
import 'package:contracting_management_dashbord/controller/auth_controller/auth_controller.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = UserTool.getUser().username ?? 'المستخدم';

    return DefaultTabController(
      length: AppPages.pagesAdmin.length,
      child: Scaffold(
        appBar: _buildAppBar(username),
        body: TabBarView(
          children: AppPages.pagesAdmin
              .map((e) => e['screen'] as Widget)
              .toList(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String username) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A3D5C), Color(0xFF0C5A88), Color(0xFF0C79A4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x440C79A4),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Title Row ───
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    // Logo icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7AD5E),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x55D7AD5E),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.business_center_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // System name + username
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'نظام البسيط',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFFD7AD5E),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Logout button
                    _LogoutButton(),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFD7AD5E).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFD7AD5E).withOpacity(0.65),
                    width: 1,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(30),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  fontFamily: 'Cairo',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
                tabs: AppPages.pagesAdmin.map((e) {
                  return Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(e['icon'] as IconData, size: 16),
                        const SizedBox(width: 6),
                        Text(e['title'] as String),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
//  Logout Button with hover effect
// ──────────────────────────────────────────────────
class _LogoutButton extends StatefulWidget {
  const _LogoutButton();

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: 'تسجيل الخروج',
        child: GestureDetector(
          onTap: () => AuthController().logout(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _hovered
                  ? Colors.white.withOpacity(0.18)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(_hovered ? 0.4 : 0.15),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: _hovered ? const Color(0xFFD7AD5E) : Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'خروج',
                  style: TextStyle(
                    color: _hovered ? const Color(0xFFD7AD5E) : Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
