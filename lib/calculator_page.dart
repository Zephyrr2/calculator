import 'package:flutter/material.dart';
import 'package:calculator/profile_page.dart';
import 'package:calculator/history_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '';
  final List<Map<String, String>> _history = [];
  int _selectedIndex = 0;
  
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _input = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          String calculation = _input;
          _result = _calculateResult();
          _input = _result;
          _history.add({'perhitungan': calculation, 'hasil': _result});
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_result.isNotEmpty) {
          _input = _result;
          _result = '';
        }
        _input += buttonText;
      }
    });
  }

  String _calculateResult() {
    // Implementasi perhitungan sederhana
    final expression = _input;
    List<String> numbers = [];
    List<String> operators = [];
    String currentNumber = '';

    for (int i = 0; i < expression.length; i++) {
      if ('0123456789.'.contains(expression[i])) {
        currentNumber += expression[i];
      } else if ('+-×÷'.contains(expression[i])) {
        numbers.add(currentNumber);
        operators.add(expression[i]);
        currentNumber = '';
      }
    }
    numbers.add(currentNumber);

    // Ubah logika perhitungan
    double result = double.parse(numbers[0]);
    List<double> values = [result];
    List<String> pendingOperators = [];

    for (int i = 0; i < operators.length; i++) {
      double nextNumber = double.parse(numbers[i + 1]);
      
      if (operators[i] == '×' || operators[i] == '÷') {
        // Lakukan operasi perkalian atau pembagian langsung
        double lastValue = values[values.length - 1];
        if (operators[i] == '×') {
          values[values.length - 1] = lastValue * nextNumber;
        } else {
          if (nextNumber == 0) throw Exception('Tidak bisa dibagi dengan 0');
          values[values.length - 1] = lastValue / nextNumber;
        }
      } else {
        // Untuk + dan -, simpan nilai dan operator untuk dihitung nanti
        values.add(nextNumber);
        pendingOperators.add(operators[i]);
      }
    }

    // Hitung penjumlahan dan pengurangan
    result = values[0];
    for (int i = 0; i < pendingOperators.length; i++) {
      double nextNumber = values[i + 1];
      if (pendingOperators[i] == '+') {
        result += nextNumber;
      } else if (pendingOperators[i] == '-') {
        result -= nextNumber;
      }
    }

    return result.toString();
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 50,
            minWidth: 50,
            maxHeight: 80,
            maxWidth: 80,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Colors.grey[300],
              padding: const EdgeInsets.all(20),
            ),
            onPressed: () {
              if (text == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (text == 'History') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage(history: _history)),
                );
              } else {
                _onButtonPressed(text);
              }
            },
            child: Text(
              text,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout
          final isDesktop = constraints.maxWidth > 600;
          final calculatorWidth = isDesktop ? 500.0 : constraints.maxWidth;
          return Center(
            child: SizedBox(
              width: calculatorWidth,
              child: Column(
                children: [
                  // Display
                  Container(
                    padding: const EdgeInsets.all(60),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _input,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(
                          _result,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Buttons
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildButton('7'),
                                _buildButton('8'),
                                _buildButton('9'),
                                _buildButton('÷', color: Colors.orange[300]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildButton('4'),
                                _buildButton('5'),
                                _buildButton('6'),
                                _buildButton('×', color: Colors.orange[300]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildButton('1'),
                                _buildButton('2'),
                                _buildButton('3'),
                                _buildButton('-', color: Colors.orange[300]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildButton('C', color: Colors.red[300]),
                                _buildButton('0'),
                                _buildButton('=', color: Colors.blue[300]),
                                _buildButton('+', color: Colors.orange[300]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Kalkulator'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage(history: _history)),
              );
            }
          });
        },
      ),
    );
  }
}
