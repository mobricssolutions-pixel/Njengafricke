import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';


class GenerateSearchTextScreen extends StatefulWidget {

  const GenerateSearchTextScreen({
    super.key,
  });

  @override
  State<GenerateSearchTextScreen> createState() =>
      _GenerateSearchTextScreenState();
}


class _GenerateSearchTextScreenState
    extends State<GenerateSearchTextScreen> {


  bool running = false;

  int updated = 0;


  Future<void> generateSearchText() async {

    setState(() {
      running = true;
    });


    try {

      int offset = 0;


      while (true) {


        final response =
            await AppwriteService.databases.listDocuments(

          databaseId:
              AppConstants.databaseId,

          collectionId:
              AppConstants.aiKnowledgeCollectionId,

          queries: [

            Query.limit(100),

            Query.offset(offset),

          ],

        );


        if (response.documents.isEmpty) {
          break;
        }


        for (final doc in response.documents) {


          final title =
              doc.data['title'] ?? "";


          final category =
              doc.data['category'] ?? "";


          final keywords =
              List<String>.from(
                doc.data['keywords'] ?? [],
              );


          final searchText =
              "$title ${keywords.join(' ')} $category";


          await AppwriteService.databases
              .updateDocument(

            databaseId:
                AppConstants.databaseId,

            collectionId:
                AppConstants.aiKnowledgeCollectionId,

            documentId:
                doc.$id,

            data: {

              "searchText":
                  searchText,

            },

          );


          updated++;


          setState(() {});

          print(
            "Updated $updated",
          );

        }


        offset += 100;

      }


    } catch (e) {

      print(
        "Migration error: $e",
      );

    }


    setState(() {

      running = false;

    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
              "Generate Search Text",
            ),
      ),


      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [


            Text(
              "Updated: $updated",
            ),


            const SizedBox(
              height: 20,
            ),


            ElevatedButton(

              onPressed:
                  running
                      ? null
                      : generateSearchText,


              child:
                  Text(
                    running
                        ? "Running..."
                        : "START MIGRATION",
                  ),

            ),

          ],

        ),

      ),

    );

  }

}