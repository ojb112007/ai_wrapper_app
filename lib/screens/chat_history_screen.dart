import 'package:ai_wrapper_app/model/chat_history_item.dart';
import 'package:ai_wrapper_app/repositories/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen> {
  var chatRepo;
  List<ChatHistoryItem> historicalChat = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chatRepo = await ref.read(chatRepoProvider);
      historicalChat = await chatRepo.getChatHistoryTitles();
      setState(() {});
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var chatRepoObj = ref.watch(chatRepoProvider);

    // Hardcoded chat history data
    // final List<ChatHistoryItem> chatHistory = [
    //   ChatHistoryItem(
    //     id: '1',
    //     title: 'Project Planning',
    //     lastMessage:
    //         'How should I approach creating a timeline for my project?',
    //     timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    //     unreadCount: 2,
    //   ),
    //   ChatHistoryItem(
    //     id: '2',
    //     title: 'Coding Help',
    //     lastMessage: 'Can you explain how async/await works in Dart?',
    //     timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    //     unreadCount: 0,
    //   ),
    //   ChatHistoryItem(
    //     id: '3',
    //     title: 'Book Recommendations',
    //     lastMessage: 'What are some good books on machine learning?',
    //     timestamp: DateTime.now().subtract(const Duration(days: 1)),
    //     unreadCount: 0,
    //   ),
    //   ChatHistoryItem(
    //     id: '4',
    //     title: 'Career Advice',
    //     lastMessage: 'Should I focus on mobile or web development?',
    //     timestamp: DateTime.now().subtract(const Duration(days: 3)),
    //     unreadCount: 0,
    //   ),
    //   ChatHistoryItem(
    //     id: '5',
    //     title: 'Travel Ideas',
    //     lastMessage: 'What are some must-visit places in Japan?',
    //     timestamp: DateTime.now().subtract(const Duration(days: 7)),
    //     unreadCount: 0,
    //   ),
    // ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chat History',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality would go here
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
            onPressed: () {
              // Profile functionality would go here
            },
          ),
        ],
      ),
      body: historicalChat.isEmpty
          ? const Center(child: Text('No chat history found'))
          : ListView.separated(
              itemCount: historicalChat.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = historicalChat[index];
                return ListTile(
                  title: Text(
                    chat.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade100),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTimestamp(chat.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (chat.unreadCount! > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => ChatScreen(
                    //           chatId: chat.id,
                    //         )));
                    context.push('/b/de/${chat.id}');
                  },
                );
              },
            ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(timestamp); // Day of week
    } else {
      return DateFormat('MMM d').format(timestamp); // Month and day
    }
  }
}
