import 'package:cloud_firestore/cloud_firestore.dart';
import 'generic_item_dto.dart';

/// Centralized registry for all Cloud Firestore collection references and paths.
class AppCollections {
  /// Items collection path name.
  static const String items = 'items';

  /// Users collection path name.
  static const String users = 'users';

  /// System settings collection path name.
  static const String settings = 'settings';

  final FirebaseFirestore _firestore;

  /// Creates an [AppCollections] registry bound to the provided [_firestore] instance.
  ///
  /// - [_firestore]: The Firestore instance to derive collections from.
  AppCollections(this._firestore);

  /// Strongly-typed items collection reference using withConverter.
  ///
  /// Returns a [CollectionReference] typed to [GenericItemDto].
  CollectionReference<GenericItemDto> get itemsRef =>
      _firestore.collection(items).withConverter<GenericItemDto>(
        fromFirestore: (snapshot, _) => GenericItemDto.fromFirestore(snapshot),
        toFirestore: (dto, _) => dto.toFirestore(),
      );

  /// Resolves a reference to a specific user document by unique identifier.
  ///
  /// - [uid]: The user document ID.
  /// Returns a [DocumentReference] pointing to the user document.
  DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      _firestore.collection(users).doc(uid);
}
