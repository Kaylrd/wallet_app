import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTech Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // A nice financial-looking purple
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.amberAccent, // A complementary accent color
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white, // Text and icon color on app bar
          elevation: 0, // Flat app bar
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Button background
            foregroundColor: Colors.white, // Button text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade600),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        // Add more theme properties as needed (e.g., textTheme, cardTheme)
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(0), // Reset margin for custom padding
        ),
      ),
      home: const WalletScreen(),
    );
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _walletBalance = 1250.75;
  final String _userName = 'John Doe';


  void _updateWalletBalance(double newBalance) {
    setState(() {
      _walletBalance = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Handle notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello, $_userName!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 25),
            Card( // Using the Card widget for a nice container
              // Margin is set in ThemeData, but we can override if needed
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₦${_walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple, // Use primary color for emphasis
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded( // Use Expanded to make buttons take equal space
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferScreen(
                            onTransferSuccess: (newBalance) {
                              _updateWalletBalance(newBalance);
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded), // Slightly different icon
                    label: const Text('Send Money'),
                  ),
                ),
                const SizedBox(width: 20), // Spacing between buttons
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveScreen(
                            onReceiveSuccess: (newBalance) {
                              _updateWalletBalance(newBalance);
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded), // More intuitive icon
                    label: const Text('Receive Cash'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Placeholder for recent transactions - future feature
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Center(
                child: Text(
                  'No transactions yet. Send or receive money to get started!',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for our Transfer and Receive screens
class TransferScreen extends StatefulWidget {
  final Function(double)? onTransferSuccess; // Add this line

  const TransferScreen({super.key, this.onTransferSuccess});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> _transferMoney() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final recipientId = _recipientController.text;
    final amount = double.tryParse(_amountController.text);

    if (recipientId.isEmpty || amount == null || amount <= 0) {
      setState(() {
        _message = 'Please enter a valid recipient and amount.';
        _isLoading = false;
      });
      return;
    }

    // --- Mock API Call ---
    // In a real app, you would replace this with your actual Next.js API endpoint.
    // For now, we'll simulate a successful/failed response.
    const String apiUrl = 'https://nextjst-test.vercel.app/api/transfer'; // Replace with your Next.js API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderId': 'currentLoggedInUser', // Replace with actual user ID
          'recipientId': recipientId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            _message = 'Transfer successful! Transaction ID: ${responseData['transactionId']}';
            // Optionally, update wallet balance on WalletScreen after successful transfer
            // This would typically involve a callback or state management solution
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfer successful! Transaction ID: ${responseData['transactionId']}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          _recipientController.clear();
          _amountController.clear();
          if (widget.onTransferSuccess != null && responseData['newSenderBalance'] != null) {
            widget.onTransferSuccess!(responseData['newSenderBalance']);
          }
          Navigator.pop(context);
        } else {
          setState(() {
            _message = 'Transfer failed: ${responseData['message']}';
          });
          String errorMessage = responseData['message'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfer failed: $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        setState(() {
          _message = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error during transfer: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient User ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _transferMoney,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Transfer'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('successful') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

class ReceiveScreen extends StatefulWidget {
  final Function(double)? onReceiveSuccess;

  const ReceiveScreen({super.key, this.onReceiveSuccess});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> _receiveCash() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      setState(() {
        _message = 'Please enter a valid amount to receive.';
        _isLoading = false;
      });
      return;
    }

    // --- Mock API Call ---
    const String apiUrl = 'https://nextjst-test.vercel.app/api/receive'; // Replace with your Next.js API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': 'currentLoggedInUser', // The user who is receiving
          'amount': amount,
          'source': 'App Deposit Simulation', // Example source
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            _message = 'Successfully received ₦${amount.toStringAsFixed(2)}! New balance: ₦${responseData['newBalance'].toStringAsFixed(2)}';
            // In a real app, you'd likely update the WalletScreen balance here
          });
          _amountController.clear();
          if (widget.onReceiveSuccess != null && responseData['newBalance'] != null) {
            widget.onReceiveSuccess!(responseData['newBalance']);
          }
        } else {
          setState(() {
            _message = 'Failed to receive cash: ${responseData['message']}';
          });
        }
      } else {
        setState(() {
          _message = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error receiving cash: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Cash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to Receive',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _receiveCash,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Simulate Receive Cash'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('Successfully') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}