// Chat message model
import 'package:flutter/material.dart';

class ChatMessage {
  final String? id;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final String? conversationId;
  final String? modelInfo;
  bool? hasAnimated;
  VoidCallback? onAnimationComplete;

  ChatMessage(
      {this.id,
      required this.text,
      required this.modelInfo,
      required this.isUser,
      this.timestamp,
      this.conversationId,
      this.onAnimationComplete,
      this.hasAnimated = true});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'conversationId': conversationId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      text: map['content'],
      isUser: map['isUser'],
      modelInfo: map['modelInfo'],
      timestamp: DateTime.parse(map['timestamp']),
      conversationId: map['conversationId'],
    );
  }

  void setAnimationValues(bool val, VoidCallback vdc) {
    hasAnimated = val;
    onAnimationComplete = vdc;
  }
}
