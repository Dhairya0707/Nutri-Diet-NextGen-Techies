// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];
  final ChatUser user = ChatUser(id: '1', firstName: 'You');
  final ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Nutrition AI',
    // Add an avatar URL
  );

  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey:
        "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4", // Remember to use environment variables for API keys
    systemInstruction: Content.text(
        """You are a highly knowledgeable and helpful assistant specializing in nutrition, diet, and health. Your role is to provide clear, evidence-based, and personalized advice on food choices, meal planning, calorie intake, weight management, fitness, and healthy eating habits. Your responses should be tailored to the user's preferences, dietary restrictions, and goals. Always encourage balanced, healthy, and sustainable practices, and where necessary, explain scientific concepts in simple terms. Ensure your tone is supportive, non-judgmental, and motivating."""),
  );

  List<Content> conversationContext = [];

  void sendMessage(String message) async {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: message,
          user: user,
          createdAt: DateTime.now(),
        ),
      );
    });

    conversationContext.add(Content.text(message));

    try {
      final response = await model.generateContent(conversationContext);
      String? botResponse = response.text;

      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: botResponse!,
            user: bot,
            createdAt: DateTime.now(),
          ),
        );
      });

      conversationContext.add(Content.text(botResponse!));
    } catch (e) {
      print('Error: $e');
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: 'Sorry, I encountered an error. Please try again later.',
            user: bot,
            createdAt: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition AI Assistant'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              messages: messages,
              onSend: (ChatMessage m) => sendMessage(m.text),
              currentUser: user,
              messageOptions: const MessageOptions(
                showTime: true,
                // showAvatarForEveryMessage: true,
              ),
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  hintText: "Ask about nutrition...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              messageListOptions: MessageListOptions(
                dateSeparatorFormat: DateFormat("MMMM d, yyyy"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
