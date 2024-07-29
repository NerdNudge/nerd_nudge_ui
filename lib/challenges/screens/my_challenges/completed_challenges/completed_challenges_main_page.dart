import 'package:flutter/material.dart';
import '../../../services/my_challenges_service/my_challenges_service.dart';
import '../../utilities/challenge_utils.dart';
import 'completed_challenge_drill_down.dart';

class MyCompletedChallenges extends StatelessWidget {
  const MyCompletedChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final completedChallenges =
        MyChallengesService().getMyCompletedChallenges();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          ...completedChallenges.map((challenge) {
            return Column(
              children: [
                ChallengeUtils.getMyChallengeCard(
                  challenge: challenge,
                  onTap: () {
                    print('Challenge ${challenge['type']} selected');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Challenge ${challenge['type']} selected'),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCompletedChallengeDrillDown(
                          challenge: challenge,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
