import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_details_page.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_edit_page.dart';
import 'package:pds_front/app/pages/dashboard/users/users_create_page.dart';
import 'package:pds_front/app/pages/dashboard/users/users_page.dart';
import 'package:pds_front/app/pages/public/public_post_details_page.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:pds_front/app/widgets/drawer/drawer_menu_item.dart';
import 'package:pds_front/app/pages/public/about_screen.dart';
import 'package:pds_front/app/pages/public/help_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/post_create_page.dart';
import 'package:pds_front/app/pages/public/public_home_page.dart';
import 'package:pds_front/app/pages/dashboard/admin_login_screen.dart';
import 'package:pds_front/app/pages/dashboard/posts/posts_page.dart';
import 'package:pds_front/app/widgets/public_header.dart';
import 'package:pds_front/app/widgets/public_footer.dart';

import '../../widgets/drawer/drawer_widget.dart';

class RouteManager {
  static const String dashboardPage = '/admin';
  static const String createPost = '/admin/posts/create';
  static const String updatePost = '/admin/posts/:id/edit';
  static const String postsList = '/admin/posts';
  static const String postDetails = '/admin/posts/:id';

  static const String adminLogin = '/admin/login';

  static const String usersCreate = '/admin/users/create';
  static String editPostPath(String id) => '/admin/posts/$id/edit';
  static String postDetailsPath(String id) => '/admin/posts/$id';

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

      if (isLogged && currentUri.contains('/admin/login')) {
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
            path: '/admin/users/create',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CreateUserPage()),
          ),
          GoRoute(
            path: updatePost,
            pageBuilder: (context, state) => NoTransitionPage(
                child: EditPostPage(post: state.extra as PostModel)),
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

      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          child: Scaffold(
            backgroundColor: const Color(0xFF171821),
            body: Column(
              children: [
                PublicHeader(
                  currentPath: state.uri.path,
                  onSearchChanged: (p) {
                    context.go(RouteManager.homePublic, extra: {'search': p});
                  },
                ),
                Expanded(child: child),
                const PublicFooter(),
              ],
            ),
          ),
        ),
        routes: [
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
          GoRoute(
            path: '/post/:id',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: PublicPostDetailsPage(postId: postId),
              );
            },
          ),
        ],
      ),
    ],
  );
}
