import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';

class AlgSelectTile extends StatefulWidget {
  final LLSelectViewModel curll;
  const AlgSelectTile({required this.curll, Key? key})
      : super(key: key);

  @override
  State<AlgSelectTile> createState() => _AlgSelectTileState();
}

class _AlgSelectTileState extends State<AlgSelectTile> {
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0), color: colorarr[i]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.h,
                child: Image.asset(
                        widget.curll.img,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(
                  widget.curll.name,
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    print("Tapped");
                  },
                  child: SizedBox(
                    width: 125.w,
                    child: Text(
                      widget.curll.alg,
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
}
