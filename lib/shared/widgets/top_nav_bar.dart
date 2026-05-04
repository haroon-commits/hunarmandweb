import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/colors.dart';

class TopNavBar extends StatelessWidget {
  final Function(int) onNavigate;
  final int activeIndex;
  const TopNavBar({super.key, required this.onNavigate, this.activeIndex = 0});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Row(
      children: [
        if (isMobile)
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        GestureDetector(
          onTap: () => onNavigate(0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/Hunarmand_Kashmir_Eng4x.png',
                height: isMobile ? 35 : 50,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        const Spacer(),
        if (!isMobile)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _navLink('Home', index: 0),
                  _navLink('About Us', index: 1),
                  _navLink('Courses', index: 2),
                  _navLink('Gallery', index: 3),
                  _navLink('Contact', index: 4),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => onNavigate(5),
                    child: _navButton(
                      'Donate',
                      Icons.favorite,
                      activeIndex == 5 ? kAccentOrange : Colors.transparent,
                      Colors.white,
                      true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => onNavigate(2),
                    child: _navButton(
                      'Apply Now',
                      null,
                      Colors.white,
                      kDarkGreen,
                      false,
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          GestureDetector(
            onTap: () => onNavigate(5),
            child: _navButton(
              'Donate',
              Icons.favorite,
              kAccentOrange,
              Colors.white,
              false,
            ),
          ),
        ],
      ],
    );
  }

  Widget _navLink(String title, {int? index}) {
    bool active = index != null && activeIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: index != null ? () => onNavigate(index) : null,
        child: Text(
          title,
          style: TextStyle(
            color: active ? kAccentOrange : Colors.white,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _navButton(
    String title,
    IconData? icon,
    Color bgColor,
    Color textColor,
    bool outline,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: outline
            ? Border.all(color: Colors.white.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: bgColor == kAccentOrange ? Colors.white : kAccentOrange,
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
