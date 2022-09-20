import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Models/SelectionModel.dart';
import 'package:lltrainer/Utils/ZBLLTypeSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/my_colors.dart';

class ZBLLSelectTile extends StatefulWidget {
  final SelectionModel curlltype;
  const ZBLLSelectTile({required this.curlltype, Key? key}) : super(key: key);

  @override
  State<ZBLLSelectTile> createState() => _ZBLLSelectTileState();
}

class _ZBLLSelectTileState extends State<ZBLLSelectTile> {
  late int i;
  @override
  void initState() {
    super.initState();
    i = widget.curlltype.selectionType;
  }

  @override
  Widget build(BuildContext context) {
    List<LLSelectViewModel> times = [];
    bool conout = false;
    for (var element in ZBLLNAMES) {
      if (element.startsWith("${widget.curlltype.llcase}-")) {
        LLSelectViewModel temp = LLSelectViewModel(
          img: "assets/ZBLL/$element.svg",
          name: element,
          alg: "sorry ZB was too Long so no Default algs :,(",
        );
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
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[2],
              borderRadius: BorderRadius.circular(6.0),
              color: colorarr[i]),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: SvgPicture.asset(
                    "assets/${widget.curlltype.lltype}/${widget.curlltype.llcase}.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    widget.curlltype.llcase,
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

  Future<Map<String,int>> getSelectionFromDb(List<LLSelectViewModel> curcases)async{
    Map<String,int> timesMap = {};
    List<SelectionModel> times = await Selectiondb.instance.getSelections("ZBLL");
    for (var element in curcases) {
      timesMap[element.name] = times[times.indexWhere((timeselement) => timeselement.llcase==element.name)].selectionType;
    }
    return timesMap;
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
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: ZBLLTHEME,
                                  )),
                              Text(
                                widget.curlltype.llcase,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<Map<String, int>>(
                        future: getSelectionFromDb(times),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return RawScrollbar(
                              thumbColor: ZBLLTHEME,
                              thumbVisibility: true,
                              radius: const Radius.circular(5),
                              thickness: 6,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: times.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ZBLLTypeSelectTile(
                                      zb: times[index],
                                      selection:
                                          snapshot.data![times[index].name]!);
                                },
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return const Center(
                              child: Text("There was some error"),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        },);
  }
}
