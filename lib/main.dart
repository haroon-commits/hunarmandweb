import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

import 'core/constants/colors.dart';
import 'core/models/ticker_item.dart';
import 'core/services/app_data_service.dart';
import 'core/utils/responsive.dart';
import 'features/about/screens/about_page.dart';
import 'features/admin/screens/admin_panel.dart';
import 'features/contact/screens/contact_page.dart';
import 'features/courses/screens/courses_page.dart';
import 'features/donate/screens/donate_page.dart';
import 'features/gallery/screens/gallery_page.dart';
import 'features/home/screens/landing_page.dart';
import 'shared/widgets/ticker_widget.dart';
import 'shared/widgets/top_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  runApp(const HunarmandKashmirApp());
}

class HunarmandKashmirApp extends StatefulWidget {
  const HunarmandKashmirApp({super.key});

  @override
  State<HunarmandKashmirApp> createState() => _HunarmandKashmirAppState();
}

class _HunarmandKashmirAppState extends State<HunarmandKashmirApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<int, ScrollController> _scrollControllers = {
    for (int i = 0; i <= 6; i++) i: ScrollController(),
  };

  bool _isAdminLoggedIn = false;

  // Ticker items — loaded from Firestore, with sensible defaults.
  List<TickerItem> _tickerItems = [
    TickerItem(
      message: 'Admissions Open for Batch 5! Secure your seat today.',
      screenIndex: 2,
    ),
    TickerItem(
      message: 'Join our WhatsApp community for daily updates.',
      link: 'https://wa.me/923138840971',
    ),
  ];

  final _service = AppDataService();
  StreamSubscription<List<TickerItem>>? _tickerSub;

  StatefulNavigationShell? _shell;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // Live-update ticker from Firestore
    _tickerSub = _service.tickerStream().listen((items) {
      if (mounted && items.isNotEmpty) {
        setState(() => _tickerItems = items);
      }
    });

    _router = GoRouter(
      initialLocation: '/',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            _shell = navigationShell;
            return _buildShell(context, navigationShell);
          },
          branches: [
            // 0 — Home
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => LandingPage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[0]!,
                ),
              ),
            ]),
            // 1 — About
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/about',
                builder: (context, state) => AboutPage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[1]!,
                ),
              ),
            ]),
            // 2 — Courses (fetches from Firestore internally)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/courses',
                builder: (context, state) => CoursesPage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[2]!,
                ),
              ),
            ]),
            // 3 — Gallery
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/gallery',
                builder: (context, state) => GalleryPage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[3]!,
                ),
              ),
            ]),
            // 4 — Contact
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/contact',
                builder: (context, state) => ContactPage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[4]!,
                ),
              ),
            ]),
            // 5 — Donate (fetches from Firestore internally)
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/donate',
                builder: (context, state) => DonatePage(
                  onNavigate: _navigateTo,
                  scrollController: _scrollControllers[5]!,
                ),
              ),
            ]),
            // 6 — Admin
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/admin',
                builder: (context, state) => AdminPanel(
                  onNavigate: _navigateTo,
                  isLoggedIn: _isAdminLoggedIn,
                  tickerItems: _tickerItems,
                  onLogin: (status) =>
                      setState(() => _isAdminLoggedIn = status),
                  onUpdateTicker: (items) =>
                      setState(() => _tickerItems = items),
                  onUpdate: () => setState(() {}),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tickerSub?.cancel();
    for (final c in _scrollControllers.values) {
      c.dispose();
    }
    _router.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index < 0 || index > 6) return;
    final ctrl = _scrollControllers[index];
    if (ctrl != null && ctrl.hasClients) ctrl.jumpTo(0);
    _shell?.goBranch(index, initialLocation: index == _shell!.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hunarmand Kashmir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kDarkGreen,
          primary: kDarkGreen,
          secondary: kAccentOrange,
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      routerConfig: _router,
    );
  }

  Widget _buildShell(
    BuildContext context,
    StatefulNavigationShell navigationShell,
  ) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, navigationShell.currentIndex),
      body: Column(
        children: [
          if (_tickerItems.isNotEmpty)
            TickerWidget(items: _tickerItems, onNavigate: _navigateTo),
          Container(
            color: kNavGreen,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 20 : 80,
              vertical: 20,
            ),
            child: TopNavBar(
              onNavigate: _navigateTo,
              activeIndex: navigationShell.currentIndex,
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, int activeIndex) {
    return Drawer(
      child: Container(
        color: kDarkGreen,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: kDarkGreen),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_white.png',
                      height: 60,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.school,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'HUNARMAND KASHMIR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _drawerItem(context, 0, 'Home', Icons.home, activeIndex),
            _drawerItem(context, 1, 'About Us', Icons.info, activeIndex),
            _drawerItem(context, 2, 'Courses', Icons.book, activeIndex),
            _drawerItem(
                context, 3, 'Gallery', Icons.photo_library, activeIndex),
            _drawerItem(
                context, 4, 'Contact', Icons.contact_mail, activeIndex),
            const Divider(color: Colors.white24),
            _drawerItem(
              context, 5, 'Donate', Icons.favorite, activeIndex,
              isSpecial: true,
            ),
            _drawerItem(
                context, 6, 'Admin', Icons.admin_panel_settings, activeIndex),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    int index,
    String title,
    IconData icon,
    int activeIndex, {
    bool isSpecial = false,
  }) {
    final active = activeIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSpecial
            ? kAccentOrange
            : (active ? kAccentOrange : Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSpecial
              ? kAccentOrange
              : (active ? kAccentOrange : Colors.white),
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        _navigateTo(index);
        Navigator.pop(context);
      },
    );
  }
}
