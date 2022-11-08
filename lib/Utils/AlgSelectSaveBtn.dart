// import 'package:flutter/material.dart';
// import 'package:lltrainer/Backend/Selectiondb.dart';
// import 'package:lltrainer/MyProvider/SelectionListUpdateProvider.dart';
// import 'package:lltrainer/Models/SelectionModel.dart';
// import 'package:provider/provider.dart';

// class AlgSelectSaveBtn extends StatefulWidget {
//   final PageController controller;
//   const AlgSelectSaveBtn({required this.controller, Key? key})
//       : super(key: key);
//   @override
//   State<AlgSelectSaveBtn> createState() => _AlgSelectSaveBtnState();
// }

// class _AlgSelectSaveBtnState extends State<AlgSelectSaveBtn> {
//   late bool visible;
//   late List<SelectionModel> selectionUpdates;

//   @override
//   Widget build(BuildContext context) {
//     selectionUpdates =
//         Provider.of<SelectionListUpdateProvider>(context).selectionUpdateList;
//     visible = selectionUpdates.isNotEmpty;
//     return Visibility(
//       visible: visible,
//       child: FloatingActionButton(
//         onPressed: () async {
//           final tempSelections = List<SelectionModel>.from(selectionUpdates);
//           Provider.of<SelectionListUpdateProvider>(context, listen: false)
//               .emptySelection();
//           for (var selection in tempSelections) {
//             await Selectiondb.instance.updateSelection(selection);
//           }
//           if (widget.controller.hasClients) {
//             widget.controller.animateToPage(
//               1,
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeInOut,
//             );
//           }
//         },
//         child: const Icon(Icons.save_outlined),
//       ),
//     );
//   }
// }
