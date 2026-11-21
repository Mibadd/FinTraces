import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _principalCtrl = TextEditingController(text: '1000000');
  final _monthlyAdditionCtrl = TextEditingController(text: '500000');
  final _yearsCtrl = TextEditingController(text: '10');
  final _returnRateCtrl = TextEditingController(text: '8');
  final _inflationRateCtrl = TextEditingController(text: '5'); // Default 5%

  int _futureValue = 0;
  int _futureValueAdjusted = 0;

  void _calculate() {
    final principal = double.tryParse(_principalCtrl.text) ?? 0;
    final monthlyAdd = double.tryParse(_monthlyAdditionCtrl.text) ?? 0;
    final years = int.tryParse(_yearsCtrl.text) ?? 0;
    final returnRate = (double.tryParse(_returnRateCtrl.text) ?? 0) / 100;
    final inflationRate = (double.tryParse(_inflationRateCtrl.text) ?? 0) / 100;

    final months = years * 12;
    final monthlyReturn = returnRate / 12;

    // Compound interest with monthly contributions
    // FV = P(1+r)^n + PMT * (((1+r)^n - 1) / r)
    double fv = principal * pow(1 + monthlyReturn, months);
    if (monthlyReturn > 0) {
      fv += monthlyAdd * ((pow(1 + monthlyReturn, months) - 1) / monthlyReturn);
    } else {
      fv += monthlyAdd * months;
    }

    // Adjust for inflation (discounting future value to present purchasing power)
    double realFv = fv / pow(1 + inflationRate, years);

    setState(() {
      _futureValue = fv.round();
      _futureValueAdjusted = realFv.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Investasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _principalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Modal Awal (Rp)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _monthlyAdditionCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Penyetoran Bulanan (Rp)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yearsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Durasi (Tahun)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _returnRateCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Bunga Tahunan (%)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inflationRateCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Inflasi Tahunan (%) - Bawaan 5%', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Hitung Proyeksi', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 32),
            if (_futureValue > 0) ...[
              const Text('Nilai Masa Depan (Nominal):', style: TextStyle(color: Colors.grey)),
              Text(
                currencyFormat.format(_futureValue),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Nilai Disesuaikan Inflasi (Daya Beli Realistis):', style: TextStyle(color: Colors.grey)),
              Text(
                currencyFormat.format(_futureValueAdjusted),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
