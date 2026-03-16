
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/themes/theme_provider.dart';
import '../../../../config/themes/brand_config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: context.spacing.pagePadding(context),
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  secondary: Icon(
                    themeProvider.isDarkMode 
                        ? Icons.dark_mode 
                        : Icons.light_mode,
                  ),
                ),
                
                const Divider(height: 1),
                
                ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
                  leading: const Icon(Icons.palette),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeModeDialog(context, themeProvider),
                ),
              ],
            ),
          ),
          
          context.spacing.verticalLG,
          
          // Brand Info Section (for demo/testing)
          if (const String.fromEnvironment('ENV') == 'development') ...[
            _buildSectionHeader(context, 'Brand Configuration (Dev Only)'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Current Brand'),
                    subtitle: Text(themeProvider.brandConfig.brandName),
                    leading: const Icon(Icons.business),
                  ),
                  
                  const Divider(height: 1),
                  
                  ListTile(
                    title: const Text('Change Brand'),
                    subtitle: const Text('Switch between brand themes'),
                    leading: const Icon(Icons.swap_horiz),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showBrandSwitcherDialog(context, themeProvider),
                  ),
                ],
              ),
            ),
            
            context.spacing.verticalLG,
          ],
          
          // App Info Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info),
                ),
                
                const Divider(height: 1),
                
                ListTile(
                  title: const Text('Privacy Policy'),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                
                const Divider(height: 1),
                
                ListTile(
                  title: const Text('Terms of Service'),
                  leading: const Icon(Icons.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.spacing.sm,
        bottom: context.spacing.sm,
        top: context.spacing.md,
      ),
      child: Text(
        title,
        style: TextStyles.bodySmall(context).copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
  
  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }
  
  void _showThemeModeDialog(BuildContext context, ThemeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  provider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  provider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  provider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showBrandSwitcherDialog(BuildContext context, ThemeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Default Brand'),
              onTap: () {
                provider.setBrandConfig(BrandConfig.defaultBrand);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fashion Store (Client A)'),
              onTap: () {
                provider.setBrandConfig(BrandConfig.clientA);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tech Gadgets (Client B)'),
              onTap: () {
                provider.setBrandConfig(BrandConfig.clientB);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}