import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samir_academy/features/books/presentation/pages/books_page.dart';
import 'package:samir_academy/features/quizzes/presentation/pages/quizzes_page.dart';
import 'package:samir_academy/presentation/pages/home_page.dart';
import 'package:samir_academy/presentation/pages/settings_page.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/courses/domain/entities/category.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/pages/bookmarks_page.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';

class PreHome extends StatefulWidget {
  const PreHome({super.key});
  static List<Category> categories = [
    Category(
      id: 'c1',
      name: 'Courses',
      imageUrl: 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',

    ),
    Category(
      id: 'c2',
      name: 'Books',
      imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',

    ),
    Category(
      id: 'c3',
      name: 'Quizzes',
      imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',

    ),
    Category(
      id: 'c4',
      name: 'Flash Cards',
      imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',

    ),

  ];

  @override
  State<PreHome> createState() => _PreHomeState();
}

class _PreHomeState extends State<PreHome> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Category> _allCategories = []; // To store all fetched categories
  List<Category> _filteredCategories = []; // To store filtered categories

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
   // context.read<CourseBloc>().add(const GetCategoriesEvent());
    // Removed _checkAdminStatus call
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Use mounted check before calling setState
    if (mounted) {
      setState(() {
        _searchQuery = _searchController.text;
        _filterCategories();
      });
    }
  }

  void _filterCategories() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      _filteredCategories = _allCategories
          .where((category) =>
          category.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Samir Academy'),
        elevation :0,
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? 'Guest'),
                accountEmail: Text(user?.email ?? 'Not signed in'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? const Icon(Icons.person) : null,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: Text('my_courses'.tr()),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyCoursesPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: Text('bookmarks'.tr()),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookmarksPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text('settings'.tr()),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text('privacy_policy'.tr()),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Fluttertoast.showToast(msg: 'Privacy Policy not implemented yet');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text('about_us'.tr()),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Fluttertoast.showToast(msg: 'About Us not implemented yet');
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(user == null ? Icons.login : Icons.logout),
                title: Text(user == null ? 'login'.tr() : 'logout'.tr()),
                onTap: () async {
                  Navigator.pop(context); // Close drawer
                  if (user == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  } else {
                    context.read<AuthBloc>().add(LogOutEvent());
                    final authBloc = context.read<AuthBloc>();
                    final currentState = authBloc.state;
                    if (currentState is! AuthInitial) {
                      await authBloc.stream.firstWhere((state) => state is AuthInitial);
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const PreHome()),
                          (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSearchBar(),
            _buildCategoriesGrid(),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation to AI Chat screen
          Fluttertoast.showToast(msg: 'AI Chat Tapped!');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
        },
        tooltip: 'Chat with AI'.tr(), // Localized tooltip
        heroTag: 'fab_chat',
        child: const Icon(Icons.smart_toy_outlined),
      ),
    );
  }
  Widget _buildSearchBar(){
    return              // Search Bar
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search EveryThing...', // Localized hint text
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800] // Dark mode color
                : Colors.grey[200], // Light mode color
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            )
                : null,
          ),
        ),
      );
  }

  Widget _buildCategoriesGrid() {
    return SafeArea(
      child: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: PreHome.categories.length,
          itemBuilder: (ctx, index) {
            return _buildCategoryItem(PreHome.categories[index], ctx);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Category category,BuildContext context) {
    return GestureDetector(
      onTap: (){
        switch (category.id) {
          case 'c1': // Courses
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
            break;
          case 'c2': // Books
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BooksPage(),
              ),
            );
            break;
          case 'c3': // Quizzes
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizzesPage(),
              ),
            );
            break;
          case 'c4': // Flash Cards
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizzesPage(),
              ),
            );
            break;
          default:
          // Fallback in case category id doesn't match
            Fluttertoast.showToast(msg: 'Unknown category selected');
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading category image: $error');
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                category.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black54,
                        offset: Offset(1.0, 1.0),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
