import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Dummy Chat Screen
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Comming Soon", style: TextStyle(
        fontSize: 50,color: Colors.grey[600],
      ) ,),
    );
  }
}