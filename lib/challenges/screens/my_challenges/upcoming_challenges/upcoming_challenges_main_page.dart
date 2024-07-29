import 'package:flutter/material.dart';
import '../../../services/my_challenges_service/my_challenges_service.dart';
import '../../explore_challenges/challenge_details.dart';
import '../../utilities/challenge_utils.dart';

class MyUpcomingChallenges extends StatelessWidget {
  const MyUpcomingChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final completedChallenges =
        MyChallengesService().getMyUpcomingChallenges();

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
                        builder: (context) => ChallengeDetailPage(
                          challenge: challenge,
                          joined: true,
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
