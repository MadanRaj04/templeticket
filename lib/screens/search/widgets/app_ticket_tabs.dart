import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';

class AppTicketTabs extends StatefulWidget {
  final String firstTab;
  final String secondTab;

  const AppTicketTabs({
    Key? key,
    required this.firstTab,
    required this.secondTab,
  }) : super(key: key);

  @override
  _AppTicketTabsState createState() => _AppTicketTabsState();
}

class _AppTicketTabsState extends State<AppTicketTabs> {
  bool _isFirstTabSelected = true;

  void _toggleTabs() {
    setState(() {
      _isFirstTabSelected = !_isFirstTabSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppStyles.ticketTabColor,
      ),
      child: Row(
        children: [
          AppTabs(
            tabText: widget.firstTab,
            tabColor: _isFirstTabSelected,
            onTap: () {
              if (!_isFirstTabSelected) {
                _toggleTabs();
              }
            },
          ),
          AppTabs(
            tabText: widget.secondTab,
            tabColor: !_isFirstTabSelected,
            onTap: () {
              if (_isFirstTabSelected) {
                _toggleTabs();
              }
            },
          ),
        ],
      ),
    );
  }
}

class AppTabs extends StatelessWidget {
  const AppTabs({
    Key? key,
    required this.tabText,
    required this.tabColor,
    required this.onTap,
  }) : super(key: key);

  final String tabText;
  final bool tabColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        width: size.width * .44,
        decoration: BoxDecoration(
          color: tabColor ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(tabColor ? 0 : 50),
            right: Radius.circular(tabColor ? 50 : 0),
          ),
        ),
        child: Center(child: Text(tabText)),
      ),
    );
  }
}
