import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/models/but_route.dart';
import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final BusRoute route = argList[0];
    final String departureDate = argList[1];
    final provider = Provider.of<AppDataProvider>(context);

    provider.getSchedulesByRouteName(route.routeName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchResultPage'),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        Center(
            child:
                Text('${route.cityFrom} to ${route.cityTo} on $departureDate')),
        Consumer<AppDataProvider>(
          builder: (context, value, _) => FutureBuilder<List<BusSchedule>>(
            future: provider.getSchedulesByRouteName(route.routeName),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final scheduleList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: scheduleList
                      .map((schedule) => ScheduleItemView(
                          date: departureDate, schedule: schedule))
                      .toList(),
                );
              }
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              return const Text('Please wait..');
            },
          ),
        )
      ]),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;
  const ScheduleItemView(
      {super.key, required this.date, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context,  routeNameSeatPlanPage , arguments: [schedule,date]),
      child: Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(schedule.bus.busName),
            subtitle: Text(schedule.bus.busType),
            trailing: Text("${schedule.ticketPrice}"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'From : ${schedule.busRoute.cityFrom} to ${schedule.busRoute.cityTo}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
