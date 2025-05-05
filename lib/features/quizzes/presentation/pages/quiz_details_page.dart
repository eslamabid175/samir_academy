import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/question.dart';
import '../bloc/quizzes_bloc.dart';
import 'quiz_results_page.dart';

class QuizDetailsPage extends StatefulWidget {
  final String quizId;

  const QuizDetailsPage({
    Key? key,
    required this.quizId,
  }) : super(key: key);

  @override
  State<QuizDetailsPage> createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load quiz details when the page is loaded
    BlocProvider.of<QuizzesBloc>(context).add(
      GetQuizDetailsEvent(quizId: widget.quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<QuizzesBloc, QuizzesState>(
          builder: (context, state) {
            if (state is QuizDetailsLoadedState) {
              return Text(state.quiz.title);
            }
            return const Text('Quiz Details');
          },
        ),
      ),
      body: BlocConsumer<QuizzesBloc, QuizzesState>(
        listener: (context, state) {
          if (state is QuizStartedState) {
            // Navigate to the quiz taking screen
            _navigateToQuizTaking(context, state.quiz, state.questions);
          } else if (state is QuizSubmittedState) {
            // Navigate to results page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizResultsPage(result: state.result),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizDetailsLoadingState) {
            return const LoadingWidget();
          } else if (state is QuizDetailsLoadedState) {
            return _buildQuizDetails(state.quiz, state.questions);
          } else if (state is QuizzesErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            // Show mockup quiz details while we implement the real functionality
            return _buildMockQuizDetails();
          }
        },
      ),
    );
  }

  Widget _buildMockQuizDetails() {
    // Mock quiz for demonstration
    final mockQuiz = Quiz(
      id: widget.quizId,
      title: 'Sample Quiz',
      description: 'This is a sample quiz to test your knowledge on the course material. Try your best!',
      courseId: 'course_1',
      courseTitle: 'Introduction to Flutter',
      questionCount: 10,
      duration: 15,
      attempts: 3,
      passingScore: 70.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Mock questions
    final mockQuestions = List.generate(
      10,
      (index) => Question(
        id: 'q_$index',
        quizId: widget.quizId,
        text: 'Sample question ${index + 1}?',
        type: 'multiple_choice',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctAnswer: 'Option A',
        points: 1,
        order: index,
        explanation: 'This is the explanation for the answer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    
    return _buildQuizDetails(mockQuiz, mockQuestions);
  }

  Widget _buildQuizDetails(Quiz quiz, List<Question> questions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.quiz,
                  color: Theme.of(context).primaryColor,
                  size: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        quiz.courseTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Quiz description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quiz.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Quiz stats
          Text(
            'Quiz Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  context, 
                  'Questions', 
                  '${quiz.questionCount} questions',
                  Icons.help_outline,
                ),
                const Divider(),
                _buildInfoRow(
                  context, 
                  'Time Limit', 
                  '${quiz.duration} minutes',
                  Icons.timer,
                ),
                const Divider(),
                _buildInfoRow(
                  context, 
                  'Attempts', 
                  quiz.attempts > 0 ? '${quiz.attempts} attempts allowed' : 'Unlimited attempts',
                  Icons.refresh,
                ),
                const Divider(),
                _buildInfoRow(
                  context, 
                  'Passing Score', 
                  '${quiz.passingScore.toStringAsFixed(0)}%',
                  Icons.grade,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Start quiz button
          CustomButton(
            text: 'Start Quiz',
            onPressed: () {
              // Trigger the quiz start event
              BlocProvider.of<QuizzesBloc>(context).add(
                StartQuizEvent(
                  quiz: quiz,
                  questions: questions,
                ),
              );
            },
            icon: Icons.play_arrow,
          ),
          const SizedBox(height: 16),
          
          // Quiz instructions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: Border.all(color: Colors.amber[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Read each question carefully before answering.\n'
                  '• Once started, the timer cannot be paused.\n'
                  '• You can review your answers before submitting.\n'
                  '• Results will be shown immediately after completion.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _navigateToQuizTaking(BuildContext context, Quiz quiz, List<Question> questions) {
    // We would navigate to a quiz taking screen
    // For now, let's simulate taking a quiz and show some results
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz in Progress'),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Simulating quiz taking...',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'In a real app, you would see the actual quiz questions here.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // Simulate submitting the quiz
                // In a real app, this would happen after answering questions
                final userId = 'current_user_id'; // In a real app, get from auth service
                
                // Mock answers - in a real app, these would be the user's actual answers
                final mockAnswers = <String, dynamic>{};
                for (var question in questions) {
                  if (question.type == 'multiple_choice') {
                    // Simulate correct answers for 70% of questions
                    mockAnswers[question.id] = question.order < (questions.length * 0.7) 
                        ? question.correctAnswer 
                        : question.options.first;
                  } else if (question.type == 'true_false') {
                    mockAnswers[question.id] = true;
                  }
                }
                
                BlocProvider.of<QuizzesBloc>(context).add(
                  SubmitQuizEvent(
                    userId: userId,
                    quizId: quiz.id,
                    quizTitle: quiz.title,
                    answers: mockAnswers,
                    startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
                  ),
                );
              },
              child: const Text('Complete Quiz'),
            ),
          ],
        );
      },
    );
  }
}
