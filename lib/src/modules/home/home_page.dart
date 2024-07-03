import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Example data source
  final List<String> _suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Kiwi',
  ];

  final TextEditingController _typeAheadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) {
                return _suggestions.where((item) =>
                    item.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                _typeAheadController.text = suggestion;
              },
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No suggestions found!',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Add other widgets here
          ],
        ),
      ),
    );
  }
}
