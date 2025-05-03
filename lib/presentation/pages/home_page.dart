



import 'package:carousel_slider/carousel_slider.dart' show CarouselSlider, CarouselOptions;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:samir_academy/features/courses/presentation/pages/course_list_page.dart';
import 'package:samir_academy/presentation/pages/settings_page.dart';

import '../../core/utils/dummy_data.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/courses/domain/entities/category.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/pages/bookmarks_page.dart';
import '../../features/courses/presentation/pages/courses_list_screen.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;


    return Scaffold(
      appBar: AppBar(title: const Text('Samir Academy'),elevation: 0,),
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
                Fluttertoast.showToast(msg: 'Privacy Policy not implemented yet');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('about_us'.tr()),
              onTap: () {
                Fluttertoast.showToast(msg: 'About Us not implemented yet');
              },
            ),
            ListTile(
              leading: Icon(user == null ? Icons.login : Icons.logout),
              title: Text(user == null ? 'login'.tr() : 'logout'.tr()),
              onTap: () async {
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  context.read<AuthBloc>().add(LogOutEvent());
                  // Wait for the logout process to complete before navigating
                  context.read<AuthBloc>().stream.firstWhere((state) => state is AuthInitial).then((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false, // Clear navigation stack after logout
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  setState(() {
                    _currentCarouselIndex = index;
                  });
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
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoriesGrid(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

  }


  Widget _buildCategoriesGrid() {
    final List<Category> categories = [
      Category(
        id: 'c1',
        name: 'Medicine',
        imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
      Category(
        id: 'c2',
        name: 'Engineering',
        imageUrl: 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
      Category(
        id: 'c3',
        name: 'Business',
        imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
      Category(
        id: 'c4',
        name: 'Computer Science',
        imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
      Category(
        id: 'c5',
        name: 'Arts',
        imageUrl: 'https://images.unsplash.com/photo-1452802447250-470a88ac82bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
      Category(
        id: 'c6',
        name: 'Languages',
        imageUrl: 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      ),
    ];
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
        BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent(categoryId: category.id));
        Navigator.push(
          context,
            MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CourseBloc>(context),
                            child: CoursesListScreen(categoryId: category.id),
                          ),
                        ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(category.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ],
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Samir Academy'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Carousel Slider
//
//
//             // Categories Section Title
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Text(
//                 'Categories',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             // Categories GridView
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Number of columns
//                   crossAxisSpacing: 8.0,
//                   mainAxisSpacing: 8.0,
//                   childAspectRatio: 1.0, // Adjust aspect ratio (width/height)
//                 ),
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return InkWell(
//                     onTap: () {
//                       BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent(categoryId: category.id));
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BlocProvider.value(
//                             value: BlocProvider.of<CourseBloc>(context),
//                             child: CoursesListScreen(categoryId: category.id),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 2.0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
//                               child: Image.network(
//                                 category.imageUrl,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                 const Center(child: Icon(Icons.broken_image, size: 40)),
//                                 loadingBuilder: (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return const Center(child: CircularProgressIndicator());
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               category.name,
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20), // Add some spacing at the bottom
//           ],
//         ),
//       ),
//     );
//   }
// }
//




