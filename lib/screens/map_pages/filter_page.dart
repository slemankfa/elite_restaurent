import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Data {
  Data({required this.x, required this.y});
  final double x;
  final double y;
}

class FilterPge extends StatefulWidget {
  const FilterPge({super.key});

  @override
  State<FilterPge> createState() => _FilterPgeState();
}

class _FilterPgeState extends State<FilterPge> {
  // RangeCo
  @override
  void initState() {
    super.initState();
    //  _rangeController = RangeController(
    //  start: _values.start,
    //  end: _values.end);
  }

  @override
  void dispose() {
    //  _rangeController.dispose();
    super.dispose();
  }

  final double _min = 2.0;
  final double _max = 10.0;
  final SfRangeValues _values = const SfRangeValues(4.0, 8.0);

  final List<Data> chartData = <Data>[
    Data(x: 2.0, y: 2.5),
    Data(x: 3.0, y: 3.4),
    Data(x: 4.0, y: 2.8),
    Data(x: 5.0, y: 1.6),
    Data(x: 6.0, y: 2.3),
    Data(x: 7.0, y: 2.5),
    Data(x: 8.0, y: 2.9),
    Data(x: 9.0, y: 3.8),
    Data(x: 10.0, y: 3.7),
  ];

  int distance = 10;
  bool _showBars = true;

  int? _selectedPeopleCountIndex = 0;

  List<String> resevedPeopleCountList = [
    "All",
    "4 Stars",
    "3 Stars",
    "2 Stars",
    "1 Stars",
    "as,djasjdhha"
  ];

  List<String> selectedReportList = [];

  @override
  Widget build(BuildContext context) {
    final items = resevedPeopleCountList
        .map((animal) => MultiSelectItem<String>(animal, animal))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Maximum Distance",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "$distance KM",
                        textAlign: TextAlign.end,
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 9,
                ),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Colors.white,
                    activeTrackColor: Styles.mainColor,
                    inactiveTrackColor: Colors.grey.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: distance.toDouble(),
                    max: 100.0,
                    min: 5.0,
                    onChanged: (double newValue) {
                      setState(() {
                        distance = newValue.round();
                      });
                    },
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Pricing",
                  style: Styles.mainTextStyle.copyWith(
                    color: Styles.grayColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                RichText(
                  text: TextSpan(
                    text: '10 ',
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'JOD',
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic)),
                      TextSpan(
                          text: ' - ',
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic)),
                      TextSpan(
                        text: '1000 ',
                        style: Styles.mainTextStyle.copyWith(
                            color: Styles.mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'JOD',
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic)),
                    ],
                  ),
                ),
                Center(
                  child: SfRangeSelector(
                    min: _min,
                    max: _max,
                    interval: 2,
                    showLabels: false,
                    showTicks: true,
                    enableTooltip: false,
                    initialValues: _values,
                    child: SizedBox(
                      height: 130,
                      child: SfCartesianChart(
                        margin: const EdgeInsets.all(0),
                        primaryXAxis: NumericAxis(
                          minimum: _min,
                          maximum: _max,
                          isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(isVisible: false),
                        plotAreaBorderWidth: 0,
                        series: <ColumnSeries<Data, double>>[
                          ColumnSeries<Data, double>(
                              color: const Color.fromARGB(255, 126, 184, 253),
                              dataSource: chartData,
                              xValueMapper: (Data sales, int index) => sales.x,
                              yValueMapper: (Data sales, int index) => sales.y)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      // flex: 10,
                      child: Text(
                        "Remind me through SMS",
                        style: Styles.mainTextStyle
                            .copyWith(fontSize: 16, color: Styles.grayColor),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Styles.mainColor, width: 1),
                      ),
                      child: Theme(
                        // color: Colors.white,
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          // shape:  CircleBorder(),
                          value: _showBars,

                          checkColor: Styles.mainColor,
                          // side: BorderSide(
                          //   color: Styles.mainColor,
                          // ),
                          overlayColor: MaterialStateProperty.all(Colors.white),
                          focusColor: Colors.white,
                          tristate: false,
                          // activeColor:Colors.white ,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showBars = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Rating",
                  style: Styles.mainTextStyle.copyWith(
                    color: Styles.grayColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 5.0,
                  children: List<Widget>.generate(
                    resevedPeopleCountList.length,
                    (int index) {
                      return Container(
                        // width: 81,
                        child: ChoiceChip(
                          backgroundColor: Colors.white,
                          selectedColor: _selectedPeopleCountIndex == index
                              ? Styles.listTileBorderColr
                              : Colors.white,
                          // selectedColor: ,
                          side: BorderSide(
                            width: _selectedPeopleCountIndex == index ? 2 : 1,
                            color: _selectedPeopleCountIndex == index
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
                                  visible: index != 0,
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  resevedPeopleCountList[index],
                                  style: Styles.mainTextStyle.copyWith(
                                      color: _selectedPeopleCountIndex == index
                                          ? Styles.resturentNameColor
                                          : Styles.grayColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          selected: _selectedPeopleCountIndex == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedPeopleCountIndex =
                                  selected ? index : null;
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Cuisine",
                  style: Styles.mainTextStyle.copyWith(
                    color: Styles.grayColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // MultiSelectChipField(
                //   items: items,
                //   scroll: false,
                //   decoration: const BoxDecoration(),

                //   showHeader: false,
                //   icon: const Icon(Icons.check, color: Styles.mainColor,),
                //   // onTap: (vall) {
                //   //   // _selectedAnimals = values;
                //   //   // print(values);
                //   //   setState(() {});
                //   // },
                // ),

                MultiSelectChip(
                  resevedPeopleCountList,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      selectedReportList = selectedList;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  const MultiSelectChip(this.reportList,
      {super.key, required this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = [];
  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.reportList) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          selectedColor: selectedChoices.contains(item)
              ? Styles.listTileBorderColr
              : Colors.white,
          // selectedColor: ,
          side: BorderSide(
            width: selectedChoices.contains(item) ? 2 : 1,
            color: selectedChoices.contains(item)
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
                  visible: selectedChoices.contains(item),
                  child: const Icon(
                    Icons.check,
                    color: Styles.mainColor,
                  ),
                ),
                Text(
                  item,
                  style: Styles.mainTextStyle.copyWith(
                      color: selectedChoices.contains(item)
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
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
          selected: selectedChoices.contains(item),
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
