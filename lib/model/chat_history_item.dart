class ChatHistoryItem {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final int? unreadCount;

  ChatHistoryItem({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount,
  });
}

// class ChatMessage {
//   final String content;
//   final DateTime timestamp;
//   final bool isUser;
//   final String? model;

//   ChatMessage({
//     required this.content,
//     required this.timestamp,
//     required this.isUser,
//     this.model,
//   });
// }
