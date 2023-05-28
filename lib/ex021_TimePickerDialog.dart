import 'package:flutter/material.dart';

class ExTimeDatePicker extends StatefulWidget {
  const ExTimeDatePicker({Key? key}) : super(key: key);

  @override
  State<ExTimeDatePicker> createState() => _ExTimeDatePickerState();
}

class _ExTimeDatePickerState extends State<ExTimeDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Example of Time and Date Picker Dialog'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const TimePickerDialog(
                      initialTime: TimeOfDay(hour: 12, minute: 3),
                      initialEntryMode: TimePickerEntryMode.input,
                    );
                  });
            },
            child: Text("ShowDialog Fun"),
          ),
          ElevatedButton(
            onPressed: () {
              showTimePicker(
                context: context,
                hourLabelText: "H",
                minuteLabelText: "M",
                initialEntryMode: TimePickerEntryMode.inputOnly,
                initialTime: TimeOfDay(hour: 12, minute: 3),
              );
            },
            child: const Text("ShowTimePicker Fun"),
          )
        ],
      ),
    );
  }
}
