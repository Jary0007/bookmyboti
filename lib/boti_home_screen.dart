import 'package:flutter/material.dart';
import 'booking_model.dart';

class BotiHomeScreen extends StatefulWidget {
  const BotiHomeScreen({super.key});

  @override
  State<BotiHomeScreen> createState() => _BotiHomeScreenState();
}

class _BotiHomeScreenState extends State<BotiHomeScreen> {
  String? selectedDhaamType;
  final dhaamTypes = [
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _selectDhaamType(context));
  }

  Future<void> _selectDhaamType(BuildContext context) async {
    final type = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Select Your Dhaams Type'),
        content: DropdownButtonFormField<String>(
          value: selectedDhaamType ?? dhaamTypes[0],
          items: dhaamTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => selectedDhaamType = val!),
          decoration: const InputDecoration(labelText: 'Dhaams Type'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (selectedDhaamType != null)
                Navigator.of(context).pop(selectedDhaamType);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (type != null) setState(() => selectedDhaamType = type);
  }

  Future<void> _showProfileForm(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String region = '';
    List<String> eventTypes = [];
    int? maxCapacity;
    double? baseCharges;
    final allEventTypes = ['Wedding', 'Festive Event', 'Pahadi Dham', 'Other'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile / Availability'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        onChanged: (val) => name = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Service Region'),
                        onChanged: (val) => region = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter your region'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Event Types',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...allEventTypes.map((type) => CheckboxListTile(
                            title: Text(type),
                            value: eventTypes.contains(type),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  eventTypes.add(type);
                                } else {
                                  eventTypes.remove(type);
                                }
                              });
                            },
                          )),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Max Capacity (guests)'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => maxCapacity = int.tryParse(val),
                        validator: (val) =>
                            maxCapacity == null || maxCapacity! <= 0
                                ? 'Enter max capacity'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Base Charges (₹)'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => baseCharges = double.tryParse(val),
                        validator: (val) =>
                            baseCharges == null || baseCharges! <= 0
                                ? 'Enter base charges'
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
                if (_formKey.currentState!.validate() &&
                    eventTypes.isNotEmpty) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Profile Updated'),
                      content: const Text(
                          'Your profile and availability have been saved!'),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = selectedDhaamType == null
        ? []
        : sharedBookings
            .where((b) => b.eventType.contains(selectedDhaamType!))
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boti Home'),
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
                onPressed: () => _showProfileForm(context),
                child: const Text('Edit Profile / Availability'),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              selectedDhaamType == null
                  ? 'Upcoming Events'
                  : 'Upcoming Events for $selectedDhaamType',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredBookings.isEmpty
                  ? Center(
                      child: Text('No upcoming events.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
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
