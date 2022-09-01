import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Models/ZBLLTileTypeModel.dart';
import 'package:lltrainer/Utils/AlgSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';

class ZBLLSelectTile extends StatefulWidget {
  final ZBLLTileTypeModel curlltype;
  const ZBLLSelectTile({required this.curlltype, Key? key}) : super(key: key);

  @override
  State<ZBLLSelectTile> createState() => _ZBLLSelectTileState();
}

class _ZBLLSelectTileState extends State<ZBLLSelectTile> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    List<LLSelectViewModel> times = [];
    bool conout = false;
    for (var element in ZBLLNAMES) {
      if (element.startsWith("${widget.curlltype.name}-")) {
        LLSelectViewModel temp = LLSelectViewModel(
            img: "assets/ZBLL/$element.svg",
            name: element,
            alg: "R U R' U' R' F R2 U R' U' R U R' F'");
        times.add(temp);
        conout = true;
        continue;
      }
      if (conout) break;
    }
    print(times);
    final colorarr = [
      Theme.of(context).primaryColorDark,
      Theme.of(context).colorScheme.tertiaryContainer,
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.secondaryContainer,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            i = (i + 1) % colorarr.length;
          });
        },
        onTap: () {
          
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0), color: colorarr[i]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.h,
                child: SvgPicture.asset(
                        widget.curlltype.img,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  widget.curlltype.name,
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
