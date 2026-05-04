import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'core/constants/colors.dart';
import 'core/models/bank_details.dart';
import 'core/models/course.dart';
import 'core/models/donation_option.dart';
import 'core/models/gallery_item.dart';
import 'core/models/ticker_item.dart';
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
import 'core/utils/url_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
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
  // One scroll controller per page so each IndexedStack page scrolls independently
  final Map<int, ScrollController> _scrollControllers = {
    for (int i = 0; i <= 6; i++) i: ScrollController()
  };
  int _currentPageIndex = 0; // will be updated in initState from URL
  bool _isAdminLoggedIn = false;

  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'AI Master',
      subtitles: ['Practical AI skills for real income.'],
      icon: Icons.smart_toy,
      courseType: 'Online',
      locationDetail: 'Zoom / Google Meet',
      registrationLink: '',
      queryLink: 'https://wa.me/923138840971',
      description:
          'I know you feel basic regarding your productivity, starts with learning online.',
      duration: '3 Months | 12 Weeks',
      schedule: '4 Days a Week (Mon-Thu)',
      price: 'Rs. 12,000',
      orderNumber: '01',
      remainingSeats: '5 Seats Left',
    ),
    Course(
      id: '2',
      title: 'Graphic Design',
      subtitles: ['Professional design skills.'],
      icon: Icons.brush,
      courseType: 'Physical',
      locationDetail: 'SCO Software Tech Park, Mirpur',
      registrationLink: '',
      queryLink: 'https://wa.me/923138840971',
      description:
          'Learn complete graphic design have best for the family and globally.',
      duration: '3 Months | 12 Weeks',
      schedule: '4 Days a Week (Mon-Thu)',
      price: 'Rs. 12,000',
      orderNumber: '02',
      remainingSeats: '',
    ),
    Course(
      id: '3',
      title: 'E-commerce',
      subtitles: ['Build and scale online stores.'],
      icon: Icons.shopping_bag,
      courseType: 'Physical',
      locationDetail: 'SCO Software Tech Park, Mirpur',
      registrationLink: '',
      queryLink: 'https://wa.me/923138840971',
      description:
          'Learn tools techniques for stores using Shopify and dropshipping models.',
      duration: '2 Months | 8 Weeks',
      schedule: '4 Days a Week (Mon-Thu)',
      price: 'Rs. 10,000',
      orderNumber: '03',
      remainingSeats: '',
    ),
    Course(
      id: '4',
      title: 'Freelancing',
      subtitles: ['Work with global clients.'],
      icon: Icons.language,
      courseType: 'Online',
      locationDetail: 'Discord / Live Sessions',
      queryLink: 'https://wa.me/923138840971',
      description:
          'Master the art of freelancing and work with international clients.',
      duration: '2 Months | 8 Weeks',
      schedule: 'Weekends (Sat-Sun)',
      price: 'Rs. 8,000',
      orderNumber: '04',
      remainingSeats: 'Only 2 Seats Left',
    ),
  ];

  final List<DonationOption> _donationOptions = [
    DonationOption(
      id: '1',
      title: 'Learning Kit',
      price: 'Rs. 2,000',
      description:
          'Provide a student with essential learning materials, internet access for a month, and software subscriptions.',
      icon: Icons.card_giftcard,
    ),
    DonationOption(
      id: '2',
      title: 'Sponsor a Skill',
      price: 'Rs. 5,000',
      description:
          'Cover the cost of a complete short-term module (e.g., Graphic Design Basics) for one deserving student.',
      icon: Icons.menu_book,
      isPopular: true,
    ),
    DonationOption(
      id: '3',
      title: 'Full Scholarship',
      price: 'Rs. 15,000',
      description:
          'Sponsor a student\'s entire journey from beginner to job-ready professional, including mentorship.',
      icon: Icons.group,
    ),
  ];

  final BankDetails _bankDetails = BankDetails(
    accountName: 'Hunarmand Kashmir Trust',
    accountNo: '',
    bankName: '',
    branchCode: '',
  );

  List<TickerItem> _tickerItems = [
    TickerItem(
      message: 'Admissions Open for Batch 5! Secure your seat today.',
      screenIndex: 2, // Courses
    ),
    TickerItem(
      message: 'Special discounts for early birds available until June 1st.',
      screenIndex: 2,
    ),
    TickerItem(
      message: 'Join our WhatsApp community for daily updates.',
      link: 'https://wa.me/923138840971',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Read the page from the URL hash AFTER Flutter is fully mounted.
    // This is the reliable way to do it on Flutter web.
    final page = getUrlPage();
    if (page != 0) {
      _currentPageIndex = page;
    }
  }

  @override
  void dispose() {
    for (final c in _scrollControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _navigateTo(int index) {
    // Scroll the target page to top
    final ctrl = _scrollControllers[index];
    if (ctrl != null && ctrl.hasClients) {
      ctrl.jumpTo(0);
    }
    setState(() => _currentPageIndex = index);
    setUrlPage(index); // keep URL in sync so reload stays on this page
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Builder(
        builder: (context) => Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(context),
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
                  activeIndex: _currentPageIndex,
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
            _drawerItem(context, 0, 'Home', Icons.home),
            _drawerItem(context, 1, 'About Us', Icons.info),
            _drawerItem(context, 2, 'Courses', Icons.book),
            _drawerItem(context, 3, 'Gallery', Icons.photo_library),
            _drawerItem(context, 4, 'Contact', Icons.contact_mail),
            const Divider(color: Colors.white24),
            _drawerItem(context, 5, 'Donate', Icons.favorite, isSpecial: true),
            _drawerItem(context, 6, 'Admin', Icons.admin_panel_settings),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    int index,
    String title,
    IconData icon, {
    bool isSpecial = false,
  }) {
    bool active = _currentPageIndex == index;
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

  // IndexedStack keeps ALL pages alive simultaneously.
  // This means:
  //  - AdminPanel never resets its active tab when you navigate away and back
  //  - GalleryPage keeps its Firestore stream alive — no re-fetch needed
  //  - Each page scrolls independently via its own ScrollController
  Widget _buildBody() {
    return IndexedStack(
      index: _currentPageIndex,
      children: [
        LandingPage(
          onNavigate: _navigateTo,
          courses: _courses,
          scrollController: _scrollControllers[0]!,
        ),
        AboutPage(
          onNavigate: _navigateTo,
          scrollController: _scrollControllers[1]!,
        ),
        CoursesPage(
          onNavigate: _navigateTo,
          courses: _courses,
          scrollController: _scrollControllers[2]!,
        ),
        GalleryPage(
          onNavigate: _navigateTo,
          scrollController: _scrollControllers[3]!,
        ),
        ContactPage(
          onNavigate: _navigateTo,
          scrollController: _scrollControllers[4]!,
        ),
        DonatePage(
          onNavigate: _navigateTo,
          donationOptions: _donationOptions,
          bankDetails: _bankDetails,
          scrollController: _scrollControllers[5]!,
        ),
        AdminPanel(
          onNavigate: _navigateTo,
          courses: _courses,
          donationOptions: _donationOptions,
          bankDetails: _bankDetails,
          isLoggedIn: _isAdminLoggedIn,
          tickerItems: _tickerItems,
          onLogin: (status) => setState(() => _isAdminLoggedIn = status),
          onUpdateTicker: (items) => setState(() { _tickerItems = items; }),
          onUpdate: () => setState(() {}),
        ),
      ],
    );
  }
}
