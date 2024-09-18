import 'dart:math';

class PaywallMessages {
  static final List<String> homePageMessages = [
    "Curiosity is your greatest tool. Unlock everything Nerd Nudge has to offer and fuel your learning!",
    "Don’t settle for limits—unlock your full potential with unlimited access!",
    "Why hold back when you can have it all? Upgrade now and never stop learning.",
    "There’s so much more to explore. Unlock exclusive content with Nerd Nudge Pro!",
    "Ready to become unstoppable? Pro users learn without limits—join them today!",
    "The path to mastery is within reach. Unlock unlimited access and never look back.",
    "Why settle for less when you can have more? Unlock Pro features now!",
    "Take your learning to the next level with unlimited quizzes and shots.",
    "Don’t stop here—upgrade to Pro and unlock exclusive content and features!",
    "Maximize your learning potential. Unlock Nerd Nudge Pro and go beyond limits!"
  ];

  static final List<String> profilePageMessages = [
    "Your profile is just one step away from being complete! Unlock Pro and see the difference.",
    "You’ve come so far—upgrade to Pro and make your learning journey truly limitless.",
    "Imagine where you could be with full access. Upgrade now and start achieving your goals faster!",
    "Pro users get more: insights, unlimited access, and the best tools for success.",
    "Success is closer than you think. Join the Pro users and take charge of your learning.",
    "Upgrade today and enjoy the exclusive perks waiting for you.",
    "Show off your skills with a Pro account. Unlock exclusive features now!",
    "Your learning journey deserves the best—upgrade to Pro for unlimited access.",
    "Pro users don’t just stop at learning—they master it. Join them today!",
    "Your profile is impressive—make it even better with full access to all features."
  ];

  static final List<String> quizflexMessages = [
    "You’ve hit your limit for today, but who says learning should have limits? Go Pro for endless quizzes!",
    "Imagine if there were no limits to your learning. With Pro, that’s your reality!",
    "You’re on fire! Don’t let a daily cap stop you—upgrade for unlimited quizzes and stay ahead.",
    "Out of quizzes, but not out of potential. Unlock unlimited quizzes and keep growing.",
    "You’ve done great today—now imagine what you can achieve with no limits! Upgrade to Pro.",
    "You’ve reached the daily limit, but the journey doesn’t have to stop here. Go Pro for unlimited learning!",
    "Keep your momentum going—upgrade to Pro for unlimited quizzes and never stop growing.",
    "You’ve already mastered so much. Unlock Pro for endless quizzes and take the next step!",
    "No more waiting for tomorrow—get unlimited quizzes today with Nerd Nudge Pro!",
    "You’re ready for more. Unlock Pro for unlimited quizzes and never slow down!"
  ];

  static final List<String> shotsMessages = [
    "You’re hungry for knowledge—don’t let the daily limit hold you back! Go Pro for unlimited shots!",
    "Imagine having all the learning shots you need. With Pro, your learning never stops.",
    "More shots, more knowledge, more growth. Upgrade to Pro and never run out of learning power!",
    "You’ve pushed yourself to the max today—why not unlock unlimited shots and keep the momentum going?",
    "Learning is limitless with Pro. Don’t let the daily shot cap slow you down—upgrade now!",
    "You’ve done amazing today. Imagine how far you can go with unlimited shots! Upgrade to Pro and find out.",
    "Never miss a learning opportunity. Unlock unlimited shots and keep leveling up.",
    "You’re just getting started! Get unlimited shots with Nerd Nudge Pro and accelerate your learning.",
    "Your thirst for knowledge deserves more—unlock unlimited shots with Pro today!",
    "The learning doesn’t have to stop here. Go Pro for unlimited shots and supercharge your growth!"
  ];

  static String getRandomMessage(String context) {
    List<String> messages;
    switch (context) {
      case 'Home':
        messages = homePageMessages;
        break;
      case 'Profile':
        messages = profilePageMessages;
        break;
      case 'Quizflex':
        messages = quizflexMessages;
        break;
      case 'Shots':
        messages = shotsMessages;
        break;
      default:
        messages = ["No messages available for this context"];
        break;
    }

    final randomIndex = Random().nextInt(messages.length);
    return messages[randomIndex];
  }
}