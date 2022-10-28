// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/TimeModel.dart';

class GraphPage extends StatefulWidget {
  final String title;
  final Color modeColor;
  final List<TimeModel> graphData;
  const GraphPage(
      {Key? key,
      required this.modeColor,
      required this.graphData,
      required this.title})
      : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  int selectedD = 10;
  @override
  Widget build(BuildContext context) {
    final Color grey =
        Theme.of(context).colorScheme.onSecondary.withOpacity(0.6);
    final TextStyle unselected = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    );
    final TextStyle selected = TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );
    List<double> times = [];
    avg(times);
    double maxy = times.fold<double>(
        0,
        (previousValue, element) =>
            element > previousValue ? element : previousValue);
    if (maxy % 5 != 0) {
      maxy = maxy.toInt() + 1;
    }
    int i = 0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: widget.modeColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Graph"),
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: widget.graphData.isEmpty
              ? Text("Do some solves to see the graph")
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0.w),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: widget.modeColor,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: kElevationToShadow[2],
                              borderRadius: BorderRadius.circular(8.r),
                              color: widget.modeColor,
                            ),
                            height: 32.h,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                                isDense: true,
                                elevation: 3,
                                borderRadius: BorderRadius.circular(12.r),
                                value: selectedD,
                                onChanged: (value) {
                                  setState(() {
                                    selectedD = value!;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length >= 1000,
                                    value: 1000,
                                    child: Text(
                                      "Last 1000",
                                      style: widget.graphData.length >= 1000
                                          ? selected
                                          : unselected,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length >= 500,
                                    value: 500,
                                    child: Text(
                                      "Last 500",
                                      style: widget.graphData.length >= 500
                                          ? selected
                                          : unselected,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length >= 100,
                                    value: 100,
                                    child: Text(
                                      "Last 100",
                                      style: widget.graphData.length >= 100
                                          ? selected
                                          : unselected,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length > 50,
                                    value: 50,
                                    child: Text(
                                      "Last 50",
                                      style: widget.graphData.length >= 50
                                          ? selected
                                          : unselected,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length > 20,
                                    value: 20,
                                    child: Text(
                                      "Last 20",
                                      style: widget.graphData.length >= 20
                                          ? selected
                                          : unselected,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    enabled: widget.graphData.length > 10,
                                    value: 10,
                                    child: Text(
                                      "Last 10",
                                      style: selected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 26.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1, 1),
                                spreadRadius: -12,
                                blurRadius: 32,
                                color: Color.fromRGBO(161, 161, 161, 0.48),
                              ),
                            ],
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(
                                border: Border(
                                  bottom: BorderSide(color: grey, width: 0.5),
                                ),
                              ),
                              maxY: maxy,
                              barGroups: times
                                  .map(
                                    (e) => BarChartGroupData(
                                      x: i++,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e,
                                          color:
                                              widget.modeColor.withOpacity(0.5),
                                          width: 20.w,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12.r),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  axisNameWidget: Text(
                                    "Each bar is Avg of ${selectedD ~/ 10} solves",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: grey,
                                    ),
                                  ),
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0) {
                                        return Text("");
                                      }
                                      if (double.parse(
                                              value.toStringAsFixed(2)) ==
                                          value.toInt()) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: grey,
                                          ),
                                        );
                                      }
                                      return Text(
                                        value.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: widget.modeColor,
                                  tooltipRoundedRadius: 12.0.r,
                                  fitInsideHorizontally: true,
                                  tooltipMargin: 10.h,
                                  getTooltipItem:
                                      ((group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toStringAsFixed(2),
                                      const TextStyle(color: Colors.white),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void avg(List<double> times) {
    var rev = widget.graphData.reversed
        .toList()
        .getRange(0, min(selectedD, widget.graphData.length))
        .toList();
    int num = selectedD ~/ 10;
    for (var i = 0; i < min(selectedD, widget.graphData.length); i += num) {
      double temp = 0;
      for (var j = i; j < i + num; j++) {
        temp += rev[j].time;
      }
      times.add(double.parse((temp / num).toStringAsFixed(2)));
    }
    for (var i = 0; i < times.length / 2; i++) {
      var temp = times[i];
      times[i] = times[times.length - 1 - i];
      times[times.length - 1 - i] = temp;
    }
  }
}
