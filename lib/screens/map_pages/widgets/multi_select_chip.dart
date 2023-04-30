import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';

import '../../../models/filter_item_model.dart';

class MultiSelectChip extends StatefulWidget {
  final List<FilterItemModel> itemList;
  final Function(List<int>) onSelectionChanged; // +added
  const MultiSelectChip(this.itemList,
      {super.key, required this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<int> selectedChoices = [];
  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.itemList) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          selectedColor: selectedChoices.contains(item.id)
              ? Styles.listTileBorderColr
              : Colors.white,
          // selectedColor: ,
          side: BorderSide(
            width: selectedChoices.contains(item.id) ? 2 : 1,
            color: selectedChoices.contains(item.id)
                ? Styles.listTileBorderColr
                : Styles.midGrayColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          // padding: EdgeInsets.all(8),
          label: SizedBox(
            // width: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: selectedChoices.contains(item.id),
                  child: const Icon(
                    Icons.check,
                    color: Styles.mainColor,
                  ),
                ),
                Text(
                  item.name,
                  style: Styles.mainTextStyle.copyWith(
                      color: selectedChoices.contains(item.id)
                          ? Styles.resturentNameColor
                          : Styles.grayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item.id)
                  ? selectedChoices.remove(item.id)
                  : selectedChoices.add(item.id);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
          selected: selectedChoices.contains(item.id),
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
