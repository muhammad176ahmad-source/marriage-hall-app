import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double responsiveWidth(double p) => MediaQuery.of(context).size.width * p;
    double responsiveHeight(double p) => MediaQuery.of(context).size.height * p;
    double responsiveFont(double p) => MediaQuery.of(context).size.width * (p / 100);

    List<Map<String, String>> messages = [
      {"sender": "John Doe", "message": "Hello! Is the hall available?", "time": "10:12 AM"},
      {"sender": "You", "message": "Yes, it is available.", "time": "10:15 AM"},
      {"sender": "John Doe", "message": "Great, thank you!", "time": "10:16 AM"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isMe = msg["sender"] == "You";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    constraints: BoxConstraints(maxWidth: responsiveWidth(0.7)),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.amber[300] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg["message"]!, style: TextStyle(fontSize: responsiveFont(3.5))),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(msg["time"]!,
                              style: TextStyle(
                                  fontSize: responsiveFont(2.5),
                                  color: Colors.black54)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.amber[700],
                  child: const Icon(Icons.send, color: Colors.black87),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}