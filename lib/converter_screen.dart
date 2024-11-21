import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _inputAmount = 0.0;
  double _convertedAmount = 0.0;

  void _convertCurrency() {
    setState(() {
      _convertedAmount = _inputAmount * 1.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Amount:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inputAmount = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text(
              'Converted Amount: $_convertedAmount',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.