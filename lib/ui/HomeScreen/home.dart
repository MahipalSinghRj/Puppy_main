import 'package:flutter/material.dart';
import 'package:friday_v/provider/bottom_provider.dart';
import 'package:friday_v/ui/TeamScreen/team.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:provider/provider.dart';
import '../BottomNavigationBar/bottom_item.dart';
import 'dashboard_screen.dart';
import '../JobsScreen/jobs_main.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late BottomProvider _bottomProvider;

  @override
  void initState() {
    super.initState();
    _bottomProvider = BottomProvider();
    _bottomProvider.toggle(0);
  }

  final List<Widget> _widgetOptions = [
    const Dashboard(),
    const JobsMain(),
    const Teams(),
    const Center(child: Text('Stat Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<BottomProvider>(builder: (context, index, child) {
          return _widgetOptions.elementAt(index.index);
        }),
        // drawer: navigationDrawer(),
        bottomNavigationBar: Container(
          height: 64.0,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 2.0, color: borderColor),
            ),
          ),
          child: Consumer<BottomProvider>(
            builder: (context, index, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      index.toggle(0);
                    },
                    child: BottomItem(
                      isSelected: index.index == 0 ? true : false,
                      icon: SvgIcon.home,
                      menu: "Home",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      index.toggle(1);
                    },
                    child: BottomItem(
                      isSelected: index.index == 1 ? true : false,
                      icon: SvgIcon.project,
                      menu: "Jobs",
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      index.toggle(2);
                    },
                    child: BottomItem(
                      isSelected: index.index == 2 ? true : false,
                      icon: SvgIcon.teams,
                      menu: "Team",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      index.toggle(3);
                    },
                    child: BottomItem(
                      isSelected: index.index == 3 ? true : false,
                      icon: SvgIcon.chartline,
                      menu: "Stats",
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
