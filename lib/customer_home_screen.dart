import 'package:flutter/material.dart';
import 'booking_model.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  Future<void> _showBookingForm(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String functionType = 'Wedding';
    String dhamType = 'Chamba Dham';
    DateTime? eventDate;
    String location = '';
    int? guests;
    final functionTypes = [
      'Wedding',
      'Festival',
      'Birthday',
      'Other',
    ];
    final dhamTypes = [
      'Chamba Dham',
      'Kangra Dham',
      'Hamirpur Dham',
      'Una Dham',
      'Mandi Dham',
      'Bilaspur Dham',
      'Solan Dham',
      'Sirmaur Dham',
      'Shimla Dham',
      'Kinnaur Dham',
      'Kullu Dham',
      'Lahaul Spiti Dham',
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book a Boti'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: functionType,
                        items: functionTypes
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => functionType = val!),
                        decoration:
                            const InputDecoration(labelText: 'Function Type'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: dhamType,
                        items: dhamTypes
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => dhamType = val!),
                        decoration: const InputDecoration(
                            labelText: 'Select Dhaams Type'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: eventDate == null
                              ? 'Event Date'
                              : eventDate.toString().split(' ')[0],
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null)
                            setState(() => eventDate = picked);
                        },
                        validator: (_) =>
                            eventDate == null ? 'Select a date' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Location'),
                        onChanged: (val) => location = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter location'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Expected Guests'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => guests = int.tryParse(val),
                        validator: (val) => guests == null || guests! <= 0
                            ? 'Enter number of guests'
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save booking to shared list
                  sharedBookings.add(Booking(
                    eventType: '$functionType - $dhamType',
                    eventDate: eventDate!,
                    location: location,
                    guests: guests!,
                  ));
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Booking Confirmed'),
                      content: const Text('Your booking has been submitted!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _showBookingForm(context),
                child: const Text('Book a Boti'),
              ),
            ),
            const SizedBox(height: 32),
            const Text('My Bookings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: sharedBookings.isEmpty
                  ? Center(
                      child: Text('No bookings yet.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: sharedBookings.length,
                      itemBuilder: (context, index) {
                        final booking = sharedBookings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(booking.eventType),
                            subtitle: Text(
                                '${booking.eventDate.toString().split(' ')[0]} | ${booking.location} | Guests: ${booking.guests}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
