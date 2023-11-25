import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fitivation_app/models/dvhc.model.dart';
import 'package:fitivation_app/presentation/complete_account_link.dart';
import 'package:fitivation_app/presentation/fitivation_page.dart';
import 'package:fitivation_app/presentation/login_page.dart';
import 'package:fitivation_app/presentation/profile_page.dart';
import 'package:fitivation_app/presentation/register_page.dart';
import 'package:fitivation_app/presentation/update_profile_page.dart';
import 'package:fitivation_app/provider/model/address.provider.dart';
import 'package:fitivation_app/provider/model/config.provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitivation_app/presentation/splash_screen.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load();
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 1.0 / 3.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset('lib/assets/empty.png'),
                ),
              ),
              Text('Có lỗi xảy ra. Vui lòng quay lại!'),
            ],
          ),
        ),
      );
  Stripe.publishableKey = dotenv.env['PUBLIC_KEY_STRIPE']!;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, WidgetBuilder> routes = {
    '/home': (context) => FitivationPage(),
    '/me': (context) => ProfileScreen(),
    '/signin': (context) => SplashScreen(),
    '/update_profile': (context) => UpdateProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PermissionProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => AddressProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(secondary: Colors.deepOrange),
            textTheme: TextTheme(
                displayLarge: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: Color(0xff000000)))),
        // initialRoute: '/signin',
        // routes: routes,
        home: SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    requestLocationPermission();
    super.initState();
  }

  void _incrementCounter() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("Location accessable");
    } else {
      print("Location inaccessable");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times):',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
