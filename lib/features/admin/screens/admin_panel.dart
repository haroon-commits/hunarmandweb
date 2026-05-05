import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colors.dart';
import '../../../core/models/bank_details.dart';
import '../../../core/models/course.dart';
import '../../../core/models/donation_option.dart';
import '../../../core/models/ticker_item.dart';
import '../../../core/utils/responsive.dart';
import '../widgets/manage_courses_tab.dart';
import '../widgets/manage_gallery_tab.dart';
import '../widgets/manage_donations_tab.dart';
import '../widgets/manage_bank_tab.dart';
import '../widgets/manage_ticker_tab.dart';

class AdminPanel extends StatefulWidget {
  final Function(int) onNavigate;
  final List<Course> courses;
  final List<DonationOption> donationOptions;
  final BankDetails bankDetails;
  final bool isLoggedIn;
  final List<TickerItem> tickerItems;
  final Function(bool) onLogin;
  final Function(List<TickerItem>) onUpdateTicker;
  final VoidCallback onUpdate;

  const AdminPanel({
    super.key,
    required this.onNavigate,
    required this.courses,
    required this.donationOptions,
    required this.bankDetails,
    required this.isLoggedIn,
    required this.tickerItems,
    required this.onLogin,
    required this.onUpdateTicker,
    required this.onUpdate,
  });

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _passController = TextEditingController();
  int _activeTab = 0; // 0: Courses, 1: Gallery, 2: Donations, 3: Bank Details

  void _login() {
    if (_passController.text == 'admin123') {
      widget.onLogin(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid Password')));
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    if (!widget.isLoggedIn) {
      return Scaffold(
        backgroundColor: kLightBg,
        body: Center(
          child: Container(
            width: isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 20),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 60, color: kDarkGreen),
                const SizedBox(height: 20),
                Text(
                  'Admin Login',
                  style: GoogleFonts.merriweather(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () => widget.onNavigate(0),
                  child: const Text(
                    'Back to Website',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => widget.onLogin(false),
          ),
        ],
      ),
      drawer: isMobile
          ? Drawer(
              child: Container(color: kLightBg, child: _sidebarContent()),
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar (only on desktop)
          if (!isMobile)
            Container(width: 250, color: kLightBg, child: _sidebarContent()),
          // Content
          Expanded(child: _buildActiveTab()),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    switch (_activeTab) {
      case 0:
        return ManageCoursesTab(
          courses: widget.courses,
          onUpdate: widget.onUpdate,
        );
      case 1:
        return ManageGalleryTab(
          onUpdate: widget.onUpdate,
        );
      case 2:
        return ManageDonationsTab(
          donationOptions: widget.donationOptions,
          onUpdate: widget.onUpdate,
        );
      case 3:
        return ManageBankTab(
          bankDetails: widget.bankDetails,
          onUpdate: widget.onUpdate,
        );
      case 4:
        return ManageTickerTab(
          tickerItems: widget.tickerItems,
          onUpdateTicker: widget.onUpdateTicker,
        );
      default:
        return ManageCoursesTab(
          courses: widget.courses,
          onUpdate: widget.onUpdate,
        );
    }
  }

  Widget _sidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _sidebarItem(0, Icons.book, 'Manage Courses'),
        _sidebarItem(1, Icons.image, 'Manage Gallery'),
        _sidebarItem(2, Icons.favorite, 'Manage Donations'),
        _sidebarItem(3, Icons.account_balance, 'Bank Details'),
        _sidebarItem(4, Icons.campaign, 'Announcement Ticker'),
        const Spacer(),
        ListTile(
          leading: const Icon(Icons.arrow_back),
          title: const Text('Exit Admin'),
          onTap: () => widget.onNavigate(0),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sidebarItem(int index, IconData icon, String title) {
    bool active = _activeTab == index;
    bool isMobile = Responsive.isMobile(context);
    return ListTile(
      leading: Icon(icon, color: active ? kDarkGreen : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: active ? kDarkGreen : Colors.black87,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: active,
      onTap: () {
        setState(() => _activeTab = index);
        if (isMobile) Navigator.pop(context);
      },
    );
  }
}
