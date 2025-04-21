import 'package:flutter/material.dart';

import '../Backend/SettingsBox.dart';

class SelectionOptionDialog extends StatefulWidget {
  final int mode;
  final String ll;
  const SelectionOptionDialog(
      {required this.ll, required this.mode, super.key});

  @override
  State<SelectionOptionDialog> createState() => _SelectionOptionDialogState();
}

class _SelectionOptionDialogState extends State<SelectionOptionDialog> {
  late int mode;
  @override
  void initState() {
    super.initState();
    mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Practise Set Selection"),
      children: [
        RadioListTile<int>(
          activeColor: Theme.of(context).colorScheme.tertiaryContainer,
          title: Text(
            "Learning",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
          value: 1,
          groupValue: mode,
          onChanged: (value) {
            setState(() {
              mode = value!;
            });
            SettingsBox().setLLSelectPref(widget.ll, value!);
          },
        ),
        RadioListTile<int>(
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            "Finished",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          value: 2,
          groupValue: mode,
          onChanged: (value) {
            setState(() {
              mode = value!;
            });
            SettingsBox().setLLSelectPref(widget.ll, value!);
          },
        ),
        RadioListTile<int>(
          activeColor: Theme.of(context).colorScheme.error,
          title: Text(
            "All Except not learned",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          value: 3,
          groupValue: mode,
          onChanged: (value) {
            setState(() {
              mode = value!;
            });
            SettingsBox().setLLSelectPref(widget.ll, value!);
          },
        ),
        RadioListTile<int>(
          activeColor: Theme.of(context).colorScheme.onSecondary,
          title: Text(
            "All",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          value: 0,
          groupValue: mode,
          onChanged: (value) {
            setState(() {
              mode = value!;
            });
            SettingsBox().setLLSelectPref(widget.ll, value!);
          },
        ),
      ],
    );
  }
}
