import 'package:flutter/material.dart';
import '../../../services/my_challenges_service/my_challenges_service.dart';
import '../../utilities/challenge_utils.dart';
import 'active_challenge_drill_down.dart';

class MyActiveChallenges extends StatelessWidget {
  const MyActiveChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final activeChallenges =
        MyChallengesService().getMyActiveChallenges();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          ...activeChallenges.map((challenge) {
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
                        builder: (context) => MyActiveChallengeDrillDown(
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
