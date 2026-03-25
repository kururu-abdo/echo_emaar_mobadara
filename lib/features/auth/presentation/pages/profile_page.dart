import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/extensions.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/features/invoice/presentation/pages/invoice_page.dart';
import 'package:echoemaar_commerce/features/orders/presentation/pages/order_history_page.dart';
import 'package:echoemaar_commerce/features/settings/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/entities/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/entities/user.dart';
import '../../../../config/routes/route_names.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Logout happened → clear stack → login
          while (context.canPop()) context.pop();
          context.goNamed(RouteNames.login);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return _ProfileView(user: state.user);
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  final User user;

  const _ProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: colors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => context.pushNamed(RouteNames.settings),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),

                    // Avatar
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white,
                            backgroundImage:
                            //  user.imageUrl != null
                            //     ? CachedNetworkImageProvider(user.imageUrl!)
                            //     :
                                
                                 null,
                            child:
                            
                            //  user.imageUrl == null
                            //     ?
                                 Text(
                                    user.username[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: colors.primary,
                                    ),
                                  )
                                // : null,
                          ),
                        ),
                        // Edit icon overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.secondary,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Verified badge

                    /*
                    if (user.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified_rounded,
                                size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Verified',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                  */
                  ],
                ),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: spacing.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spacing.verticalLG,

                  // ── Contact info ───────────────────────────
                  const _SectionLabel(label: 'Contact Information'),
                  spacing.verticalSM,
                  _InfoCard(
                    items: [
                      _InfoItem(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        value: user.email,
                      ),
                      _InfoItem(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        value: user.email,
                        trailing:
                        /*
                         user.isVerified
                            ? Icon(Icons.verified_rounded,
                                size: 18, color: colors.success)
                            :
                            */
                             Icon(Icons.info_outline,
                                size: 18, color: colors.warning),
                      ),
                    ],
                  ),

                  spacing.verticalLG,

                  // ── Account ────────────────────────────────
                  const _SectionLabel(label: 'Account'),
                  spacing.verticalSM,
                  _ActionCard(
                    items: [
                      _ActionItem(
                        icon: Icons.edit_outlined,
                        label: 'Edit Profile',
                        onTap: () {
                          // TODO: navigate to edit profile
                        },
                      ),
                      _ActionItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'My Orders',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_)=> const OrderHistoryPage())
                          );
                        },
                      ),
 _ActionItem(
                        icon: Icons.receipt,
                        label: 'My Invoices',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_)=> const InvoicesPage())
                          );
                        },
                      ),

                      _ActionItem(
                        icon: Icons.location_on_outlined,
                        label: 'Saved Addresses',
                        onTap: () {
                          // TODO: navigate to addresses
                        },
                      ),
                    ],
                  ),

                  spacing.verticalLG,

                  // ── Preferences ────────────────────────────
                  const _SectionLabel(label: 'Preferences'),
                  spacing.verticalSM,
                  _ActionCard(
                    items: [
                      _ActionItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                      _ActionItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const SettingsPage( )));
                        }
                      ),
                    ],
                  ),

                  spacing.verticalXL,

                  // ── Logout ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: Icon(Icons.logout_rounded, color: colors.error),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                            color: colors.error, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              context.shapes.borderRadiusSmall),
                        ),
                      ),
                    ),
                  ),

                  spacing.verticalXL,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: Text('Logout',
                style: TextStyle(color: context.colors.error)),
          ),
        ],
      ),
    );
  }
Widget _buildCircularAvatar(BuildContext context) {
  final colors = context.colors; //
  
  return Container(
    padding: const EdgeInsets.all(4), // Space for the outer white border
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
      boxShadow: [
        BoxShadow(
          color: colors.primaryGlow, // rgba(29, 111, 164, 0.18)
          blurRadius: 20,
          spreadRadius: 5,
        ),
      ],
    ),
    child: CircleAvatar(
      radius: 50,
      backgroundColor: colors.surface, //
      // Use the user entity we established in the profile page
      child: Text(
        user.username[0].toUpperCase(),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colors.primary, //
        ),
      ),
      // To add the actual image later:
      // backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
    ),
  );
}


  // Inside _ProfileView build
Widget _buildLuxuryHeader(BuildContext context) {
  final colors = context.colors;
  return SliverAppBar(
    expandedHeight: 260,
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF162D45), Color(0xFF081525)],
              ),
            ),
          ),
          // Radial Glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: RadialGradient(
                center: const Alignment(0, -0.5),
                radius: 1.0,
                colors: [colors.primary.withOpacity(0.15), Colors.transparent],
              ).toDecoration(),
            ),
          ),
          // Profile Details
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularAvatar(context),
                const SizedBox(height: 16),
                Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

// ── Helpers ────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;

  _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
              color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(.1),
                    borderRadius:
                        BorderRadius.circular(shapes.borderRadiusSmall),
                  ),
                  child: Icon(item.icon, color: colors.primary, size: 18),
                ),
                title: Text(item.title,
                    style: TextStyle(
                        color: colors.textSecondary, fontSize: 12)),
                subtitle: Text(item.value,
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                trailing: item.trailing,
              ),
              if (i < items.length - 1)
                Divider(height: 1, color: colors.divider,
                    indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final List<_ActionItem> items;

  const _ActionCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
              color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(.1),
                    borderRadius:
                        BorderRadius.circular(shapes.borderRadiusSmall),
                  ),
                  child: Icon(item.icon, color: colors.primary, size: 18),
                ),
                title: Text(item.label,
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right,
                    color: colors.textSecondary, size: 20),
                onTap: item.onTap,
              ),
              if (i < items.length - 1)
                Divider(height: 1, color: colors.divider,
                    indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}