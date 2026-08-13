import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/theme/app_colors.dart';
import 'chat_message.dart';
import 'package:appwrite/models.dart' as appwrite;
import 'user_bubble.dart';
import 'ai_bubble.dart';
import 'thinking_indicator.dart';

class AiMentorScreen extends StatefulWidget {
  const AiMentorScreen({super.key});

  @override
  State<AiMentorScreen> createState() =>
      _AiMentorScreenState();
}

class _AiMentorScreenState
    extends State<AiMentorScreen> {

  final TextEditingController
      questionController =
          TextEditingController();

  final ScrollController
      _scrollController =
          ScrollController();

  final List<ChatMessage>
      messages = [];

  Future<void> askMentor() async {

    final query =
        questionController.text.trim();

    if (query.isEmpty) return;

    questionController.clear();

    setState(() {

      messages.add(

        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          isUser: true,
          text: query,
        )

      );

      messages.add(

        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          isUser: false,
          isThinking: true,
        )

      );

    });

    scrollToBottom();

    try {

      final response =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .aiKnowledgeCollectionId,

        queries: [

          Query.search(
            "searchText",
            query,
          ),

        ],

      );
 print("RESULTS FOUND: ${response.documents.length}");

for (final doc in response.documents) {

  print("--------------------------------");

  print("TITLE: ${doc.data['title']}");

  print("COMMUNITY: ${doc.data['community']}");

  print("CATEGORY: ${doc.data['category']}");

}
      setState(() {

        if (messages.isNotEmpty) {
          messages.removeLast();
        }

        if (response.documents.isEmpty) {

          messages.add(

            ChatMessage(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              isUser: false,
              text:
                  "Sorry, I couldn't find an answer.",
            ),
          );

        } else {

          appwrite.Document bestDoc = response.documents.first;
          int bestScore = -1;

          final words = query
              .toLowerCase()
              .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
              .split(' ')
              .where((w) => w.isNotEmpty)
              .toList();

          for (final doc in response.documents) {

            final title =
                (doc.data["title"] ?? "")
                    .toString()
                    .toLowerCase();

            final community =
                (doc.data["community"] ?? "")
                    .toString()
                    .toLowerCase();

            final category =
                (doc.data["category"] ?? "")
                    .toString()
                    .toLowerCase();

            final keywords = (doc.data["keywords"] ?? [])
                .map((e) => e.toString().toLowerCase())
                .toList();

            int score = 0;

            for (final word in words) {

              if (title.contains(word)) {
                score += 2;
              }

              if (community.contains(word)) {
                score += 5;
              }

              if (category.contains(word)) {
                score += 1;
              }

              if (keywords.contains(word)) {
                score += 4;
              }
            }

            print("${doc.data["title"]}  SCORE = $score");

            if (score > bestScore) {
              bestScore = score;
              bestDoc = doc;
            }
          }

          print("BEST MATCH = ${bestDoc.data["title"]}");

          messages.add(
            ChatMessage(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              isUser: false,
              answerJson: bestDoc.data["answer"],
              category: bestDoc.data["category"],
            )
          );
print("ANSWER TYPE: ${bestDoc.data["answer"].runtimeType}");
print("ANSWER VALUE:");
print(bestDoc.data["answer"]);
        }

      });

      scrollToBottom();

    } catch (e) {

      print("AI SEARCH ERROR: $e");

      setState(() {

        if (messages.isNotEmpty) {
          messages.removeLast();
        }

        messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            isUser: false,
            text: "Error: $e",
          ),
        );

      });

      scrollToBottom();

    }

  }

  void scrollToBottom() {

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(

        _scrollController
            .position
            .maxScrollExtent,

        duration:
            const Duration(
          milliseconds: 300,
        ),

        curve: Curves.easeOut,

      );

    });

  }

  @override
  void dispose() {

    questionController.dispose();

    _scrollController.dispose();

    super.dispose();

  }

    @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        backgroundColor: AppColors.background,

        elevation: 0,

        title: const Text(

          "AI Mentor",

          style: TextStyle(

            color: AppColors.yellow,

          ),

        ),

      ),

      body: SafeArea(

        child: Column(

          children: [

            Padding(

              padding: const EdgeInsets.all(20),

              child: TextField(

                controller: questionController,

                style: const TextStyle(

                  color: Colors.white,

                ),

                textInputAction: TextInputAction.send,

                onSubmitted: (_) => askMentor(),

                decoration: InputDecoration(

                  hintText:
                      "Ask Njengafricke AI Mentor...",

                  hintStyle: const TextStyle(

                    color: Colors.white54,

                  ),

                  filled: true,

                  fillColor: AppColors.card,

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(18),

                    borderSide: BorderSide.none,

                  ),

                  suffixIcon: IconButton(

                    onPressed: askMentor,

                    icon: const Icon(

                      Icons.send,

                      color: AppColors.yellow,

                    ),

                  ),

                ),

              ),

            ),

            Expanded(

              child: messages.isEmpty

                  ? const Center(

                      child: Padding(

                        padding:
                            EdgeInsets.symmetric(

                          horizontal: 30,

                        ),

                        child: Text(

                          "Ask the AI Mentor about business, innovation, discipline, opportunities, startups and growth.",

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(

                            color: Colors.white70,

                            fontSize: 18,

                            height: 1.6,

                          ),

                        ),

                      ),

                    )

                  : ListView.builder(

                      controller:
                          _scrollController,

                      padding:
                          const EdgeInsets.only(

                        left: 16,

                        right: 16,

                        bottom: 20,

                      ),

                      itemCount: messages.length,

                      itemBuilder:
                          (context, index) {

                        final message =
                            messages[index];

                        if (message.isUser) {

                          return UserBubble(

                            text:
                                message.text ?? "",

                          );

                        }

                        if (message.isThinking) {

                          return const ThinkingIndicator();

                        }

                        if (message.answerJson != null) {

                          return AiBubble(
                            answerJson: message.answerJson!,
                            category: message.category ?? "",
                            typingFinished: message.typingFinished,
                            onTypingFinished: () {
                              if (!message.typingFinished && mounted) {
                                setState(() {
                                  message.typingFinished = true;
                                });
                              }
                            },
                          );
                        }

                        return AiBubble(
                          answerJson: message.text ?? "",
                          category: "",
                          typingFinished: message.typingFinished,
                          onTypingFinished: () {
                            if (!message.typingFinished && mounted) {
                              setState(() {
                                message.typingFinished = true;
                              });
                            }
                          },
                        );

                      },

                    ),

            ),

          ],

        ),

      ),

    );

  }
}