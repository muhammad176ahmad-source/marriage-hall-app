// Import at top
import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final String hallName;
  final String functionType;

  const BookingScreen({
    super.key,
    required this.hallName,
    required this.functionType,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  DateTime? selectedDate;
  late String selectedFunction;

  // New Fields
  String? selectedMenuType;
  String? selectedCuisine;
  String? selectedBeverage;
  String? selectedMusic;
  Map<String, bool> avRequirements = {
    "Projector": false,
    "Screens": false,
    "Stage": false,
    "Registration Table": false,
    "Other": false,
  };

  final List<String> functionTypes = [
    'Mehndi',
    'Walima',
    'Baraat',
    'Mehfil',
    'Other'
  ];
  final List<String> menuTypes = ['Corporate', 'Boxed Lunch', 'Christmas', 'Other'];
  final List<String> cuisineTypes = [
    'Greek',
    'Italian',
    'Portuguese',
    'Polish',
    'Fusion',
    'Chinese',
    'Pakistani',
    'Halal',
    'South Asian',
    'Other'
  ];
  final List<String> beverageTypes = ['Soft Drink', 'Juice', 'Mocktail', 'Other'];
  final List<String> musicTypes = ['DJ', 'Live Band', 'Classical', 'Other'];

  @override
  void initState() {
    super.initState();
    selectedFunction = widget.functionType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.hallName}'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/booking_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Booking Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800]),
                      ),
                      const SizedBox(height: 20),

                      // Function Type
                      DropdownButtonFormField<String>(
                        value: selectedFunction,
                        decoration: InputDecoration(
                          labelText: 'Select Function Type',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: functionTypes
                            .map((func) => DropdownMenuItem(
                                  value: func,
                                  child: Text(func),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedFunction = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Name
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 16),

                      // Guests
                      TextFormField(
                        controller: guestsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Number of Guests',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter number of guests' : null,
                      ),
                      const SizedBox(height: 16),

                      // Date Picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            selectedDate == null
                                ? 'Select Date'
                                : 'Selected Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Menu Type
                      DropdownButtonFormField<String>(
                        value: selectedMenuType,
                        decoration: InputDecoration(
                          labelText: 'Menu Type',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: menuTypes
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedMenuType = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? 'Select Menu Type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Cuisine Type
                      DropdownButtonFormField<String>(
                        value: selectedCuisine,
                        decoration: InputDecoration(
                          labelText: 'Cuisine Type',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: cuisineTypes
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedCuisine = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? 'Select Cuisine Type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Beverage Type
                      DropdownButtonFormField<String>(
                        value: selectedBeverage,
                        decoration: InputDecoration(
                          labelText: 'Beverage Type',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: beverageTypes
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBeverage = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? 'Select Beverage Type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Music Type
                      DropdownButtonFormField<String>(
                        value: selectedMusic,
                        decoration: InputDecoration(
                          labelText: 'Music Type',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: musicTypes
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedMusic = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? 'Select Music Type' : null,
                      ),
                      const SizedBox(height: 16),

                      // AV Requirements
                      const Text(
                        'AV Requirements',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 12,
                        children: avRequirements.keys.map((key) {
                          return FilterChip(
                            label: Text(key),
                            selected: avRequirements[key]!,
                            onSelected: (val) {
                              setState(() {
                                avRequirements[key] = val;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Additional Message
                      TextFormField(
                        controller: messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Message / Comments',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              selectedDate != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingConfirmationScreen(
                                  hallName: widget.hallName,
                                  userName: nameController.text,
                                  date:
                                      '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                                  functionType: selectedFunction,
                                  guests: guestsController.text,
                                  menuType: selectedMenuType!,
                                  cuisineType: selectedCuisine!,
                                  beverageType: selectedBeverage!,
                                  musicType: selectedMusic!,
                                  avRequirements: avRequirements.entries
                                      .where((e) => e.value)
                                      .map((e) => e.key)
                                      .toList(),
                                  message: messageController.text,
                                ),
                              ),
                            );
                          } else if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a date')),
                            );
                          }
                        },
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
