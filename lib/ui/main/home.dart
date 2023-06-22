import 'package:flutter/material.dart';
import 'package:friday_v/provider/bottom_provider.dart';
import 'package:friday_v/ui/main/team.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:provider/provider.dart';
import 'dash.dart';
import 'job/job_main.dart';

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
    Dashboard(),
    const JobMain(),
    Teams(),
    //geofence(),
    const Center(
      child: Text('Stat Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ),
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

class BottomItem extends StatelessWidget {
  final bool isSelected;
  final String menu;
  final String icon;

  const BottomItem({Key? key, required this.isSelected, required this.menu, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgView(
            color: isSelected ? primaryColor : menuDisabled,
            icon: icon,
            padding: 4,
          ),
          isSelected
              ? Text(menu, style: const TextStyle(fontSize: 16.0, color: primaryColor, fontWeight: FontWeight.bold))
              : Container()
        ]));
  }
}
