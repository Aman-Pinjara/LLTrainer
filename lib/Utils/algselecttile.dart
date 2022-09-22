// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:lltrainer/MyProvider/SelectionListUpdateProvider.dart';

import '../Models/SelectionModel.dart';

class AlgSelectTile extends StatefulWidget {
  final SelectionModel curll;
  final String defaultAlg;
  const AlgSelectTile({required this.defaultAlg, required this.curll, Key? key})
      : super(key: key);

  @override
  State<AlgSelectTile> createState() => _AlgSelectTileState();
}

class _AlgSelectTileState extends State<AlgSelectTile> {
  late TextEditingController _controller;
  late int i;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.curll.alg);
    i = widget.curll.selectionType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorarr = [
      Theme.of(context).primaryColorDark,
      Theme.of(context).colorScheme.tertiaryContainer,
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.secondaryContainer,
    ];
    var updateSelection =
        Provider.of<SelectionListUpdateProvider>(context).selectionUpdateList;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            i = (i + 1) % colorarr.length;
            print(i);
            int temp = updateSelection
                .indexWhere((element) => element.llcase == widget.curll.llcase);
            if (temp == -1) {
              Provider.of<SelectionListUpdateProvider>(context, listen: false)
                  .addSelection(
                SelectionModel(
                  llcase: widget.curll.llcase,
                  lltype: widget.curll.lltype,
                  selectionType: i,
                  alg: widget.curll.alg,
                ),
              );
            } else {
              
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[2],
              borderRadius: BorderRadius.circular(6.0),
              color: colorarr[i]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.h,
                child: Image.asset(
                  "assets/${widget.curll.lltype}/${widget.curll.llcase}.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(
                  widget.curll.llcase,
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    AlgEditDialog(context);
                  },
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      widget.curll.alg ?? widget.defaultAlg,
                      style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
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

  void AlgEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Enter new alg"),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                autofocus: true,
                controller: _controller,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                decoration: const InputDecoration(
                  hintText: "Alg",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
