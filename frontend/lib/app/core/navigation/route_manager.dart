import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:pds_front/app/widgets/drawer/drawer_menu_item.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/pages/dashboard/dashboard_page.dart';
import 'package:pds_front/app/pages/public/about_screen.dart';
import 'package:pds_front/app/pages/public/help_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_card_details.screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_create_page.dart';
import 'package:pds_front/app/pages/public/public_home_page.dart';
import 'package:pds_front/app/pages/splash/splash_screen.dart';
import 'package:pds_front/app/pages/login/admin_login_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/posts_page.dart';

import '../../widgets/drawer/drawer_widget.dart';

class RouteManager {
  static const String dashboardPage = '/admin';
  static const String createPost = '/admin/posts/create';
  static const String postsList = '/admin/posts';

  static const String adminLogin = '/admin/login';

  //Public routes
  static const String homePublic = '/';
  static const String about = '/about';
  static const String help = '/help';

  static const String postCardDetails = '/postCardDetails'; // Corrigido aqui

  static GoRouter router = GoRouter(
    initialLocation: homePublic,
    redirect: (context, state) async {
      final isLogged = await UserService.isLoggedIn();

      final currentUri = state.uri.toString();

      if (!isLogged && currentUri.startsWith('/admin')) {
        return adminLogin;
      }

      if (isLogged && currentUri.contains(adminLogin)) {
        return postsList;
      }

      return null;
    },
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              backgroundColor: const Color(0xFF171821),
              body: Row(
                children: [
                  DrawerWidget(
                    menuItems: [
                      DrawerMenuItem(
                          title: "Postagens",
                          icon: Icons.article,
                          route: RouteManager.postsList),
                      DrawerMenuItem(
                          title: "Teste admin",
                          icon: Icons.textsms_sharp,
                          route: "/admin/teste"),
                    ],
                  ),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            );
          },
          routes: [
            GoRoute(
                path: "/admin/teste",
                builder: (context, state) {
                  return Placeholder();
                }),
            GoRoute(
              path: postsList,
              builder: (context, state) => PostsPage(),
            ),
            GoRoute(
              path: createPost,
              builder: (context, state) => CreatePostPage(),
            ),
          ]),
      GoRoute(
        path: adminLogin,
        builder: (context, state) => AdminLoginScreen(),
      ),

      //Public routes
      GoRoute(
        path: homePublic,
        builder: (context, state) => PublicHomePage(),
      ),
      GoRoute(
        path: about,
        builder: (context, state) => AboutUsScreen(),
      ),
      GoRoute(
        path: help,
        builder: (context, state) => HelpScreen(),
      ),
    ],
  );
}
