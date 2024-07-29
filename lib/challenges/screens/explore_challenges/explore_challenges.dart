import 'package:flutter/material.dart';
import '../../../utilities/quiz_topics.dart';
import '../../services/explore_challenges_service/nerdnudge_challenge_service.dart';
import '../../services/my_challenges_service/my_challenges_service.dart';
import '../utilities/challenge_utils.dart';
import 'challenge_details.dart';

class ExploreChallenges extends StatelessWidget {
  const ExploreChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = NerdNudgeChallengesService().getNerdNudgeChallenges();
    final Set<String> myChallenges = MyChallengesService().getAllMyChallengeIds();
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ...challenges.map((challenge) {
                  IconData icon = Topics.getIconForTopics(challenge['type']);
                  return Column(
                    children: [
                      ChallengeUtils.getChallengeCard(
                        message: challenge['name'],
                        icon: icon,
                        startDate: challenge['startDate'],
                        endDate: challenge['endDate'],
                        prizes: challenge['prizes'],
                        members: challenge['members'],
                        owner: challenge['owner'],
                        joined: myChallenges.contains(challenge['id']),
                        onTap: () {
                          print('Challenge ${challenge['type']} selected');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Challenge ${challenge['type']} selected'),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengeDetailPage(
                                challenge: challenge,
                                joined: myChallenges.contains(challenge['id']),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20,),
                    ],
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
