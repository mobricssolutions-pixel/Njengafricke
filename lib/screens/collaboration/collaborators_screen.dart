import 'package:flutter/material.dart';

import '../../core/services/collaboration_service.dart';

import '../../core/services/chat_service.dart';

import '../chat/chat_screen.dart';

import '../../core/theme/app_colors.dart';

class CollaboratorsScreen
    extends StatefulWidget {

  const CollaboratorsScreen({
    super.key,
  });

  @override
  State<CollaboratorsScreen>
      createState() =>
          _CollaboratorsScreenState();
}

class _CollaboratorsScreenState
    extends State<CollaboratorsScreen> {

  List<dynamic> collaborators = [];

  bool loading = true;

  @override
  void initState() {

    super.initState();

    loadCollaborators();
  }

  Future<void> loadCollaborators() async {

    try {

      final data =
          await CollaborationService
              .findCollaborators();

      if (mounted) {

        setState(() {

          collaborators = data;

          loading = false;
        });
      }

    } catch (e) {

      debugPrint(
        'LOAD COLLABORATORS ERROR: $e',
      );

      if (mounted) {

        setState(() {

          loading = false;
        });
      }
    }
  }

  Future<void> openChat(
    dynamic item,
  ) async {

    try {

      final chatId =
          await ChatService.createChat(
        item['userId'],
      );

      if (chatId == null) {

        if (mounted) {

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(
              content:
                  Text(
                'Failed to create chat',
              ),
            ),
          );
        }

        return;
      }

      if (!mounted) {
        return;
      }

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => ChatScreen(
            chatId: chatId,
          ),
        ),
      );

    } catch (e) {

      debugPrint(
        'OPEN CHAT ERROR: $e',
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
                Text(
              'Error: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(

        title:
            const Text(
          'Potential Collaborators',
        ),
      ),

      body:

          loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : collaborators.isEmpty

                  ? const Center(

                      child: Text(
                        'No collaborators found.',
                      ),
                    )

                  : ListView.builder(

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      itemCount:
                          collaborators.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            collaborators[index];

                        return InkWell(

                          onTap: () {

                            openChat(item);
                          },

                          child: Container(

                            margin:
                                const EdgeInsets.only(
                              bottom: 16,
                            ),

                            padding:
                                const EdgeInsets.all(
                              16,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  AppColors.card,

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),

                              border: Border.all(
                                color:
                                    AppColors.maroon,
                              ),
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Row(

                                  children: [

                                    const CircleAvatar(

                                      backgroundColor:
                                          AppColors.maroon,

                                      child: Icon(

                                        Icons.person,

                                        color:
                                            AppColors.yellow,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 12,
                                    ),

                                    Expanded(

                                      child: Column(

                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,

                                        children: [

                                          Text(

                                            item['name'] ??
                                                'No Name',

                                            style:
                                                const TextStyle(

                                              fontSize:
                                                  20,

                                              fontWeight:
                                                  FontWeight.bold,

                                              color:
                                                  AppColors.yellow,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          Text(

                                            item['profession'] ??
                                                '',

                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    CircleAvatar(

                                      backgroundColor:
                                          AppColors.maroon,

                                      child: Text(

                                        item['score']
                                            .toString(),

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 16,
                                ),

                                Text(

                                  item['bio'] ??
                                      '',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 16,
                                ),

                                SizedBox(

                                  width:
                                      double.infinity,

                                  child:
                                      ElevatedButton.icon(

                                    style:
                                        ElevatedButton.styleFrom(

                                      backgroundColor:
                                          AppColors.maroon,
                                    ),

                                    onPressed: () {

                                      openChat(item);
                                    },

                                    icon:
                                        const Icon(
                                      Icons.chat,
                                    ),

                                    label:
                                        const Text(
                                      'START CHAT',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}