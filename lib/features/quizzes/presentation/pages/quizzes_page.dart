import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/quiz.dart';
import '../bloc/quizzes_bloc.dart';
import 'quiz_details_page.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({Key? key}) : super(key: key);

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch quizzes when the page is loaded
    BlocProvider.of<QuizzesBloc>(context).add(GetQuizzesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to quiz history/results page
              // TODO: Implement navigation to quiz results
              final userId = 'current_user_id'; // In real app, get from auth service
              
              BlocProvider.of<QuizzesBloc>(context).add(
                GetUserQuizResultsEvent(userId: userId),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<QuizzesBloc, QuizzesState>(
        builder: (context, state) {
          if (state is QuizzesLoadingState) {
            return const LoadingWidget();
          } else if (state is QuizzesLoadedState) {
            if (state.quizzes.isEmpty) {
              return const Center(
                child: Text('No quizzes available at the moment.'),
              );
            }
            return _buildQuizzesList(state.quizzes);
          } else if (state is QuizzesErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text('No quizzes available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuizzesList(List<Quiz> quizzes) {
    // Group quizzes by course
    final Map<String, List<Quiz>> quizzesByCourse = {};
    
    for (var quiz in quizzes) {
      if (!quizzesByCourse.containsKey(quiz.courseId)) {
        quizzesByCourse[quiz.courseId] = [];
      }
      quizzesByCourse[quiz.courseId]!.add(quiz);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: quizzesByCourse.keys.length,
      itemBuilder: (context, index) {
        final courseId = quizzesByCourse.keys.elementAt(index);
        final courseQuizzes = quizzesByCourse[courseId]!;
        final courseTitle = courseQuizzes.first.courseTitle;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                courseTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...courseQuizzes.map((quiz) => _buildQuizCard(quiz)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildQuizCard(Quiz quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToQuizDetails(quiz),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${quiz.questionCount} questions • ${quiz.duration} min',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!quiz.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Inactive',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                quiz.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_score, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Passing score: ${quiz.passingScore.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.refresh, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        quiz.attempts > 0 ? 'Attempts: ${quiz.attempts}' : 'Unlimited attempts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToQuizDetails(Quiz quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailsPage(quizId: quiz.id),
      ),
    );
  }
}
