import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/common/error_text.dart';
import 'package:reddit_flutter/core/common/loader.dart';
import 'package:reddit_flutter/features/auth/controller/auth_controller.dart';
import 'package:reddit_flutter/features/community/controller/community_controller.dart';
import 'package:reddit_flutter/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mode-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref
          .watch(getCommunityByNameProvider(name))
          .when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () {
                                      navigateToModTools(context);
                                    },
                                    style: ButtonStyle(
                                      side: WidgetStatePropertyAll(
                                        BorderSide(color: Colors.blueAccent),
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedSuperellipseBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(20),
                                        ),
                                      ),
                                      padding: WidgetStatePropertyAll(
                                        const EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Mod Tools',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () =>
                                        joinCommunity(ref, community, context),
                                    style: ButtonStyle(
                                      side: WidgetStatePropertyAll(
                                        BorderSide(color: Colors.blueAccent),
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedSuperellipseBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(20),
                                        ),
                                      ),
                                      padding: WidgetStatePropertyAll(
                                        const EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      community.members.contains(user.uid)
                                          ? 'Joined'
                                          : 'Join',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('${community.members.length} members'),
                        ),
                      ]),
                    ),
                  ),
                ];
              },
              body: const Text('Displaying Posts'),
            ),
            error: (error, stackTrace) {
              ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
