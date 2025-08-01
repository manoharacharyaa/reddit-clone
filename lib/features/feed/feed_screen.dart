import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/common/error_text.dart';
import 'package:reddit_flutter/core/common/loader.dart';
import 'package:reddit_flutter/core/common/post_card.dart';
import 'package:reddit_flutter/features/community/controller/community_controller.dart';
import 'package:reddit_flutter/features/posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(userCommunitiesProvider)
        .when(
          data: (data) => ref
              .watch(userPostsProvider(data))
              .when(
                data: (data) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
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
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
