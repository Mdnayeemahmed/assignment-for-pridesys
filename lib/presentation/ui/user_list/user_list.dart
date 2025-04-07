import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class UserListScreen extends StatefulWidget {
  final UserRepository userRepository;
  final AuthService authService;

  const UserListScreen({
    super.key,
    required this.userRepository,
    required this.authService,
  });

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _checkAndUpdateFcmToken();
  }

  Future<void> _checkAndUpdateFcmToken() async {
    if (currentUser != null) {
      try {
        await widget.userRepository.checkAndUpdateFcmToken(currentUser!.uid);
      } catch (e) {
        debugPrint('Error updating FCM token: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackBar(message: 'Failed to update notification token'),
          );
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User List',
        onLogout: () async {
          await widget.authService.signOut();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: StreamBuilder<List<AppUser>>(
          stream: widget.userRepository.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: 'Failed to load users: ${snapshot.error}',
                onRetry: () => setState(() {}),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            }

            final users = snapshot.data ?? [];

            if (users.isEmpty) {
              return const EmptyState(message: 'No users found');
            }

            final currentUserIndex = users.indexWhere((user) => user.uid == currentUser?.uid);
            if (currentUserIndex != -1) {
              final currentUser = users.removeAt(currentUserIndex);
              users.insert(0, currentUser);  // Insert the current user at the start
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  user: user,
                  isCurrentUser: currentUser?.uid == user.uid,
                );
              },
            );
          },
        ),
      ),
    );
  }

}







