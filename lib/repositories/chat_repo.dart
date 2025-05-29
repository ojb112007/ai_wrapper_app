import 'dart:convert';

import 'package:ai_wrapper_app/model/chat_history_item.dart';
import 'package:ai_wrapper_app/model/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class ChatRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? chatId = '';
  String? model = '';
  bool isFirstMessage = false;
  bool get firstMessageValue => isFirstMessage;
  String get modelValue => model!;
  String? get chatIdVal => chatId!;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> saveMessage({
    required String chatId,
    required String content,
    required bool isUser,
    String? model,
  }) async {
    // if (currentUserId == null) return;

    await _firestore
        .collection('conversations')
        .doc('123456778')
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isUser': isUser,
      'model': model ?? 'default',
    });
  }

  // Get all chats for the current user
  Stream<QuerySnapshot> getChats() {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    return _firestore
        .collection('conversations')
        .doc('123456778')
        .collection('chats')
        .orderBy('lastUpdated', descending: true)
        .snapshots();
  }

  // // Get messages for a specific chat
  // Stream<QuerySnapshot> getMessages(String chatId) {
  //   // if (currentUserId == null) {
  //   //   throw Exception('User not authenticated');
  //   // }

  //   var result = _firestore
  //       .collection('conversations')
  //       .doc('123456778')
  //       .collection('chats')
  //       .doc(chatId)
  //       .collection('messages')
  //       .orderBy('timestamp')
  //       .snapshots();

  //   return result;
  // }

  Future<List<ChatMessage>> getMessages(String chatId) async {
    // if (currentUserId == null) {
    //   throw Exception('User not authenticated');
    // }

    print('Fetching messages for chat: $chatId');

    try {
      // Get messages with a one-time query instead of a stream
      final querySnapshot = await _firestore
          .collection('conversations')
          .doc('123456778')
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      print('Found ${querySnapshot.docs.length} messages');

      // Convert documents to ChatMessage objects
      List<ChatMessage> messages = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data();

          // Map Firestore fields to ChatMessage fields
          ChatMessage message = ChatMessage(
              id: int.tryParse(doc.id),
              text: data['content'] ?? '',
              isUser: data['isUser'] == true || data['isUser'] == 1,
              modelInfo: data['model'] ?? data['modelInfo'] ?? 'default',
              timestamp: data['timestamp'] != null
                  ? (data['timestamp'] is Timestamp
                      ? (data['timestamp'] as Timestamp).toDate()
                      : DateTime.fromMillisecondsSinceEpoch(data['timestamp']))
                  : DateTime.now(),
              conversationId: chatId,
              hasAnimated: true);

          messages.add(message);
        } catch (e) {
          print('Error processing document ${doc.id}: $e');
        }
      }

      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      // Return empty list on error
      return [];
    }
  }

//   Stream<List<ChatMessage>> getMessages(String chatId) {
//   // if (currentUserId == null) {
//   //   throw Exception('User not authenticated');
//   // }

//   // Create the query for Firestore - adjust path based on your actual structure
//  var messagesQuery = _firestore
//         .collection('conversations')
//         .doc('123456778')
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp');

//   return messagesQuery.snapshots().map((querySnapshot) {
//     print('Received snapshot with ${querySnapshot.docs.length} documents');

//     List<ChatMessage> messages = [];
//     for (var doc in querySnapshot.docs) {
//       try {
//         Map<String, dynamic> data = doc.data();

//         // Map Firestore fields to ChatMessage fields
//         ChatMessage message = ChatMessage(
//           id: int.tryParse(doc.id),
//           text: data['content'] ?? '',
//           isUser: data['isUser'] == true, // Handle boolean instead of int
//           modelInfo: data['model'] ?? 'default', // Use 'model' field instead of 'modelInfo'
//           timestamp: data['timestamp'] != null
//               ? (data['timestamp'] is Timestamp
//                   ? (data['timestamp'] as Timestamp).toDate()
//                   : DateTime.now())
//               : DateTime.now(),
//           conversationId: chatId,
//         );

//         messages.add(message);
//         print('Processed message: ${message.text.substring(0, min(20, message.text.length))}...');
//       } catch (e) {
//         print('Error processing document ${doc.id}: $e');
//       }
//     }

//     return messages;
//   });
// }

  Stream<List<ChatMessage>> getMessages1(String chatId) {
    // if (currentUserId == null) {
    //   throw Exception('User not authenticated');
    // }

    // Create the query for Firestore
    var messagesQuery = _firestore
        .collection('conversations')
        .doc('123456778')
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp');

    // Debug print to verify the query path
    // print('Fetching messages from path: ${messagesQuery.path}');

    // Create and transform the stream
    return messagesQuery.snapshots().map((querySnapshot) {
      print('Received snapshot with ${querySnapshot.docs.length} documents');

      // Transform each document to a ChatMessage
      List<ChatMessage> messages = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data();

          // Add necessary fields if missing
          data['id'] = int.tryParse(doc.id);
          if (data['conversationId'] == null) {
            data['conversationId'] = chatId;
          }
          if (data['modelInfo'] == null) {
            data['modelInfo'] = '';
          }

          // Create ChatMessage from data
          ChatMessage message = ChatMessage.fromMap(data);
          messages.add(message);

          print(
              'Processed message: ${message.text.substring(0, min(20, message.text.length))}...');
        } catch (e) {
          print('Error processing document ${doc.id}: $e');
        }
      }

      return messages;
    });
  }

// Helper function for min value
  int min(int a, int b) => a < b ? a : b;

  // Create a new chat
  Future<String> createNewChat(String msg) async {
    // if (currentUserId == null) {
    //   throw Exception('User not authenticated');
    // }
    // Determine title based on first message
    String chatTitle = msg.length > 30 ? '${msg.substring(0, 30)}...' : msg;
    DocumentReference chatRef = await _firestore
        .collection('conversations')
        .doc('123456778')
        .collection('chats')
        .add({
      'title': chatTitle,
      'created': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    isFirstMessage = false;
    chatId = chatRef.id;
    saveMessage(chatId: chatId!, content: msg, isUser: true);

    return chatRef.id;
  }

  Future<String> gptGetResPonse(String text) async {
    var res;
    try {
      // Get API key from environment variables
      final apiKey = dotenv.env['API_KEY'] ?? '';

      // Make API request to AI service
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo", // Or "gpt-4"
            "messages": [
              {"role": "system", "content": "You are a helpful assistant."},
              {"role": "user", "content": text},
            ],
            "temperature": 0.7
          }));

      // Parse response
      final data = jsonDecode(response.body);
      final message = data['choices'][0]['message']['content'];
      model = data['model'];
      res = message;
      saveMessage(chatId: chatId!, content: res, isUser: false);

      // Add AI response to chat
      // setState(() {
      //   _messages.add(ChatMessage(
      //     text: message,
      //     isUser: false,
      //     modelInfo: data['model'],
      //   ));
      //   _isLoading = false;
    } catch (e) {
      // Add error message to chat
      // setState(() {
      //   _messages.add(ChatMessage(
      //       text:
      //           "Error: Failed to get response from AI service\n${e.toString()}",
      //       isUser: false,
      //       modelInfo: ""));
      //   _isLoading = false;
      // });
    }

    return res;
  }

  Future<List<ChatHistoryItem>> getChatHistoryTitles() async {
    // if (currentUserId == null) {
    //   throw Exception('User not authenticated');
    // }

    final List<Map<String, dynamic>> chatHistoryList = [];
    List<ChatHistoryItem> chatHistoryObj = [];

    try {
      // Query all chat documents under the user's conversations collection
      QuerySnapshot querySnapshot = await _firestore
          .collection('conversations')
          .doc('123456778')
          .collection('chats')
          .orderBy('lastUpdated', descending: true) // Sort by most recent first
          .get();

      // Process each document in the query result
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String chatId = doc.id;

        // Get the most recent message for this chat
        QuerySnapshot messageSnapshot = await _firestore
            .collection('conversations')
            .doc('123456778')
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        String lastMessageContent = '';
        bool? isUser;

        if (messageSnapshot.docs.isNotEmpty) {
          var messageData =
              messageSnapshot.docs.first.data() as Map<String, dynamic>;
          lastMessageContent = messageData['content'] ?? '';
          isUser = messageData['isUser'] as bool?;
        }

        // Add the chat ID, title, and last message to our list
        chatHistoryList.add({
          'id': chatId,
          'title': data['title'] ?? 'Untitled Chat',
          'created': data['created'],
          'lastUpdated': data['lastUpdated'],
          'lastMessage': {
            'content': lastMessageContent,
            'isUser': isUser ?? false,
          },
        });
      }
      chatHistoryList.forEach((item) {
        chatHistoryObj.add(ChatHistoryItem(
            id: item['id'],
            title: item['title'],
            lastMessage: item['lastMessage']['content'],
            timestamp: DateTime.now(),
            unreadCount: 2));
      });

      return chatHistoryObj;
    } catch (e) {
      print('Error getting chat history: $e');
      return [];
    }
  }
}

final chatRepoProvider = Provider<ChatRepo>((ref) {
  return ChatRepo();
});
