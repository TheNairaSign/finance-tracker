// ignore_for_file: deprecated_member_use

import 'package:card_loading/card_loading.dart';
import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  List<ProfileListItems> profileListItems = [];

  @override
  void initState() {
    super.initState();
    profileListItems = ProfileListItems.profileListItems();
  }

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(getUserDataProvider);
    final transactionState = ref.watch(transactionNotifierProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
            title: Text('Account', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actionsPadding: EdgeInsets.symmetric(horizontal: 10),
            actions: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withValues(alpha: .2)
                ),
                child: Badge.count(
                  count: 2,
                  child: SvgPicture.asset('assets/svgs/profile/notification.svg', color: Colors.white),
                ),
              )
            ],
          backgroundColor: Color(0xFF171f32),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.only(top: 120),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileData.value?.photoURL ?? 'https://via.placeholder.com/150'),
                    onBackgroundImageError: (exception, stackTrace) => _getInitials(profileData.value?.displayName),
                  ),
                  SizedBox(height: 10),
                  Text('${profileData.value?.displayName}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                Text('${profileData.value?.email}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFF171f32),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('Current Budget', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('USD', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10))
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      profileData.when(
                        data: (user) {
                          return RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: '\$', style: GoogleFonts.poppins(fontSize: 25)),
                                TextSpan(text: user?.budget.toString(), style: GoogleFonts.poppins(fontSize: 25))
                              ]
                            )
                          );
                        },
                        error: (error, stack) {
                          return RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: '\$', style: GoogleFonts.poppins(fontSize: 40)),
                                TextSpan(text: '0', style: GoogleFonts.poppins(fontSize: 40))
                              ]
                            )
                          );
                        },
                        loading: () => CardLoading(
                          height: 20,
                          width: 50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ]
                  ),
                ),
                const SizedBox(height: 15),
                Text('Overall Transactions', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                transactionState.maybeWhen(
                  loaded: (transactions) {
                    final double incomeSum = transactions.where((txn) => txn.type == TransactionType.income).fold(0, (sum, transaction) => sum + transaction.amount);
                    final double expenseSum = transactions.where((txn) => txn.type == TransactionType.expense).fold(0, (sum, transaction) => sum + transaction.amount);
                    return Row(
                      spacing: 15,
                      children: [
                        Expanded(child: TransactionCard(amount: incomeSum.toString(), type: TransactionType.income)),
                        Expanded(child: TransactionCard(amount: expenseSum.toString(), type: TransactionType.expense)),
                      ],
                    );
                  },
                  orElse: () => Row(
                    children: [
                      Expanded(
                        child: CardLoading(
                          height: 80,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Expanded(
                        child: CardLoading(
                          height: 80,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Profile Settings', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: List.generate(profileListItems.length, (index) {
                      final item = profileListItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(item.label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)),
                        leading: item.color == null? null : CircleAvatar(
                          backgroundColor: item.color?.withValues(alpha: 0.3),
                          child: SvgPicture.asset(item.asset, height: 24, width: 24, color: item.color),
                        ),
                        trailing: item.isLogout? null : Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15),
                        onTap: item.isLogout ? () => _showSignOutDialog(context) : item.onTap,
                      );
                    }),
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool?> _showSignOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Sign Out"),
          ),
        ],
      );
    },
  );
}

String _getInitials(String? name) {
  if (name == null || name.isEmpty) return "JD";
  final words = name.split(" ");
  if (words.length >= 2) {
    return "${words[0][0]}${words[1][0]}".toUpperCase();
  }
  return name[0].toUpperCase();
}

// String _formatDate(DateTime? date) {
//   if (date == null) return "Unknown";
//   return DateFormat.yMMMd().format(date.toLocal());
// }

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key, required this.profileItem});
  final ProfileListItems profileItem;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProfileListItems {
  final Color? color;
  final String asset, label;
  final bool isLogout;
  final Function()? onTap;

  const ProfileListItems({
    required this.color,
    required this.label,
    required this.asset,
    this.isLogout = false,
    required this.onTap,
  });

  static List<ProfileListItems> profileListItems() {
    List<ProfileListItems> listItems = [];
    final asset = 'assets/svgs/profile';

    listItems.add(
      ProfileListItems(
        color: Colors.blue, 
        asset: '$asset/account.svg', 
        label: 'Personal Info', 
        onTap: () {}
      )
    );
    listItems.add(
      ProfileListItems(
        color: Colors.green, 
        label: 'Security', 
        asset: '$asset/lock.svg', 
        onTap: () {}
      )
    );
    listItems.add(
      ProfileListItems(
        color: Colors.purple, 
        label: 'Notification', 
        asset: '$asset/notification.svg', 
        onTap: () {}
      )
    );
    listItems.add(
      ProfileListItems(
        color: Color(0xff9eb720), 
        label: 'Legal', 
        asset: '$asset/document.svg', 
        onTap: () {}
      )
    );
    listItems.add(
      ProfileListItems(
        color: Colors.pink, 
        label: 'Help & Support', 
        asset: '$asset/help.svg', 
        onTap: () {}
      )
    );
    return listItems;
  }
}