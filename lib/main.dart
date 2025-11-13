import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_sync/screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'nw2nSyBDeqq2VR7cbQ41SvZvD6rf4IyawTAeflNm', // Application ID
    'https://parseapi.back4app.com', // Server URL
    clientKey: 'jFN5aUagSN6ZwqPQqLTf98ZWtBJLTzXMIrzOp0R0', // Client Key
    autoSendSessionId: true,
    debug: true,
    liveQueryUrl: 'wss://task-sync.back4app.io',
  );
  final healthCheck = await Parse().healthCheck();
  print(
    'Parse Server connection: ${healthCheck.success ? '✅ Connected' : '❌ Failed'}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'TaskSync',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthScreen(),
      ),
    );
  }
}
