import 'package:ai_wrapper_app/model/chat_message_model.dart';
import 'package:ai_wrapper_app/services/typing_text_widget.dart';
import 'package:flutter/material.dart';

class ChatMessageBubbleWidget extends StatelessWidget {
  final ChatMessage chat;

  ChatMessageBubbleWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            chat.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: chat.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          bottom: 12,
                          left: chat.isUser ? 64 : 0,
                          right: chat.isUser ? 0 : 64,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: chat.isUser
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: chat.isUser
                            ? Text(
                                chat.text,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )
                            : Column(
                                children: [
                                  TypingTextWidget(
                                    text: chat.text,
                                    modelInfo: chat.modelInfo,
                                    typingSpeed: Duration(milliseconds: 15),
                                    hasAnimatd: chat.hasAnimated!,
                                    onAnimationComplete:
                                        chat.onAnimationComplete!,
                                  ),
                                ],
                              )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}