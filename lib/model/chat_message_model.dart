// Chat message model
import 'package:flutter/material.dart';

class ChatMessage {
  final int? id;
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
      this.hasAnimated});

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
      isUser: map['isUser'] == 1,
      modelInfo: map['modelInfo'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      conversationId: map['conversationId'],
    );
  }

  void setAnimationValues(bool val, VoidCallback vdc) {
    hasAnimated = val;
    onAnimationComplete = vdc;
  }
}
