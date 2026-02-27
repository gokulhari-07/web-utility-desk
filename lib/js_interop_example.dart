import 'package:flutter/material.dart';
import 'js_bindings.dart';

class JSInteropExample extends StatefulWidget {
  const JSInteropExample({super.key});

  @override
  State<JSInteropExample> createState() => _JSInteropExampleState();
}

class _JSInteropExampleState extends State<JSInteropExample> {
  String message = "";

  void callJS() {
    final result = greetFromJsDartFn();
    final sum = addNumbersDartFn(10, 80);

    setState(() {
      message = "$result | Sum: $sum";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Web + JS interop")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: callJS,
              child: const Text("Call JavaScript"),
            ),
          ],
        ),
      ),
    );
  }
}
