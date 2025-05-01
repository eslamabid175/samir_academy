import '../../features/courses/domain/entities/category.dart';
import '../../features/courses/domain/entities/course.dart';

class DummyData {
  static List<String> carouselImages = [
    'https://images.unsplash.com/photo-1588072432836-e10032774350?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ];

  static List<Category> categories = [
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

  static List<Course> courses = [
    // Medicine Courses
    Course(
      id: 'm1',
      title: 'Introduction to Anatomy',
      description: 'Learn the basics of human anatomy in this comprehensive course.',
      categoryId: 'c1',
      imageUrl: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'm2',
      title: 'Medical Ethics',
      description: 'Explore the ethical considerations in modern medicine.',
      categoryId: 'c1',
      imageUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'm3',
      title: 'Pharmacology Basics',
      description: 'Understanding how drugs work in the human body.',
      categoryId: 'c1',
      imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),

    // Engineering Courses
    Course(
      id: 'e1',
      title: 'Structural Engineering',
      description: 'Learn about designing and analyzing structures.',
      categoryId: 'c2',
      imageUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'e2',
      title: 'Electrical Circuits',
      description: 'Understanding the fundamentals of electrical circuits.',
      categoryId: 'c2',
      imageUrl: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),

    // Business Courses
    Course(
      id: 'b1',
      title: 'Marketing Strategies',
      description: 'Learn effective marketing techniques for modern businesses.',
      categoryId: 'c3',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'b2',
      title: 'Financial Management',
      description: 'Master the principles of financial management and analysis.',
      categoryId: 'c3',
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),

    // Computer Science Courses
    Course(
      id: 'cs1',
      title: 'Introduction to Programming',
      description: 'Learn the basics of programming with Python.',
      categoryId: 'c4',
      imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'cs2',
      title: 'Data Structures and Algorithms',
      description: 'Master the essential data structures and algorithms.',
      categoryId: 'c4',
      imageUrl: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),

    // Arts Courses
    Course(
      id: 'a1',
      title: 'Digital Photography',
      description: 'Learn the art of digital photography and editing.',
      categoryId: 'c5',
      imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'a2',
      title: 'Painting Techniques',
      description: 'Explore various painting styles and techniques.',
      categoryId: 'c5',
      imageUrl: 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),

    // Languages Courses
    Course(
      id: 'l1',
      title: 'Spanish for Beginners',
      description: 'Start your journey to learn Spanish from scratch.',
      categoryId: 'c6',
      imageUrl: 'https://images.unsplash.com/photo-1551018612-9715965c6742?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    Course(
      id: 'l2',
      title: 'Advanced French',
      description: 'Take your French language skills to the next level.',
      categoryId: 'c6',
      imageUrl: 'https://images.unsplash.com/photo-1549737221-bef65e2604a6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
  ];

  static List<Course> getCoursesByCategory(String categoryId) {
    return courses.where((course) => course.categoryId == categoryId).toList();
  }
}