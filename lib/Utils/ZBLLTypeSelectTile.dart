// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';

class ZBLLTypeSelectTile extends StatefulWidget {
  final LLSelectViewModel zb;
  ZBLLTypeSelectTile({required this.zb, Key? key}) : super(key: key);

  @override
  State<ZBLLTypeSelectTile> createState() => _ZBLLTypeSelectTileState();
}

class _ZBLLTypeSelectTileState extends State<ZBLLTypeSelectTile> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.zb.alg);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    final colorarr = [
      Theme.of(context).primaryColorDark,
      Theme.of(context).colorScheme.tertiaryContainer,
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.secondaryContainer,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            i = (i + 1) % colorarr.length;
          });
        },
        child: Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
                blurRadius: 2,
                color: Colors.grey,
                offset: Offset(0, 1),
                blurStyle: BlurStyle.normal),
          ], borderRadius: BorderRadius.circular(6.0), color: colorarr[i]),
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
                  onTap: () {
                    AlgEditDialog(context);
                  },
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      widget.zb.alg,
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
                    child: Text("Cancel",style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK",style: TextStyle(color: Theme.of(context).colorScheme.onSecondary))),
              ],
            )
          ],
        );
      },
    );
  }
}
