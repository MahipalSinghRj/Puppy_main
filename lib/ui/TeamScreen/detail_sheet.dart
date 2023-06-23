import 'package:flutter/material.dart';
import 'package:friday_v/model/team.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:provider/provider.dart';

class DetailSheet extends StatefulWidget {
  final TeamModel teamModel;

  const DetailSheet({Key? key, required this.teamModel}) : super(key: key);

  @override
  DetailSheetState createState() => DetailSheetState();
}

class DetailSheetState extends State<DetailSheet> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final token = userData.post.odataContext;
    final userID = userData.post.id;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              height: 4,
              width: 48,
              decoration: BoxDecoration(color: secondaryLite, borderRadius: BorderRadius.circular(4.0)),
            ),
          ),
          userData.loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.post.displayName,
                          style: title.copyWith(color: black, fontWeight: FontWeight.w700),
                        ),
                        const Space(size: 8),
                        Text(userData.post.jobTitle,
                            style: body1.copyWith(color: subTextColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(56),
                      child: FadeInImage(
                        image: NetworkImage(
                          "https://graph.microsoft.com/v1.0/users/$userID/photo/\$value",
                          headers: {
                            "Authorization": "Bearer $token",
                          },
                        ),
                        imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset('assets/images/404.png');
                        },
                        placeholder: const AssetImage("assets/images/404.png"),
                        height: 56,
                        width: 56,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.teamModel.orgName,
                style: title.copyWith(color: black, fontWeight: FontWeight.w700),
              ),
              status(widget.teamModel.inBreak)
            ],
          ),
          const Space(size: 4),
          Text(widget.teamModel.siteAddress, style: body1.copyWith(color: subTextColor, fontWeight: FontWeight.w500)),
          const Space(size: 16),
          Text(widget.teamModel.typeName, style: body1.copyWith(color: black, fontWeight: FontWeight.w500)),
          const Space(size: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              timings("Time In", widget.teamModel.inTime),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey,
              ),
              timings("Duration", widget.teamModel.totalTime)
            ],
          ),
          const Space(size: 16),
        ],
      ),
    );
  }

  Column timings(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: body1.copyWith(color: subTextColor, fontWeight: FontWeight.w500),
        ),
        const Space(size: 8.0),
        Text(
          time,
          style: body1.copyWith(color: black, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Container status(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: id == '0' ? green.withOpacity(0.1) : primaryDark.withOpacity(0.1)),
      child: Text(
        id == '0' ? "Active" : "Inactive",
        style: body2.copyWith(color: id == '0' ? green : primaryDark, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    user.getUserByID(context, widget.teamModel.userId);
  }
}
