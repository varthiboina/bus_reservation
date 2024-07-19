import 'package:bus_reservation_udemy/utils/colors.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';

class SeatPlanView extends StatelessWidget {
  final int totalSeat;
  final String bookedSeatNumbers;
  final int totalSeatBooked;
  final bool isBusinessClass;
  final Function(bool, String) onSeatSelected;

  const SeatPlanView({
    super.key,
    required this.totalSeat,
    required this.bookedSeatNumbers,
    required this.isBusinessClass,
    required this.totalSeatBooked,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    final int totalRows =
        (isBusinessClass ? totalSeat / 3 : totalSeat / 4).toInt();
    final int totalColumns = (isBusinessClass ? 3 : 4).toInt();
    List<List<String>> seatArrangment = [];
    for (int i = 0; i < totalRows; i++) {
      List<String> column = [];
      for (int j = 0; j < totalColumns; j++) {
        column.add('${seatLabelList[i]}${j + 1}');
      }
      seatArrangment.add(column);
    }
    final List<String> bookedSeatList =
        bookedSeatNumbers.isEmpty ? [] : bookedSeatNumbers.split(',');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'FRONT',
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          ),
          Column(
            children: [
              for (int i = 0; i < seatArrangment.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int j = 0; j < seatArrangment[i].length; j++)
                      Row(
                        children: [
                          Seat(
                            label: seatArrangment[i][j],
                            isBooked:
                                bookedSeatList.contains(seatArrangment[i][j]),
                            onSelect: (value) {
                              onSeatSelected(value, seatArrangment[i][j]);
                            },
                          ),
                          if (isBusinessClass && j == 0)
                            const SizedBox(width: 24),
                          if (!isBusinessClass && j == 1)
                            const SizedBox(width: 24),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Seat extends StatefulWidget {
  final String label;
  final bool isBooked;
  final Function(bool) onSelect;

  const Seat({
    super.key,
    required this.label,
    required this.isBooked,
    required this.onSelect,
  });

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isBooked) {
          setState(() {
            selected = !selected;
          });
          widget.onSelect(selected);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isBooked
              ? seatBookedColor
              : selected
                  ? seatSelectedColor
                  : seatAvailableColor,
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
