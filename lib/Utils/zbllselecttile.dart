import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Models/ZBLLTileTypeModel.dart';
import 'package:lltrainer/Utils/ZBLLTypeSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/my_colors.dart';

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
          dialog(context, times);
        },
        child: Container(
          decoration: BoxDecoration(boxShadow: kElevationToShadow[2], 
          borderRadius: BorderRadius.circular(6.0), color: colorarr[i]),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dialog(BuildContext context, List<LLSelectViewModel> times) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  children: [
                    Material(
                      elevation: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close, color: ZBLLTHEME,)),
                              Text(
                                widget.curlltype.name,
                                style: TextStyle(
                                    fontSize: 17.sp, fontWeight: FontWeight.w500,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RawScrollbar(
                        thumbColor: ZBLLTHEME,
                        thumbVisibility: true,
                        radius: const Radius.circular(5),
                        thickness: 6,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: times.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ZBLLTypeSelectTile(zb: times[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
