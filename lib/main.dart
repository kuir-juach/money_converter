import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MoneyConverterApp());
}

class MoneyConverterApp extends StatelessWidget {
  const MoneyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agotdit Money Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade50,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ConverterScreen(),
    AboutUsScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Money Converter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.blue.shade100,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Converter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amount = 1.0;
  double _convertedAmount = 0.0;

  final String _apiKey = "8793551c07583f63d587fbbe";
  final TextEditingController _amountController = TextEditingController();

  Future<void> _convertCurrency() async {
    final url =
        'https://v6.exchangerate-api.com/v6/$_apiKey/pair/$_fromCurrency/$_toCurrency/$_amount';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _convertedAmount = data['conversion_result'] ?? 0.0;
      });
    } else {
      setState(() {
        _convertedAmount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching conversion rate.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _amountController.text = _amount.toString();
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blue.shade200.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CurrencyDropdown(
                  selectedCurrency: _fromCurrency,
                  onChanged: (value) {
                    setState(() {
                      _fromCurrency = value!;
                    });
                  },
                ),
                const Icon(Icons.arrow_forward, color: Colors.white),
                CurrencyDropdown(
                  selectedCurrency: _toCurrency,
                  onChanged: (value) {
                    setState(() {
                      _toCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Converted Amount: $_convertedAmount $_toCurrency',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({super.key, 
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencies = ['USD', 'EUR', 'GBP', 'KES', 'ZAR'];

    return DropdownButton<String>(
      dropdownColor: Colors.blue.shade700,
      value: selectedCurrency,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      items: currencies
          .map((currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency, style: const TextStyle(color: Colors.white)),
              ))
          .toList(),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Agotdit Money Converter, your reliable partner for real-time currency conversion. '
                  'Our app utilizes cutting-edge API technology to ensure accurate and fast results. '
                  'Whether for travel, business, or personal finance, Money Converter makes your life easier.',
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Text(
                  'Stay confident and updated with live exchange rates.',
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _defaultCurrency = 'USD';
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _defaultCurrency,
            decoration: const InputDecoration(
              labelText: 'Default Currency',
              border: OutlineInputBorder(),
            ),
            items: ['USD', 'EUR', 'GBP', 'KES', 'ZAR']
                .map((currency) => DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _defaultCurrency = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
