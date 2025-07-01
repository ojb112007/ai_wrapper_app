// Chat detail screen to show conversation
import 'package:ai_wrapper_app/model/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String title;

  ChatDetailScreen({
    required this.chatId,
    required this.title,
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Hardcoded message history
  late List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();
    // Initialize with hardcoded messages based on chatId
    //_loadMessages();
  }

  // void _loadMessages() {
  //   // Hardcoded messages for different conversations
  //   switch (widget.chatId) {
  //     case '1':
  //       messages = [
  //         ChatMessage(
  //           id: 1,
  //           text: 'Hi, I need help with Flutter development.',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(minutes: 30)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 2,
  //           text:
  //               'Of course! What specific aspect of Flutter can I help you with?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(minutes: 29)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 3,
  //           text: 'Could you explain how to implement state management?',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(minutes: 25)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 4,
  //           text:
  //               'State management in Flutter has several approaches. The most common ones include Provider, Riverpod, Bloc, and GetX. Would you like me to explain any of these in detail?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(minutes: 24)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //       ];
  //       break;
  //     case '2':
  //       messages = [
  //         ChatMessage(
  //           id: 1,
  //           text: 'I\'m looking for project ideas for my portfolio.',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(hours: 3)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 2,
  //           text:
  //               'That\'s exciting! What kind of technologies are you interested in working with?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(hours: 3)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 3,
  //           text: 'I\'m interested in AI and mobile development.',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(hours: 2)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 4,
  //           text:
  //               'For AI and mobile, you could build a smart personal assistant, an image recognition app, or a language learning tool. What about an AI-powered note-taking app?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(hours: 2)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //       ];
  //       break;
  //     case '3':
  //       messages = [
  //         ChatMessage(
  //           id: 1,
  //           text: 'I\'m learning Dart programming.',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 2,
  //           text:
  //               'That\'s great! Dart is a powerful language, especially with Flutter. What would you like to know about it?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 3,
  //           text: 'How do I use async/await in Dart?',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 4,
  //           text:
  //               'Async/await in Dart is used for asynchronous programming. You mark functions with `async` and use `await` to wait for Future values. This makes asynchronous code read like synchronous code, improving readability and error handling.',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //       ];
  //       break;
  //     case '4':
  //       messages = [
  //         ChatMessage(
  //           id: 1,
  //           text: 'I\'m designing a mobile app and need advice.',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(days: 3, hours: 5)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 2,
  //           text:
  //               'I\'d be happy to help with your app design. What kind of advice are you looking for?',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(days: 3, hours: 5)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 3,
  //           text: 'What are the best practices for dark mode implementation?',
  //           isUser: true,
  //           timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //         ChatMessage(
  //           id: 4,
  //           text:
  //               'For dark mode, consider these best practices: use a consistent color palette, maintain sufficient contrast, test with users, offer manual and automatic switching, and use system-friendly default themes.',
  //           isUser: false,
  //           timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
  //           conversationId: widget.chatId,
  //           modelInfo: 'AI Assistant',
  //         ),
  //       ];
  //       break;
  //     default:
  //       // New conversation
  //       messages = [];
  //       break;
  //   }
  // }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          // id: messages.isEmpty ? 1 : (messages.last.id ?? 0) + 1,
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
          conversationId: widget.chatId,
          modelInfo: 'AI Assistant',
        ),
      );
    });

    // Clear the input field
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate AI response after a delay
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add(
            ChatMessage(
              // id: messages.isEmpty ? 1 : (messages.last.id ?? 0) + 1,
              text:
                  'This is a simulated AI response to your message: "${_messageController.text}"',
              isUser: false,
              timestamp: DateTime.now(),
              conversationId: widget.chatId,
              modelInfo: 'AI Assistant',
            ),
          );
        });

        // Scroll to bottom again after AI response
        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show options for this chat
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'Start a new conversation',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),
          // Message input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Widget for individual message bubbles
// Widget for individual message bubbles
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: message.isUser ? 64 : 0,
          right: message.isUser ? 0 : 64,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!message.isUser && message.modelInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      message.modelInfo!,
                      style: TextStyle(
                        color: message.isUser ? Colors.white70 : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                Text(
                  _formatTimestamp(message.timestamp!),
                  style: TextStyle(
                    color: message.isUser ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }
}
