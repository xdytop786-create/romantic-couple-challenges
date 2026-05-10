# 💕 Romantic Couple Challenges

A Flutter mobile application designed to strengthen relationships through fun, engaging, and romantic challenges for couples.

## Features

✨ **50 Romantic Challenges**
- Light difficulty challenges (10 points each)
- Medium difficulty challenges (20 points each)
- Bold difficulty challenges (30-35 points each)

🎮 **Game Modes**
- Turn-based gameplay for both husband and wife
- Skip or accept challenges
- Real-time scoring system

📊 **Advanced Scoring System**
- Individual player scores
- Total game statistics
- Achievements and badges
- Challenge completion tracking

💾 **Data Persistence**
- Save game statistics locally
- Game history tracking
- Local storage using SharedPreferences

🎨 **Beautiful UI**
- Romantic gradient design
- Smooth animations
- Intuitive navigation
- Dark theme optimized for late-night play

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio or Xcode

### Installation

1. Clone the repository:
```bash
git clone https://github.com/xdytop786-create/romantic-couple-challenges.git
cd romantic-couple-challenges
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Home page with navigation
│   ├── game_screen.dart      # Main game screen
│   └── stats_screen.dart     # Statistics and achievements
├── models/
│   ├── challenge.dart        # Challenge model
│   └── game_stats.dart       # Game statistics model
├── services/
│   └── storage_service.dart  # Local storage management
└── data/
    └── challenges_data.dart  # 50 romantic challenges
```

## Challenge Types

### Truth Questions
Personal and romantic questions designed to deepen emotional connection.

### Dares
Fun, romantic activities and tasks for couples to complete together.

## Scoring System

- **Light Challenges**: 10 points
- **Medium Challenges**: 20 points
- **Bold Challenges**: 30-35 points

Players earn points for completing challenges and can track their progress through the advanced statistics system.

## Achievements

Unlock achievements as you play:
- 🎮 First Game
- 🔥 5 Games Played
- ⭐ 10 Games Played
- 💯 100 Points
- 🏆 500 Points
- 👨 Husband Leader
- 👩 Wife Leader
- 💕 Perfect Balance

## Technologies Used

- **Flutter 3.0+** - UI Framework
- **Dart** - Programming Language
- **Google Fonts** - Typography
- **Shared Preferences** - Local Storage
- **Material 3** - Design System

## How to Play

1. **Start Game**: Press the "Start Game" button from home
2. **Take Turns**: Players alternate turns
3. **Read Challenge**: Read the displayed challenge
4. **Choose Action**: Accept and complete the challenge or skip it
5. **Earn Points**: Get points for completing challenges
6. **View Stats**: Check statistics and achievements anytime

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@romanticcouple.app or open an issue on GitHub.

---

Made with ❤️ for couples in love
