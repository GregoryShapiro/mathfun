# Math Fun - Educational Math Games

A collection of educational math games built with Flutter, designed with a child-friendly interface and engaging gameplay.

## Games

### Sum Master

A falling block puzzle game (Tetris-style) where children learn addition by creating rows or columns with a specific target sum.

#### Game Rules:
- Colorful number blocks fall from the top
- Move blocks left and right to position them
- Preview shows the next number block that will fall
- Create rows or columns where numbers sum to the target value
- When a row or column sums to the target value, it clears and blocks above fall down
- Chain reactions: After blocks fall, any new matches will clear automatically
- Earn points for each successful match
- Progress through levels with increasing difficulty
- Game over when blocks stack to the top

#### Controls:
- Left and right arrow keys to move blocks horizontally
- Down arrow key to accelerate falling
- Space key or Drop button to instantly drop the block to the bottom
- Touch controls for mobile devices (swipe left/right)
- On-screen control buttons

## Features

- Kid-friendly visual design with vibrant colors, gradient effects, and rounded shapes
- Larger, more visually appealing number blocks for better visibility
- Preview of the next falling number block
- Intuitive user interface with clear visual feedback and enhanced animations
- Progressive difficulty that adapts to the player's skill level
- Built with Flutter for cross-platform compatibility (Android, Web)
- Responsive design for various screen sizes
- **Multiple Languages Support**: Available in English, Russian, and Spanish
- Easy language switching with the language selector button

## Running the Game

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Building for Different Platforms

```bash
# Android
flutter build apk

# Web
flutter build web
```

## Implementation Details

The game is built with:
- Flutter framework
- Material Design components with custom styling
- Google Fonts for child-friendly typography
- Stateful widgets for dynamic gameplay