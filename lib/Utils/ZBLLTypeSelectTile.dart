// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Models/SelectionModel.dart';
import 'package:lltrainer/MyProvider/SelectionListUpdateProvider.dart';
import 'package:provider/provider.dart';

import '../Backend/Selectiondb.dart';
import '../MyProvider/SelectionStateProvider.dart';

class ZBLLTypeSelectTile extends StatefulWidget {
  final LLSelectViewModel zb;
  final int selection;
  ZBLLTypeSelectTile({required this.selection, required this.zb, Key? key})
      : super(key: key);

  @override
  State<ZBLLTypeSelectTile> createState() => _ZBLLTypeSelectTileState();
}

class _ZBLLTypeSelectTileState extends State<ZBLLTypeSelectTile> {
  late TextEditingController _controller;
  late int i;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.zb.alg);
    i = widget.selection;
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
    if (newState[widget.zb.name] != null || newState[widget.zb.name.split("-").getRange(0, 2).join("-")]!=null) {
      i = newState[widget.zb.name]?.selectionType ?? newState[widget.zb.name.split("-").getRange(0, 2).join("-")]!.selectionType;
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
        onTap: () async{
          setState(() {
            i = (i + 1) % colorarr.length;
          });
          final newSelection = SelectionModel(
              llcase: widget.zb.name,
              lltype: "ZBLL",
              selectionType: i,
              alg: widget.zb.alg,
            );
            Provider.of<SelectionStateProvider>(context, listen: false)
                .addState(newSelection);
            await Selectiondb.instance.updateSelection(newSelection);
          // Provider.of<SelectionListUpdateProvider>(context, listen: false)
          //     .addSelection(
          //   SelectionModel(
          //     llcase: widget.zb.name,
          //     lltype: "ZBLL",
          //     selectionType: i,
          //     alg: widget.zb.alg,
          //   ),
          // );
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[2],
              borderRadius: BorderRadius.circular(6.0),
              color: colorarr[i]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 60.h,
                    child: SvgPicture.asset(
                      widget.zb.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      widget.zb.name.split("-")[2],
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () async{
                    String? alg = await AlgEditDialog(context);
                    if(alg!=null){
                      setState(() {});
                    }
                  },
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      newState[widget.zb.name]?.alg ?? widget.zb.alg,
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w400),
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
        return SimpleDialog(
          title: Text("Alg for ${widget.zb.name}"),
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
                      Navigator.of(context).pop(_controller.text);
                    if (_controller.text.isNotEmpty) {
                      final newSelection = SelectionModel(
                        llcase: widget.zb.name,
                        lltype: "ZBLL",
                        selectionType: i,
                        alg: _controller.text,
                      );
                      Provider.of<SelectionStateProvider>(context,
                              listen: false)
                          .addState(newSelection);
                      Selectiondb.instance.updateSelection(newSelection);
                    }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary))),
              ],
            )
          ],
        );
      },
    );
  }
}
