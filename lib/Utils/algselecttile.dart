// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/AlgLists/DefautlAlgs.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/MyProvider/SelectionStateProvider.dart';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, SelectionModel> newState =
        Provider.of<SelectionStateProvider>(context).currStateChanges;
    if (newState[widget.curll.llcase] != null) {
      i = newState[widget.curll.llcase]!.selectionType;
      // _controller.text = newState[widget.curll.llcase]!.alg ?? "";
    }
    final colorarr = [
      Theme.of(context).primaryColorDark,
      Theme.of(context).colorScheme.tertiaryContainer,
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.secondaryContainer,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            i = (i + 1) % colorarr.length;

            // Provider.of<SelectionListUpdateProvider>(context, listen: false)
            //     .addSelection(
            //   SelectionModel(
            //     llcase: widget.curll.llcase,
            //     lltype: widget.curll.lltype,
            //     selectionType: i,
            //     alg: widget.curll.alg,
            //   ),
            // )updateSelection
          });
          final newSelection = SelectionModel(
            llcase: widget.curll.llcase,
            lltype: widget.curll.lltype,
            selectionType: i,
            alg: newState[widget.curll.llcase]?.alg ??
                (_controller.text != "" ? _controller.text : widget.curll.alg),
          );
          Provider.of<SelectionStateProvider>(context, listen: false)
              .addState(newSelection);
          await Selectiondb.instance.updateSelection(newSelection);
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
                  onTap: () async {
                    String? alg = await AlgEditDialog(context);
                    if (alg != null) {}
                    setState(() {});
                  },
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      newState[widget.curll.llcase]?.alg ??
                          widget.curll.alg ??
                          widget.defaultAlg,
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

  Future<String?> AlgEditDialog(BuildContext context) {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _controller.text = "";
            return false;
          },
          child: SimpleDialog(
            title: Text("Alg for ${widget.curll.llcase}"),
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
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_controller.text);
                      final newSelection = SelectionModel(
                        llcase: widget.curll.llcase,
                        lltype: widget.curll.lltype,
                        selectionType: i,
                        alg: null,
                      );
                      Provider.of<SelectionStateProvider>(context,
                              listen: false)
                          .addState(newSelection);
                      Selectiondb.instance.updateSelection(newSelection);
                    },
                    child: Text(
                      "reset",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {
                      _controller.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_controller.text);
                      if (_controller.text.isNotEmpty) {
                        final newSelection = SelectionModel(
                          llcase: widget.curll.llcase,
                          lltype: widget.curll.lltype,
                          selectionType: i,
                          alg: _controller.text,
                        );
                        Provider.of<SelectionStateProvider>(context,
                                listen: false)
                            .addState(newSelection);
                        Selectiondb.instance.updateSelection(newSelection);
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
