// private navigators
import 'package:ai_wrapper_app/routing/scaffold_nested.dart';
import 'package:ai_wrapper_app/screens/chat_history_screen.dart';
import 'package:ai_wrapper_app/screens/chat_screen.dart';
import 'package:ai_wrapper_app/screens/new_screens.dart';
import 'package:ai_wrapper_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');
final _shellNavigatorDKey = GlobalKey<NavigatorState>(debugLabel: 'shellD');

// the one and only GoRouter instance
final goRouter = GoRouter(
  initialLocation: '/a',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => AuthenticationScreen(),
    // ),

    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        // first branch (A)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/a',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ChatScreen(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) => ChatScreen(),
                ),
              ],
            ),
          ],
        ),
        // second branch (B)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/b',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChatHistoryScreen(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'de/:chatId',
                  builder: (context, state) {
                    final String? chatId = state.pathParameters['chatId'];
                    return ChatScreen(
                      chatId: chatId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/c',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NewsScreen(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const ChatHistoryScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/d',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsScreen(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const ChatHistoryScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
