import 'package:bus_reservation_udemy/models/bus_reservation.dart';
import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/models/customer.dart';
import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BookingConfirmation extends StatefulWidget {
  const BookingConfirmation({super.key});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  late BusSchedule schedule;
  late String departureDate;
  late int totalSeatsBooked;
  late String seatNumbers;
  bool isFirst = true;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isFirst) {
      final argList = ModalRoute.of(context)!.settings.arguments as List;
      schedule = argList[1];
      departureDate = argList[0];
      totalSeatsBooked = argList[3];
      seatNumbers = argList[2];
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    nameController.text = 'MR.ABC';
    mobileController.text = '+15136099560';
    emailController.text = 'dhanushvarthiboina@gmail.com';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confimation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please provide your information',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Customer Name',
                filled: true,
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMessage;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: mobileController,
              decoration: const InputDecoration(
                hintText: 'Mobile Number',
                filled: true,
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMessage;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                filled: true,
                prefixIcon: Icon(Icons.computer),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMessage;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Booking Summary',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Name : ${nameController.text}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Mobile Number : ${mobileController.text}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Email : ${emailController.text}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Seats : $seatNumbers',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Departure : $departureDate',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Ticket Cost : ${schedule.ticketPrice}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Processing fee : ${schedule.processingFee}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Total Cost :  ${schedule.ticketPrice + schedule.processingFee}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmBooking,
                child: Text(
                  'CONFIRM BOOKING',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
          customerName: nameController.text,
          mobile: mobileController.text,
          email: emailController.text);

      final reservation = BusReservation(
          customer: customer,
          busSchedule: schedule,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          departureDate: departureDate,
          totalSeatBooked: totalSeatsBooked,
          seatNumbers: seatNumbers,
          reservationStatus: reservationActive,
          totalPrice: schedule.ticketPrice + schedule.processingFee);

      Provider.of<AppDataProvider>(context, listen: false)
          .addReservation(reservation)
          .then((value) {
        if (value.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, value.message);
          Navigator.popUntil(context, ModalRoute.withName(routeNameHome));
        }
      }).catchError((error) {
        showMsg(context, 'Could Not Save');
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
