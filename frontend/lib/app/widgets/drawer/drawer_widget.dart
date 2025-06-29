import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:pds_front/app/widgets/drawer/drawer_menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pds_front/app/widgets/drawer/drawer_item.dart';

class DrawerWidget extends StatefulWidget {
  final Function(String)? onItemSelected;
  final List<DrawerMenuItem> menuItems;

  const DrawerWidget({super.key, this.onItemSelected, required this.menuItems});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String selectedItem = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF171821),
        border: Border(right: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2F1F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.directions_car_filled,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
                padding: EdgeInsets.zero,
                children: widget.menuItems
                    .map((menuItem) => DrawerItem(
                          title: menuItem.title,
                          icon: menuItem.icon,
                          onTap: () {
                            context.go(menuItem.route);
                          },
                          selected: GoRouterState.of(context).uri.path.contains(menuItem.route),
                        ))
                    .toList()),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Administrador:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName.isNotEmpty ? userName : 'Usuário',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: const Text(
              "Sair",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () async {
              await UserService.logout();
              Router.neglect(context, () {
                context.go(RouteManager.adminLogin);
              });
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
