import 'package:flutter/material.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/utils/colors.dart';

class MapBottomSheet extends StatelessWidget {
  final Site marker;
  final OrganizationModel? organization;
  final Function(int, String, Site) onPressed;

  const MapBottomSheet({Key? key, required this.marker, required this.onPressed, required this.organization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            height: 4,
            width: 48,
            decoration: BoxDecoration(color: secondaryLite, borderRadius: BorderRadius.circular(4.0)),
          ),
          Text(
            organization!.orgName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: secondaryDark, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            marker.siteAddress!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: secondaryDark.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  onPressed(int.parse(marker.siteId!), marker.siteAddress!, marker);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
                  child: Center(
                      child: Text(
                    "Start Work?",
                    style: button.copyWith(color: white, fontWeight: FontWeight.w700),
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
