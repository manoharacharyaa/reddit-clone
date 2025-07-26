import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_flutter/core/constants/firebase_constants.dart';
import 'package:reddit_flutter/core/failure.dart';
import 'package:reddit_flutter/core/providers/firebase_provider.dart';
import 'package:reddit_flutter/core/type_defs.dart';
import 'package:reddit_flutter/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
