import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';

import '../models/approval_model.dart';
import '../models/contribution_model.dart';
import '../models/fundraiser_model.dart';

class FundraisingService {
  final Databases _databases = AppwriteService.databases;
  final Account _account = AppwriteService.account;

  /// ============================================================
  /// FUNDRAISERS
  /// ============================================================

  Future<String> createFundraiser(
    FundraiserModel fundraiser,
  ) async {
    final user = await _account.get();

    final fundraiserId = ID.unique();

    final data = fundraiser.copyWith(
      creatorId: user.$id,
    );

    // Create fundraiser
    await _databases.createDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      documentId: fundraiserId,
      data: data.toMap(),
    );

    // Create approval request
    await _databases.createDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.approvalsCollectionId,
      documentId: ID.unique(),
      data: {
        'itemType': 'fundraiser',
        'itemId': fundraiserId,
        'submittedBy': user.$id,
        'status': 'pending',
        'submittedAt': DateTime.now().toIso8601String(),
      },
    );
    return fundraiserId;
  }

  Future<List<FundraiserModel>> getApprovedFundraisers() async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      queries: [
        Query.equal('status', 'approved'),
        Query.orderDesc('createdAt'),
      ],
    );

    return response.documents
        .map((doc) => FundraiserModel.fromMap(doc.data))
        .toList();
  }

  Future<List<FundraiserModel>> getPendingFundraisers() async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      queries: [
        Query.equal('status', 'pending'),
        Query.orderDesc('createdAt'),
      ],
    );

    return response.documents
        .map((doc) => FundraiserModel.fromMap(doc.data))
        .toList();
  }

  Future<List<FundraiserModel>> getMyFundraisers() async {
    final user = await _account.get();

    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      queries: [
        Query.equal('creatorId', user.$id),
        Query.orderDesc('createdAt'),
      ],
    );

    return response.documents
        .map((doc) => FundraiserModel.fromMap(doc.data))
        .toList();
  }
  Future<FundraiserModel?> getFundraiserById(String id) async {
    try {
      final document = await _databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.fundraisingCollectionId,
        documentId: id,
      );

      return FundraiserModel.fromMap(document.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateFundraiser(
    String fundraiserId,
    Map<String, dynamic> data,
  ) async {
    await _databases.updateDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      documentId: fundraiserId,
      data: data,
    );
  }

  Future<void> deleteFundraiser(
    String fundraiserId,
  ) async {
    await _databases.deleteDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      documentId: fundraiserId,
    );
  }

  /// ============================================================
  /// APPROVALS
  /// ============================================================

  Future<ApprovalModel?> getApprovalForItem(
    String itemId,
  ) async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.approvalsCollectionId,
      queries: [
        Query.equal('itemId', itemId),
      ],
    );

    if (response.documents.isEmpty) {
      return null;
    }

    return ApprovalModel.fromMap(
      response.documents.first.data,
    );
  }

  Future<void> approveFundraiser({
    required String fundraiserId,
    required String approvalId,
  }) async {
    final admin = await _account.get();

    await _databases.updateDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.approvalsCollectionId,
      documentId: approvalId,
      data: {
        'status': 'approved',
        'adminId': admin.$id,
        'reviewedAt': DateTime.now().toIso8601String(),
      },
    );

    await _databases.updateDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      documentId: fundraiserId,
      data: {
        'status': 'approved',
      },
    );
  }

  Future<void> rejectFundraiser({
    required String fundraiserId,
    required String approvalId,
    required String reason,
  }) async {
    final admin = await _account.get();

    await _databases.updateDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.approvalsCollectionId,
      documentId: approvalId,
      data: {
        'status': 'rejected',
        'adminId': admin.$id,
        'reviewNotes': reason,
        'reviewedAt': DateTime.now().toIso8601String(),
      },
    );

    await _databases.updateDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.fundraisingCollectionId,
      documentId: fundraiserId,
      data: {
        'status': 'rejected',
      },
    );
  }

  /// ============================================================
  /// CONTRIBUTIONS
  /// ============================================================

Future<String> submitContribution(
  ContributionModel contribution,
) async {

  String supporterId = "guest";

  // If the contributor is logged in, save their user ID.
  // If not, allow them to continue as a guest.
  try {
    final user = await _account.get();
    supporterId = user.$id;
  } catch (_) {
    supporterId = "guest";
  }

  final contributionId = ID.unique();

  final data = contribution.copyWith(
    supporterId: supporterId,
  );

  await _databases.createDocument(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.contributionsCollectionId,
    documentId: contributionId,
    data: data.toMap(),
  );

  return contributionId;
}
  Future<List<ContributionModel>> getProjectContributions(
    String projectId,
  ) async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.contributionsCollectionId,
      queries: [
        Query.equal('projectId', projectId),
        Query.orderDesc('createdAt'),
      ],
    );

    return response.documents
        .map((doc) => ContributionModel.fromMap(doc.data))
        .toList();
  }

  Future<List<ContributionModel>> getPendingContributions() async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.contributionsCollectionId,
      queries: [
        Query.equal('status', 'pending'),
        Query.orderDesc('createdAt'),
      ],
    );

    return response.documents
        .map((doc) => ContributionModel.fromMap(doc.data))
        .toList();
  }

  /// ============================================================
  /// CONTRIBUTION VERIFICATION
  /// ============================================================

Future<void> verifyContribution({
  required ContributionModel contribution,
  required FundraiserModel fundraiser,
}) async {

  final admin = await _account.get();

  await _databases.updateDocument(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.contributionsCollectionId,
    documentId: contribution.id!,
    data: {
      'status': 'verified',
      'verifiedBy': admin.$id,
      'verifiedAt': DateTime.now().toIso8601String(),
    },
  );

  await _databases.updateDocument(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.fundraisingCollectionId,
    documentId: fundraiser.id!,
    data: {
      'currentAmount':
          fundraiser.currentAmount + contribution.amount,
    },
  );
}

Future<void> rejectContribution({
  required String contributionId,
  required String reason,
}) async {

  final admin = await _account.get();

  await _databases.updateDocument(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.contributionsCollectionId,
    documentId: contributionId,
    data: {
      'status': 'rejected',
      'verifiedBy': admin.$id,
      'reviewNotes': reason,
      'verifiedAt': DateTime.now().toIso8601String(),
    },
  );
}
}