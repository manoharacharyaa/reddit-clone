import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/common/error_text.dart';
import 'package:reddit_flutter/core/common/loader.dart';
import 'package:reddit_flutter/core/common/post_card.dart';
import 'package:reddit_flutter/features/auth/controller/auth_controller.dart';
import 'package:reddit_flutter/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(getUserDataProvider(uid))
          .when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(
                            20,
                          ).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () => navigateToEditUser(context),
                            style: ButtonStyle(
                              side: WidgetStatePropertyAll(
                                BorderSide(color: Colors.blueAccent),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedSuperellipseBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    20,
                                  ),
                                ),
                              ),
                              padding: WidgetStatePropertyAll(
                                const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('${user.karma} karma'),
                          ),
                          const SizedBox(height: 10),
                          const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  ),
                ];
              },

              body: ref
                  .watch(getUserPostsProvider(user.uid))
                  .when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) {
              ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
