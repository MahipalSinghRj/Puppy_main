
import 'package:flutter/material.dart';

class DropListModel {
  DropListModel(this.listOptionItems);

  final List<OptionItem> listOptionItems;
}
//version: 4.0.0+1
class OptionItem {
  final String id;
  final String title;

  OptionItem({required this.id, required this.title});
}

//Dropdown widget
class SelectDropList extends StatefulWidget {
  final OptionItem itemSelected;
  final DropListModel dropListModel;
  final Function(OptionItem) onOptionSelected;

  SelectDropList(this.itemSelected, this.dropListModel, this.onOptionSelected);

  @override
  _SelectDropListState createState() =>
      _SelectDropListState(itemSelected, dropListModel);
}

class _SelectDropListState extends State<SelectDropList>
    with SingleTickerProviderStateMixin {
  OptionItem optionItemSelected;
  final DropListModel dropListModel;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  _SelectDropListState(this.optionItemSelected, this.dropListModel);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: new BoxDecoration(
              borderRadius: isShow ? BorderRadius.vertical(bottom: Radius.circular(0.0), top: Radius.circular(10.0)):BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        this.isShow = !this.isShow;
                        _runExpandCheck();
                        setState(() {
                          // print("state set");
                        });
                      },
                      child: Text(
                        optionItemSelected.title, style: TextStyle(fontSize: 16.0),
                      ),
                    )),
                Align(
                  alignment: Alignment(1, 0),
                  child: Icon(
                    isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: _buildDropListOptions(
                      dropListModel.listOptionItems, context))),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List<OptionItem> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(OptionItem item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 1)),
                ),
                child: Text(item.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        onTap: () {
          this.optionItemSelected = item;
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item);
        },
      ),
    );
  }
}
