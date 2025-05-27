import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Container(
          height: 400,
          width: 300,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
          ),
          padding: EdgeInsets.all(25),

          child: Text(
            "Welcome Back!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
