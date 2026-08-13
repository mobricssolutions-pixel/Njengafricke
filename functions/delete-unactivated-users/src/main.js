const sdk = require('node-appwrite');

module.exports = async ({ req, res, log, error }) => {
  try {

    const client = new sdk.Client()
      .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
      .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
      .setKey(process.env.APPWRITE_API_KEY);

    const databases = new sdk.Databases(client);

    const DATABASE_ID = process.env.DATABASE_ID;
    const USERS_COLLECTION_ID = process.env.USERS_COLLECTION_ID;

    const result = await databases.listDocuments(
      DATABASE_ID,
      USERS_COLLECTION_ID
    );

    const now = new Date();

    let deletedCount = 0;

    for (const user of result.documents) {

      const paidMember =
        user.paidMember ?? false;

      const approved =
        user.approved ?? false;

      // Appwrite system creation date
      const createdAt =
        new Date(user.$createdAt);

      const ageInDays =
        Math.floor(
          (now - createdAt) /
          (1000 * 60 * 60 * 24)
        );

      if (
        paidMember === false &&
        approved === false &&
        ageInDays >= 14
      ) {

        await databases.deleteDocument(
          DATABASE_ID,
          USERS_COLLECTION_ID,
          user.$id
        );

        deletedCount++;

        log(
          `Deleted user: ${user.name ?? 'Unknown'} (${user.$id})`
        );
      }
    }

    return res.json({
      success: true,
      deletedCount,
    });

  } catch (err) {

    error(err);

    return res.json({
      success: false,
      message: err.message,
    });
  }
};