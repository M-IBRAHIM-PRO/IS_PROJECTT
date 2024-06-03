import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:is_project/suggestions.dart';
import 'package:usage_stats/usage_stats.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  State<HomePage> createState() => _PageState();
}

class _PageState extends State<HomePage> {
  List<UsageInfo> _unusedApps = [];
  List<ApplicationWithIcon>? _installedApps;

  @override
  void initState() {
    super.initState();
    // Load installed apps and unused apps when the widget initializes
    _loadApps();
    _getUnusedApps();
  }

  // Function to load all installed apps
  Future<void> _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
    );
    setState(() {
      _installedApps = apps.cast<ApplicationWithIcon>();
    });
  }

  // Function to get the list of unused apps for more than 2 days
  Future<void> _getUnusedApps() async {
    // Calculate the date 2 days ago
    DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
    // Get usage stats for the last 2 days
    List<UsageInfo> usageStats =
        await UsageStats.queryUsageStats(twoDaysAgo, DateTime.now());

    setState(() {
      // Filter the usage stats to get only the unused apps for more than 2 days
      _unusedApps = usageStats
          .where((app) =>
              app.packageName != null &&
              app.lastTimeUsed != null &&
              DateTime.parse(app.lastTimeUsed!).isBefore(twoDaysAgo))
          .toList();
    });
  }

  void _openAppSettings(String packageName) {
    DeviceApps.openAppSettings(packageName);
  }

  void _navigateToAnotherPage(BuildContext context) {
    // Navigate to another page when the notification icon button is pressed
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuggestionsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter the installed apps list to get only the ones that have been used
    List<ApplicationWithIcon> usedApps = _installedApps != null
        ? _installedApps!
            .where((app) => !_unusedApps
                .any((unusedApp) => unusedApp.packageName == app.packageName))
            .toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Microphone Checker',
          style: TextStyle(color: Colors.orange[400]),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => _navigateToAnotherPage(context),
            icon: Image.asset('assets/images/icon.png', color: Colors.orange[400]),
          ),
        ],
      ),
      body: Material(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 30, 29, 29),
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: usedApps.length,
              itemBuilder: (context, index) {
                final packageName = usedApps[index].packageName;
                final appName = usedApps[index].appName;
                return ListTile(
                    onTap: () {
                      // Open app settings when the ListTile is tapped
                      _openAppSettings(packageName!);
                    },
                    leading: CircleAvatar(
                      backgroundImage: MemoryImage(usedApps[index].icon),
                    ),
                    title: Text(
                      appName ?? 'Unknown',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(packageName),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Colors.orange[400], size: 15));
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[400],
        onPressed: () {
          // Refresh the list of apps on button press
          _loadApps();
          _getUnusedApps();
        },
        child: Icon(Icons.refresh),
        shape: RoundedRectangleBorder(
          // Change the shape here
          borderRadius:
              BorderRadius.circular(30), // Adjust the border radius as needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // Change this to FloatingActionButtonLocation.endDocked to dock the FAB
    );
  }
}
