import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_details_page.dart';
import 'package:pds_front/app/pages/dashboard/users/users_page.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:pds_front/app/widgets/drawer/drawer_menu_item.dart';
import 'package:pds_front/app/pages/public/about_screen.dart';
import 'package:pds_front/app/pages/public/help_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_create_page.dart';
import 'package:pds_front/app/pages/public/public_home_page.dart';
import 'package:pds_front/app/pages/login/admin_login_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/posts_page.dart';

import '../../widgets/drawer/drawer_widget.dart';

class RouteManager {
  static const String dashboardPage = '/admin';
  static const String createPost = '/admin/posts/create';
  static const String postsList = '/admin/posts';
  static const String postDetails = '/admin/posts/:id';

  static const String adminLogin = '/admin/login';

  //Public routes
  static const String homePublic = '/';
  static const String about = '/about';
  static const String help = '/help';

  static const String postCardDetails = '/postCardDetails';

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
      //Dashboard routes
      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          child: Scaffold(
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
                        title: "Usuários",
                        icon: Icons.textsms_sharp,
                        route: "/admin/users"),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: "/admin/users",
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const UsersPage()),
          ),
          GoRoute(
            path: postsList,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const PostsPage()),
          ),
          GoRoute(
            path: createPost,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const CreatePostPage()),
          ),
          GoRoute(
            path: postDetails,
            pageBuilder: (context, state) => NoTransitionPage(
              child: PostDetailsPage(
                postId: state.pathParameters['id']!,
              ),
            ),
          ),
        ],
      ),

      GoRoute(
        path: adminLogin,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const AdminLoginScreen()),
      ),

      GoRoute(
        path: homePublic,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const PublicHomePage()),
      ),
      GoRoute(
        path: about,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const AboutUsScreen()),
      ),
      GoRoute(
        path: help,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const HelpScreen()),
      ),
    ],
  );
}
