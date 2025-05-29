import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool incognitoMode = false;
  bool pushNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {},
                  ),
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 48), // Balance for the X button
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBA68C8),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'O',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ojb11200770002',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal.shade300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Pro Banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blue.shade900,
                                  Colors.orange.shade800,
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Background image would go here
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Book image placeholder
                                      Container(
                                        width: 100,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.menu_book, size: 40, color: Colors.white),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'perplexity',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 4),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'pro',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold, 
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Upgrade to the latest AI models and boost',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'your Pro Search uses',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Learn More Button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Learn more',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Settings Options
                    _buildSettingItem(
                      icon: Icons.visibility_off,
                      title: 'Incognito Mode',
                      isSwitch: true,
                      switchValue: incognitoMode,
                      onSwitchChanged: (value) {
                        setState(() {
                          incognitoMode = value;
                        });
                      },
                    ),
                    _buildSettingItem(
                      icon: Icons.calendar_month,
                      title: 'Reservations',
                    ),
                    _buildSettingItem(
                      icon: Icons.dark_mode,
                      title: 'Theme & App Icon',
                    ),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: 'App Language',
                    ),
                    _buildSettingItem(
                      icon: Icons.volume_up,
                      title: 'Voice & Language',
                    ),
                    _buildSettingItem(
                      icon: Icons.tune,
                      title: 'Personalize',
                      hasBlueIndicator: true,
                    ),
                    _buildSettingItem(
                      icon: Icons.location_on,
                      title: 'Location',
                    ),
                    _buildSettingItem(
                      icon: Icons.notifications,
                      title: 'Push Notifications',
                      isSwitch: true,
                      switchValue: pushNotifications,
                      onSwitchChanged: (value) {
                        setState(() {
                          pushNotifications = value;
                        });
                      },
                    ),
                    
                    // Help & Support Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'Help & Support',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildSettingItem(title: 'Get started'),
                    _buildSettingItem(title: 'Pro Search'),
                    _buildSettingItem(title: 'Help & FAQ'),
                    
                    // Follow Us Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'Follow Us',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    // Podcast Item
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [Colors.purple.shade300, Colors.blue.shade300, Colors.orange.shade300],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Discover Daily Podcast',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Dive into tech, science, and culture.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                    
                    // Social Links
                    _buildSettingItem(icon: Icons.close, title: 'X'),
                    _buildSettingItem(title: 'Discord'),
                    
                    // Privacy Policy
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    IconData? icon,
    required String title,
    bool isSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    bool hasBlueIndicator = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (hasBlueIndicator)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                shape: BoxShape.circle,
              ),
            ),
          if (isSwitch)
            Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.teal.shade300,
            )
          else
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}