import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/quiz_result.dart';
import '../bloc/quizzes_bloc.dart';

class QuizResultsPage extends StatefulWidget {
  final QuizResult result;

  const QuizResultsPage({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize confetti controller for celebration effect
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Play confetti if the score is passing (above 70%)
    if (widget.result.score != null && widget.result.score! >= 70) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassing = widget.result.score != null && widget.result.score! >= 70;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Confetti widget
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                  ),
                ),
                
                // Quiz title
                Text(
                  widget.result.quizTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Score circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPassing ? Colors.green : Colors.red,
                      width: 10,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.result.score?.toStringAsFixed(0) ?? 0}%',
                          style: Theme.of(context).textTheme.headlineMedium ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isPassing ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          isPassing ? 'Passed' : 'Failed',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isPassing ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quiz statistics
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        context, 
                        'Questions', 
                        '${widget.result.totalQuestions ?? 0} questions',
                        Icons.help_outline,
                      ),
                      const Divider(),
                      _buildStatRow(
                        context, 
                        'Correct Answers', 
                        '${widget.result.correctAnswers ?? 0} correct',
                        Icons.check_circle_outline,
                      ),
                      const Divider(),
                      _buildStatRow(
                        context, 
                        'Completion Time', 
                        '${widget.result.durationInMinutes} minutes',
                        Icons.timer,
                      ),
                      const Divider(),
                      _buildStatRow(
                        context, 
                        'Completed', 
                        _formatDate(widget.result.completedAt ?? DateTime.now()),
                        Icons.event,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Feedback message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isPassing ? Colors.green[50] : Colors.red[50],
                    border: Border.all(
                      color: isPassing ? Colors.green[200]! : Colors.red[200]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isPassing ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                        size: 48,
                        color: isPassing ? Colors.amber : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isPassing
                            ? 'Congratulations! You have passed the quiz.'
                            : 'Don\'t worry! You can try again to improve your score.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'View Answers',
                        onPressed: () {
                          // Navigate to detailed answers page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('View Answers feature will be implemented soon'),
                            ),
                          );
                        },
                        type: ButtonType.outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Done',
                        onPressed: () {
                          // Navigate back to the quizzes list
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ],
                ),
                
                if (!isPassing) ...[
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Retry Quiz',
                    onPressed: () {
                      // Navigate back to the quiz details page
                      Navigator.of(context).pop();
                    },
                    icon: Icons.replay,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
