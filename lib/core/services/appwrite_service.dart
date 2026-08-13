import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static Client client = Client()
      .setEndpoint('https://sgp.cloud.appwrite.io/v1')
      .setProject('6a404ae8000d12e86913');

  static Account account = Account(client);

  static Databases databases = Databases(client);
  static final Realtime realtime = Realtime(client);
}