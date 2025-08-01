import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_flutter/core/constants/constants.dart';
import 'package:reddit_flutter/core/failure.dart';
import 'package:reddit_flutter/core/providers/storage_repository_provider.dart';
import 'package:reddit_flutter/core/utils.dart';
import 'package:reddit_flutter/features/auth/controller/auth_controller.dart';
import 'package:reddit_flutter/features/community/repository/community_repository.dart';
import 'package:reddit_flutter/models/community_model.dart';
import 'package:reddit_flutter/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
      final communityRepository = ref.watch(communityRepositoryProvider);
      final storageRepository = ref.watch(storageRepositoryProvider);
      return CommunityController(
        communityRepository: communityRepository,
        ref: ref,
        storageRepository: storageRepository,
      );
    });

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  }) : _communityRepository = communityRepository,
       _ref = ref,
       _storageRepository = storageRepository,
       super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnacBar(context, l.message), (r) {
      showSnacBar(context, 'Community ceated sucessfully');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold((l) => showSnacBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnacBar(context, 'Community left sucessfully');
      } else {
        showSnacBar(context, 'Community joined sucessfully');
      }
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null) {
      //communities/profile/manohar
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) => showSnacBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      //communities/banner/manohar
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnacBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    //when nothing is edited
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnacBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void addMods(
    String communityName,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnacBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
