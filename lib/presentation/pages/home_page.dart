



import 'package:carousel_slider/carousel_slider.dart' show CarouselSlider, CarouselOptions;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samir_academy/presentation/pages/settings_page.dart';

import '../../core/utils/dummy_data.dart'; // Keep if carousel uses it
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/courses/domain/entities/category.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/pages/add_category_screen.dart';
import '../../features/courses/presentation/pages/bookmarks_page.dart';
import '../../features/courses/presentation/pages/courses_list_screen.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';
// import 'chat_screen.dart'; // TODO: Import your AI Chat screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentCarouselIndex = 0;
  // Removed _isAdmin state variable
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Category> _allCategories = []; // To store all fetched categories
  List<Category> _filteredCategories = []; // To store filtered categories

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    context.read<CourseBloc>().add(const GetCategoriesEvent());
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

  // Removed _checkAdminStatus function

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Samir Academy'), elevation: 0),
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
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CourseBloc>().add(const GetCategoriesEvent());
          _searchController.clear();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Slider
              if (DummyData.carouselImages.isNotEmpty)
                Column(
                  children: [
                    CarouselSlider(
                      items: DummyData.carouselImages.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                        onPageChanged: (index, reason) {
                          if (mounted) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          }
                        },
                      ),
                    ),
                    // Carousel Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: DummyData.carouselImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentCarouselIndex == entry.key
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              // Categories Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Categories...'.tr(), // Localized hint text
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
                    ),
                    // Categories Title
                    Text(
                      'Categories'.tr(), // Localized title
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Categories Grid
                    _buildCategoriesSection(),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Padding for FABs
            ],
          ),
        ),
      ),
      // Use BlocBuilder<AuthBloc, AuthState> to conditionally show admin FAB
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // AI Chat FAB (Left side)
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

            // Add Category FAB (Right side - wrapped in BlocBuilder)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                // Show FAB only if authenticated and user is admin
                if (authState is AuthAuthenticated && authState.user.isAdmin) {
                  return FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CourseBloc>(context),
                            child: const AddCategoryScreen(),
                          ),
                        ),
                      );
                      if (result == true && mounted) {
                        context.read<CourseBloc>().add(const GetCategoriesEvent());
                        _searchController.clear();
                      }
                    },
                    tooltip: 'Add Category'.tr(), // Localized tooltip
                    heroTag: 'fab_add_category',
                    child: const Icon(Icons.add),
                  );
                } else {
                  // Return an empty container if not admin
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCategoriesSection() {
    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CategoryLoaded) {
          if (mounted) {
            setState(() {
              _allCategories = state.categories;
              _filterCategories();
            });
          }
        }
      },
      child: BlocBuilder<CourseBloc, CourseState>(
        buildWhen: (previous, current) =>
        current is CategoryListLoading ||
            current is CategoryLoaded ||
            current is CategoryError,
        builder: (context, state) {
          if (state is CategoryListLoading && _allCategories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryError && _allCategories.isEmpty) {
            return Center(
              child: Text('Error loading categories: ${state.message}'.tr()), // Localized error
            );
          }
          if (_filteredCategories.isEmpty && _searchQuery.isNotEmpty) {
            return Center(child: Text('No categories match your search.'.tr())); // Localized message
          }
          if (_allCategories.isEmpty && state is! CategoryListLoading) {
            return Center(child: Text('No categories found.'.tr())); // Localized message
          }

          return _buildCategoriesGrid(_filteredCategories);
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, index) {
        return _buildCategoryItem(categories[index]);
      },
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesListScreen(categoryId: category.id, categoryName: category.name),
          ),
        );
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

// Ensure CoursesListScreen accepts categoryName (add if needed)
/*
class CoursesListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName; // Add this

  const CoursesListScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use categoryName in AppBar
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      // ... rest of the build method
    );
  }
}
*/

