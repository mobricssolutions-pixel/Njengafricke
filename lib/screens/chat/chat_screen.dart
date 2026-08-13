import 'package:flutter/material.dart';

import 'package:appwrite/models.dart'
    show Document;

import '../../core/constants/app_constants.dart';

import '../../core/services/appwrite_service.dart';

import '../../core/services/chat_service.dart';

import '../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {

  final String chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final controller =
      TextEditingController();

  List<Document> messages = [];

  String currentUserId = '';

  @override
  void initState() {

    super.initState();

    initialize();
  }

  Future<void> initialize() async {

    final currentUser =
        await AppwriteService
            .account
            .get();

    currentUserId =
        currentUser.$id;

    await loadMessages();

    listenRealtime();
  }

  Future<void> loadMessages() async {

    final response =
        await AppwriteService
            .databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .messagesCollectionId,
    );

    final filteredMessages =

        response.documents.where(
      (doc) {

        return
            doc.data['chatId'] ==
            widget.chatId;
      },
    ).toList();

    filteredMessages.sort(

      (a, b) {

        return a.data['createdAt']
            .compareTo(
          b.data['createdAt'],
        );
      },
    );

    if (mounted) {

      setState(() {

        messages =
            filteredMessages;
      });
    }
  }

  void listenRealtime() {

    AppwriteService
        .realtime
        .subscribe([

      'databases.${AppConstants.databaseId}.tables.${AppConstants.messagesCollectionId}.rows'

    ]).stream.listen((event) {

      loadMessages();
    });
  }

  Future<void> send() async {

    if (controller.text
        .trim()
        .isEmpty) {

      return;
    }

    await ChatService
        .sendMessage(

      chatId:
          widget.chatId,

      message:
          controller.text.trim(),
    );

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(

        title:
            const Text(
          'Chat',
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child:
                ListView.builder(

              padding:
                  const EdgeInsets.all(
                16,
              ),

              itemCount:
                  messages.length,

              itemBuilder:
                  (context, index) {

                final item =
                    messages[index];

                final senderId =
                    item.data['senderId']
                        ?? '';

                final isMe =
                    senderId ==
                    currentUserId;

                return Align(

                  alignment:

                      isMe

                          ? Alignment
                              .centerRight

                          : Alignment
                              .centerLeft,

                  child:
                      Container(

                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    padding:
                        const EdgeInsets.all(
                      14,
                    ),

                    constraints:
                        const BoxConstraints(
                      maxWidth: 300,
                    ),

                    decoration:
                        BoxDecoration(

                      color:

                          isMe

                              ? AppColors
                                  .maroon

                              : AppColors
                                  .card,

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child:
                        Column(

                      crossAxisAlignment:

                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          isMe
                              ? 'You'
                              : 'Collaborator',

                          style:
                              const TextStyle(

                            fontSize: 12,

                            fontWeight:
                                FontWeight.bold,

                            color:
                                AppColors.yellow,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(

                          item.data['message']
                              ?? '',

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(

                          item.data['createdAt']
                              ?? '',

                          style:
                              const TextStyle(

                            fontSize: 10,

                            color:
                                Colors.white70,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(

            padding:
                const EdgeInsets.all(
              12,
            ),

            decoration:
                BoxDecoration(

              color:
                  AppColors.card,

              border: Border(

                top: BorderSide(
                  color:
                      AppColors.maroon,
                ),
              ),
            ),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                        controller,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      hintText:
                          'Type message...',

                      hintStyle:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),

                      filled: true,

                      fillColor:
                          AppColors.background,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                CircleAvatar(

                  backgroundColor:
                      AppColors.maroon,

                  child: IconButton(

                    onPressed: send,

                    icon:
                        const Icon(

                      Icons.send,

                      color:
                          AppColors.yellow,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}