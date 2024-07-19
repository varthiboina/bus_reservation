import 'package:bus_reservation_udemy/drawer/main_drawer.dart';
import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? fromCity, toCity;
  DateTime? departureDate;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        key: _scaffoldKey,
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            children: [
              DropdownButtonFormField<String>(
                  value: fromCity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      errorStyle: TextStyle(color: Colors.white38)),
                  hint: const Text('From..'),
                  isExpanded: true,
                  items: cities
                      .map(
                        (city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    fromCity = value;
                  }),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                  value: toCity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      errorStyle: TextStyle(color: Colors.white38)),
                  hint: const Text('To..'),
                  isExpanded: true,
                  items: cities
                      .map(
                        (city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    toCity = value;
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _selectData,
                      child: const Text('Select Departure Date'),
                    ),
                    Text(departureDate == null
                        ? 'No date choosen'
                        : getFormattedDate(departureDate!)),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: _search,
                    child: const Text("Search"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectData() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 14),
      ),
    );
    if (selectedDate != null) {
      setState(() {
        departureDate = selectedDate;
      });
    }
  }

  void _search() {
    if (departureDate == null) {
      showMsg(context, dateErrMsg);
      return;
    }
    if (_formKey.currentState!.validate()) {
      Provider.of<AppDataProvider>(context, listen: false)
          .getRouteByCityFromAndCityTo(fromCity!, toCity!)
          .then((route) {
        if (route != null) {
          Navigator.pushNamed(
            context,
            routeNameSearchResultPage,
            arguments: [route, getFormattedDate(departureDate!)],
          );
        } else {
          showMsg(context, 'No Route');
        }
      });
    }
  }
}
