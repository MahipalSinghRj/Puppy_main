import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/job_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class Job extends StatefulWidget {
  const Job({Key? key}) : super(key: key);

  @override
  _JobState createState() => _JobState();
}

class _JobState extends State<Job> {

// Future<List<Session>?>? jobSessionFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          FutureBuilder<List<Session>?>(
            future: JobService().getSessions(), // async work
            // future: jobSessionFuture, // async work
            builder: (BuildContext context, AsyncSnapshot<List<Session>?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                  default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No Jobs Available"),
                          ],
                        )),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh:_refresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          padding: const EdgeInsets.only(bottom: 64.0, top: 8),
                          itemBuilder: (BuildContext context, int index) {
                            Session dd = snapshot.data![index];
                            return ItemCard(
                                dd, snapshot.data!.length, index, context);
                          },
                        ),
                      );
                    }
                  }
              }
            },
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.NewJob_).then((value) => setState(() {}));
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.5),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                )
              ], //BoxShadow,
              borderRadius: BorderRadius.circular(8.0)),
          child: SvgView(
            color: white,
            size: 24,
            icon: SvgIcon.plus,
          ),
        ),
      ),
    );
  }

  Widget ItemCard(Session dd, int count, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.JobDetail_,
            arguments: {'localDetail': dd}).whenComplete(() {
          setState(() {});
        });
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    dd.orgName,
                    style: title.copyWith(
                        color: secondaryDark, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  dotIndicator(
                    indicate: dd.inBreak == "0" ? green : primaryDark,
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                dd.siteAddress,
                style: body2.copyWith(
                    color: menuDisabled, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                dd.typeName,
                style: body2.copyWith(
                    color: secondaryDark, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    SvgIcon.clock,
                    color: primaryColor,
                    height: 16,
                    width: 16,
                    matchTextDirection: true,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    Utils().String_toDT(dd.visitDate) + ' ' + dd.inTime,
                    style: body2.copyWith(
                        color: secondaryDark, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dd.siteRep,
                    style: body2.copyWith(
                        color: menuDisabled, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    JobService().getSessions();
  }

  // getSessions() async {
  //   jobSessionFuture = await JobService().getSessions().then((value) {
  //     setState(() {
  //
  //     });
  //   });
  // }
  Future<void> _refresh()  async {
    JobService().getSessions().then((value) {
      setState(() {

      });
    });
  }
}
