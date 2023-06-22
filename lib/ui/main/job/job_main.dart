import 'package:flutter/material.dart';
import 'package:friday_v/ui/main/job/job.dart';
import 'package:friday_v/ui/main/job/todo.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:friday_v/widgets/button_tab.dart';

class JobMain extends StatefulWidget {
  const JobMain({Key? key}) : super(key: key);

  @override
  _JobMainState createState() => _JobMainState();
}

class _JobMainState extends State<JobMain> with TickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: _selectedIndex == 0 ? 'Todo' : 'Jobs',
        appBar: AppBar(),
        // widgets:<Widget>[
        //     IconButton(
        //       icon: Icon(
        //         Icons.settings,
        //         color: Colors.black,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => CreatePdfWidget(),
        //             ));              },
        //     )
        //   ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(
                        color: primaryLite.withOpacity(0.2), width: 2.0),
                    borderRadius: BorderRadius.circular(12.0)),
                child: ButtonsTabBar(
                  radius: 8,
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  backgroundColor: primaryColor,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(
                    color: primaryColor,
                    fontFamily: "RedHatDisplay",
                  ),
                  labelStyle: const TextStyle(
                      color: white,
                      fontFamily: "RedHatDisplay",
                      fontWeight: FontWeight.w700),
                  tabs: const [
                    Tab(
                      text: "ToDo",
                    ),
                    Tab(
                      text: "Jobs",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    // dummy(),dummy(),dummy()
                    Todo(), Job()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listener() {
    setState(() {
      _selectedIndex = _controller.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    _controller.addListener(_listener);
  }
}
