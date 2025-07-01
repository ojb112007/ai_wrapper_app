import 'package:ai_wrapper_app/repositories/chat_repo.dart';
import 'package:ai_wrapper_app/widgets/chat_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/chat_message_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  String? chatId;
  ChatScreen({Key? key, this.chatId}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late String _currentChatId;
  bool _isLoading = false;
  bool _isFirstMessage = false;
  bool showNewChatButton = false;
  ChatRepo? chatRepo;
  Map<int, bool> hasAnimatedMap = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chatRepo = await ref.read(chatRepoProvider);
      if (widget.chatId == null || widget.chatId == '') {
        widget.chatId = chatRepo!.chatIdVal;
      }

      _setupChat();
      showNewChatButton = _messages.isNotEmpty;
    });
  }

  void _setupChat() async {
    if (widget.chatId != '') {
      // Open existing chat
      _currentChatId = widget.chatId!;
      chatRepo!.isFirstMessage = false;
      _messages = await chatRepo!.getMessages(widget.chatId!);

      for (int i = 0; i < _messages.length; i++) {
        hasAnimatedMap[i] = _messages[i].hasAnimated!;
      }
      setState(() {});
    } else {
      // No chatId provided, user will start a new chat with first message
      chatRepo!.isFirstMessage = true;
      // We'll create the chat ID when the first message is sent
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    if (chatRepo!.isFirstMessage) {
      await chatRepo!.createNewChat(text);
      // chatRepo!.saveMessage(
      //     chatId: chatRepo!.chatIdVal!, content: text, isUser: true);
    } 
    // Add user message to chat
    setState(() {
      _messages.add(ChatMessage(
          text: text, isUser: true, modelInfo: chatRepo!.modelValue));
      _isLoading = true;
    });

    // Scroll to bottom after adding message

    var response = await chatRepo!.gptGetResPonse(text);
    // Add AI response to chat
    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        modelInfo: "",
      ));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Add a small delay to ensure the list has updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  int _selectedIndex = 0;

  // Define your screens here
  final List<Widget> _screens = [
    ChatScreen(),
    const Placeholder(), // Second screen
    const Placeholder(), // Third screen
    const Placeholder(), // Fourth screen
  ];

  void clearScreen() {
    _messages = [];
    widget.chatId == null;
    chatRepo?.isFirstMessage = true;
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            !_messages.isEmpty
                ? IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      clearScreen();
                    },
                  )
                : SizedBox()
          ],
          leading: GoRouter.of(context).canPop()
              ? IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                )
              : null,
          title: const Text(
            'AI Chat',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Logo section
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: Column(
              //     children: [
              //       // Placeholder for logo - replace with your actual logo
              //       Container(
              //         width: 80,
              //         height: 80,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.secondary,
              //           shape: BoxShape.circle,
              //         ),
              //         child: const Center(
              //           child: Icon(
              //             Icons.auto_awesome,
              //             size: 50,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         'Your AI Assistant',
              //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //             ),
              //       ),
              //     ],
              //   ),
              // ),

              // Chat messages
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            "Start a conversation!",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          itemCount: _messages.length,
                          itemBuilder: (_, index) {
                            ChatMessage msg = _messages[index];
                            msg.setAnimationValues(
                                hasAnimatedMap[index] ?? false, () {
                              hasAnimatedMap[index] = true;
                            });
                            return ChatMessageBubbleWidget(
                                chat: _messages[index]);
                          },
                        ),
                ),
              ),

              // Loading indicator
              if (_isLoading)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).cardColor,
                  child: const Center(
                    child: LinearProgressIndicator(),
                  ),
                ),

              // Text composer
              Column(
                children: [
                  _buildTextComposer(),
                  //         Container(
                  //   width: screenWidth,
                  //   height: 85.h,
                  //   decoration: BoxDecoration(
                  //       color: Color.fromRGBO(0, 0, 0, 1),
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(20.r),
                  //         topRight: Radius.circular(20.r),
                  //       )),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Center(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             _buildTab('Sections', 0,
                  //                 'assets/images/Subtract.svg', 'Home'),
                  //             _buildTab('Exam Kit', 1,
                  //                 'assets/images/compass.svg', 'Explore'),
                  //             _buildTab('Exam Kit', 2, 'assets/images/add.svg',
                  //                 'Create'),
                  //             _buildTab('Complete Test', 3,
                  //                 'assets/images/pin.svg', 'Location'),
                  //             _buildTab('Exam Kit', 4,
                  //                 'assets/images/profile.svg', 'Profile'),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   color: Colors.white,

        //   // decoration: BoxDecoration(
        //   //   color: const Color.fromARGB(
        //   //       255, 238, 238, 238), // Darker than the scaffold background
        //   //   border: Border(
        //   //     top: BorderSide(
        //   //       color: Colors.grey.shade800,
        //   //       width: 0.5,
        //   //     ),
        //   //   ),
        //   // ),
        //   child: BottomNavigationBar(
        //       currentIndex: _selectedIndex,
        //       onTap: _onItemTapped,
        //       backgroundColor: Colors.white,
        //       items: [
        //         BottomNavigationBarItem(
        //             icon: Icon(Icons.search),
        //             activeIcon: Icon(
        //               Icons.search,
        //               color: Colors.white,
        //             ),
        //             label: 'Search'),
        //         BottomNavigationBarItem(
        //             icon: Icon(Icons.widgets_outlined),
        //             activeIcon: Icon(
        //               Icons.widgets_outlined,
        //               color: Colors.white,
        //             ),
        //             label: 'Functions'),
        //         BottomNavigationBarItem(
        //             icon: Icon(Icons.add_circle_outline_outlined),
        //             activeIcon: Icon(
        //               Icons.add_circle_outline_outlined,
        //               color: Colors.white,
        //             ),
        //             label: 'Add'),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.person_outline),
        //           activeIcon: Icon(
        //             Icons.person_outline,
        //             color: Colors.white,
        //           ),
        //           label: 'Profile',
        //         ),
        //       ]),
        // ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask the AI something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : const Color(0xFF4A5568),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}
