import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/common/loader.dart';
import 'package:reddit_flutter/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext contest) {
    final isLoading = ref.watch(communityControllerProvider);
    return isLoading
        ? Loader()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Create a community'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Community name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: communityNameController,
                    cursorColor: Colors.blueAccent,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: InputBorder.none,
                      hintText: 'r/Community_name',
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: createCommunity,
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.blueAccent,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedSuperellipseBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'Create community',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
