import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/task.dart';
import 'package:friday_v/provider/ui/todo.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../../widgets/svg_view.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo> {
  late TodoProvider jobs;

  Future<dynamic> _refresh() {
    return jobs.getTaskList().then((user) {
      setState(() => jobs.tasks = user);
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    jobs = Provider.of<TodoProvider>(context, listen: false);
    jobs.getTaskList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    jobs = Provider.of<TodoProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: jobs.loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refresh,
                key: _refreshIndicatorKey,
                child: jobs.tasks.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text("No Jobs Available")],
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: jobs.tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, Routes.detailPage, arguments: {'arg': jobs.tasks[index]})
                                      .then((value) {
                                    setState(() {
                                      jobs.getTaskList();
                                    });
                                  }),
                              child: todoCard(jobs.tasks[index]));
                        },
                      ),
              ),
      ),
    );
  }

  String status(status) {
    String stat = '';
    switch (status) {
      case 'notStarted':
        stat = 'Pending';
        break;
      case 'completed':
        stat = 'Completed';
        break;
      default:
        stat = '';
        break;
    }
    return stat;
  }

  Container todoCard(TaskModel task) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          color: white, border: Border.all(color: borderColor, width: 2.0), borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: status(task.status) == 'Completed' ? green.withOpacity(0.1) : primaryDark.withOpacity(0.1)),
                child: Text(
                  status(task.status),
                  style: body2.copyWith(
                      color: status(task.status) == 'Completed' ? green : primaryDark, fontWeight: FontWeight.w500),
                ),
              ),
              Text(Utils().String_toDTA(task.createdDateTime),
                  style: body2.copyWith(color: menuDisabled, fontWeight: FontWeight.w500))
            ],
          ),
          spacer(8),
          Text(task.title.trim(), style: title.copyWith(color: secondaryDark, fontWeight: FontWeight.w800)),
          spacer(8),
          Visibility(
            visible: task.body!.content.toString().trim() == '' ? false : true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.body!.content.toString().trim(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: body1.copyWith(color: menuDisabled, fontWeight: FontWeight.w500),
                ),
                spacer(8),
              ],
            ),
          ),
          Row(
            children: [
              Visibility(
                visible: task.recurrence!.pattern!.type == "" ? false : true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgView(
                      color: black,
                      icon: SvgIcon.redo,
                      size: 16,
                    ),
                    spacer(8.0),
                    Text(task.recurrence!.pattern!.type.toString().capitalizeFirstOfEach,
                        style: body2.copyWith(color: menuDisabled, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                task.importance == 'high' ? SvgIcon.star_filled : SvgIcon.star_outline,
                height: 24,
                width: 24,
                matchTextDirection: true,
              )
            ],
          ),
        ],
      ),
    );
  }
}
