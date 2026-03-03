import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime focusedDay=DateTime.now();
  List<DateTime> selectedDates=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Availability")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: focusedDay,
            selectedDayPredicate: (day)=>selectedDates.any((d)=>d.year==day.year && d.month==day.month && d.day==day.day),
            onDaySelected: (selected,focused){
              setState((){focusedDay=focused;
                if(selectedDates.contains(selected)){selectedDates.remove(selected);}else{selectedDates.add(selected);}
              });
            },
          ),
          const SizedBox(height:20),
          Text("Selected Dates: ${selectedDates.length}"),
        ],
      ),
    );
  }
}