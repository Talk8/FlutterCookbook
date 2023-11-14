import 'package:flutter/material.dart';

enum Numbers {one,two,three,four}

class ExSegmentedButton extends StatefulWidget {
  const ExSegmentedButton({super.key});

  @override
  State<ExSegmentedButton> createState() => _ExSegmentedButtonState();
}

class _ExSegmentedButtonState extends State<ExSegmentedButton> {
  ///set中的泛型类型与ButtonSegment中的value类型以及onSelectionChanged中的类型必须相同
  Set<int> selectedSet = {2};
  Set<Numbers> multiSelectedSet = {Numbers.two,Numbers.three};

  @override
  Widget build(BuildContext context) {

    debugPrint("check $multiSelectedSet ${multiSelectedSet.toString()}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of SegmentedButton"),
      ),
      body: Column(
        children: [
          const Spacer(),
          SegmentedButton(
            // multiSelectionEnabled: true,
            segments: const [
              ButtonSegment( label: Text("one"), icon: Icon(Icons.add), value: 1,),
              ButtonSegment( label: Text("tow"), icon: Icon(Icons.favorite), value: 2,),
              ButtonSegment( label: Text("three"), icon: Icon(Icons.do_not_disturb), value: 3,),
            ],
            // selected:<Numbers>{selectSetSignal},
            selected: selectedSet,
            onSelectionChanged: (Set<int>newSelection){
              debugPrint("changed $newSelection");
              setState(() {
                // selectSetSignal = newSelection.first;
                selectedSet = newSelection;
              });
            },
          ),

          const SizedBox(height: 8,child: SizedBox.shrink(),),
          SegmentedButton(
            segments: const [
              ButtonSegment( label: Text("one"), icon: Icon(Icons.add), value: Numbers.one,),
              ButtonSegment( label: Text("tow"), icon: Icon(Icons.favorite), value: Numbers.two,),
              ButtonSegment( label: Text("three"), icon: Icon(Icons.do_not_disturb), value: Numbers.three,),
              ButtonSegment( label: Text("three"), icon: Icon(Icons.do_not_disturb), value: Numbers.four,),
            ],
            multiSelectionEnabled: true,
            selected: multiSelectedSet,
            ///点击时切换按钮，如果是已经选择的就变成未选择
            onSelectionChanged: (Set<Numbers> newSelected) {
              debugPrint("changed $newSelected");
              setState(() {
                multiSelectedSet = newSelected;
              });
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}


///下面是官方的示例，
/// Flutter code sample for [SegmentedButton].

void main() {
  runApp(const SegmentedButtonApp());
}

class SegmentedButtonApp extends StatelessWidget {
  const SegmentedButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Single choice'),
              SingleChoice(),
              SizedBox(height: 20),
              Text('Multiple choice'),
              MultipleChoice(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum Calendar { day, week, month, year }

class SingleChoice extends StatefulWidget {
  const SingleChoice({super.key});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  Calendar calendarView = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(
            value: Calendar.day,
            label: Text('Day'),
            icon: Icon(Icons.calendar_view_day)),
        ButtonSegment<Calendar>(
            value: Calendar.week,
            label: Text('Week'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<Calendar>(
            value: Calendar.month,
            label: Text('Month'),
            icon: Icon(Icons.calendar_view_month)),
        ButtonSegment<Calendar>(
            value: Calendar.year,
            label: Text('Year'),
            icon: Icon(Icons.calendar_today)),
      ],
      selected: <Calendar>{calendarView},
      onSelectionChanged: (Set<Calendar> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          calendarView = newSelection.first;
        });
      },
    );
  }
}

enum Sizes { extraSmall, small, medium, large, extraLarge }

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({super.key});

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  Set<Sizes> selection = <Sizes>{Sizes.large, Sizes.extraLarge};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Sizes>(
      segments: const <ButtonSegment<Sizes>>[
        ButtonSegment<Sizes>(value: Sizes.extraSmall, label: Text('XS')),
        ButtonSegment<Sizes>(value: Sizes.small, label: Text('S')),
        ButtonSegment<Sizes>(value: Sizes.medium, label: Text('M')),
        ButtonSegment<Sizes>(
          value: Sizes.large,
          label: Text('L'),
        ),
        ButtonSegment<Sizes>(value: Sizes.extraLarge, label: Text('XL')),
      ],
      selected: selection,
      onSelectionChanged: (Set<Sizes> newSelection) {
        setState(() {
          selection = newSelection;
        });
      },
      multiSelectionEnabled: true,
    );
  }
}

