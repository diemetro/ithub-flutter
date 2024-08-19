import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/welcome_view.dart';
import 'views/shopping_list_view.dart';
import 'views/favorites_view.dart';
import 'views/profile_view.dart';
import 'views/add_shopping_view.dart';
import 'views/login_view.dart';
import 'viewmodels/shopping_list_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/settings_view.dart';
import 'views/help_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'Shopping Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => WelcomeView(),
          '/profile': (context) => ProfileView(),
          '/favorites': (context) => FavoritesView(),
          '/add': (context) => AddShoppingView(),
          '/login': (context) => LoginView(),
          '/settings': (context) => SettingsView(),
          '/help': (context) => HelpView(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return authViewModel.isLoggedIn ? HomeScreen() : LoginView();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ShoppingListView(),
    FavoritesView(),
    ProfileView(),
    SettingsView(),
    HelpView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthViewModel>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Shopping Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
