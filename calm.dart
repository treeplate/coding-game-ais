// Codingame Code A La Mode ai

import 'dart:io';
import 'dart:math';

// 69: plate with chopped strawberries and croissant
// ?000000?0???01
// tart crois cream  blue straw
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
// xxx optamizable to 6 bits
// 10000001001101
// tart croissant blue strawc plate
int plate = 1;
int strawberries = 2;
int choppedStrawberries = 4;
int blueberries = 8;
int iceCream = 16;
int dough = 32;
int croissant = 64;
int bell = 128;
int chopper = 256;
int oven = 512;
int ground = 1024;
int choppedDough = 2048;
int rawTart = 4096;
int tart = 8192;
List<int> plateFoods = [
  choppedStrawberries,
  blueberries,
  iceCream,
  croissant,
  tart
];
Map<int, List<int>> recipes = {
  croissant: [dough, oven],
  choppedStrawberries: [strawberries, chopper],
  choppedDough: [dough, chopper],
  rawTart: [choppedDough, blueberries],
  tart: [rawTart, oven],
};
Map<String, int> cells = {
  '.': ground,
  '0': ground,
  '1': ground,
  '#': 0,
  'D': plate,
  'W': bell,
  'B': blueberries,
  'I': iceCream,
  'S': strawberries,
  'H': dough,
  'C': chopper,
  'O': oven,
};
int itemToInt(String item) {
  List<String> things = item.split('-');
  int x = 0;
  for (String t in things) {
    switch (t) {
      case 'DISH':
        x |= plate;
        break;
      case 'STRAWBERRIES':
        x |= strawberries;
        break;
      case 'CHOPPED_STRAWBERRIES':
        x |= choppedStrawberries;
        break;
      case 'BLUEBERRIES':
        x |= blueberries;
        break;
      case 'ICE_CREAM':
        x |= iceCream;
        break;
      case 'DOUGH':
        x |= dough;
        break;
      case 'CROISSANT':
        x |= croissant;
        break;
      case 'CHOPPED_DOUGH':
        x |= choppedDough;
        break;
      case 'RAW_TART':
        x |= rawTart;
        break;
      case 'TART':
        x |= tart;
        break;
      case 'NONE':
        return 0;
      default:
        return -1;
    }
  }
  return x;
}

void main() {
  List inputs;
  int numAllCustomers = int.parse(stdin.readLineSync()!);
  for (int i = 0; i < numAllCustomers; i++) {
    inputs = stdin.readLineSync()!.split(' ');
    String customerItem = inputs[0]; // the food the customer is waiting for
    int customerAward = int.parse(
        inputs[1]); // the number of points awarded for delivering the food
  }
  List<int> worldOrig = [];
  for (int i = 0; i < 7; i++) {
    String kitchenLine = stdin.readLineSync()!;
    for (String c in kitchenLine.split('')) {
      stderr.write('${cells[c]} ');
      worldOrig.add(cells[c]!);
    }
    stderr.writeln('');
  }

  // game loop
  while (true) {
    List<int> world = worldOrig.toList();
    int turnsRemaining = int.parse(stdin.readLineSync()!);
    inputs = stdin.readLineSync()!.split(' ');
    int playerX = int.parse(inputs[0]);
    int playerY = int.parse(inputs[1]);
    int playerItem = itemToInt(inputs[2]);
    inputs = stdin.readLineSync()!.split(' ');
    int partnerX = int.parse(inputs[0]);
    int partnerY = int.parse(inputs[1]);
    String partnerItem = inputs[2];
    int numTablesWithItems = int.parse(stdin
        .readLineSync()!); // the number of tables in the kitchen that currently hold an item
    for (int i = 0; i < numTablesWithItems; i++) {
      inputs = stdin.readLineSync()!.split(' ');
      int tableX = int.parse(inputs[0]);
      int tableY = int.parse(inputs[1]);
      String item = inputs[2];
      world[tableY * 11 + tableX] = itemToInt(item);
    }
    inputs = stdin.readLineSync()!.split(' ');
    int ovenContents = itemToInt(inputs[0]); // ignore until wood 1 league
    if (ovenContents != 0) {
      world[world.indexWhere(
        (element) => element == oven,
      )] = ovenContents;
    }
    int ovenTimer = int.parse(inputs[1]);
    int numCustomers = int.parse(stdin
        .readLineSync()!); // the number of customers currently waiting for food
    List<int> goals = [];
    for (int i = 0; i < numCustomers; i++) {
      inputs = stdin.readLineSync()!.split(' ');
      String customerItem = inputs[0];
      goals.add(itemToInt(customerItem));
      int customerAward = int.parse(inputs[1]);
    }

    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    // MOVE x y
    // USE x y
    // WAIT
    stderr.writeln(goals.first);
    if (goals.any((goal) => playerItem == goal)) {
      print(target(bell, world, playerItem, ['target bell'], playerX, playerY,
          ovenContents));
    } else {
      stderr.writeln('beefor');
      print(target(goals.first, world, playerItem, ['target ${goals.first}'],
          playerX, playerY, ovenContents));
      stderr.writeln('aafter');
    }
  }
}

bool immFood(
  int goal,
  List<int> grid,
) {
  for (int x = 0; x < 11; x++) {
    for (int y = 0; y < 7; y++) {
      if (grid[y * 11 + x] == goal) {
        return true;
      }
    }
  }
  return false;
}

bool validUSE(int goal, int currentItem) {
  if (currentItem == 0 || goal == 0) {
    return true;
  }
  if (goal == bell) {
    return true;
  }
  for (MapEntry entry in recipes.entries) {
    if (entry.value[0] == currentItem && entry.value[1] == goal) {
      return true;
    }
    if (entry.value[1] == currentItem && entry.value[0] == goal) {
      return true;
    }
  }
  if (currentItem & plate == plate) {
    if (plateFoods.contains(goal)) {
      return true;
    }
  } else {}
  return goal & plate == plate && plateFoods.contains(currentItem);
}

String target(int goal, List<int> grid, int currentItem, List<String> history,
    int playerX, int playerY, int ovenContents) {
  if (goal == currentItem) {
    return "WAIT; interr $currentItem";
  }
  List<List<int>> poses = [];
  for (int x = 0; x < 11; x++) {
    for (int y = 0; y < 7; y++) {
      if (grid[y * 11 + x] == goal) {
        if (validUSE(goal, currentItem)) {
          poses.add([x, y]);
        } else {
          return target(0, grid, currentItem, history + ['put down original'],
              playerX, playerY, ovenContents);
        }
      }
    }
  }
  if (poses.isNotEmpty) {
    stderr.writeln(history);
    List<int> pos = (poses
          ..sort((a, b) =>
              dist(a[0], a[1], playerX, playerY) -
              dist(b[0], b[1], playerX, playerY)))
        .first;
    return "USE ${pos[0]} ${pos[1]}; targeting $goal";
  }
  if (recipes[goal] != null) {
    if (currentItem == recipes[goal]![0]) {
      if (recipes[goal]![1] == oven && ovenContents != 0) {
        stderr.writeln('targeting full oven');
        if (currentItem == choppedDough) {
          return target(
              choppedStrawberries,
              grid,
              currentItem,
              history + ['need to use oven but cant'],
              playerX,
              playerY,
              ovenContents);
        } else {
          return target(
              choppedDough,
              grid,
              currentItem,
              history + ['need to use oven but cant'],
              playerX,
              playerY,
              ovenContents);
        }
      }
      return target(
          recipes[goal]![1],
          grid,
          currentItem,
          history +
              [
                'need to convert item to $goal from $currentItem with ${recipes[goal]![1]}'
              ],
          playerX,
          playerY,
          ovenContents);
    } else {
      return target(
          recipes[goal]![0],
          grid,
          currentItem,
          history + ['need to get ${recipes[goal]![0]} to convert to $goal'],
          playerX,
          playerY,
          ovenContents);
    }
  }
  if (goal & plate == plate) {
    for (int food in plateFoods) {
      if (goal & food == food &&
          currentItem & food != food &&
          !immFood(food, grid)) {
        return target(
            food,
            grid,
            currentItem,
            history + ['create complex item $food'],
            playerX,
            playerY,
            ovenContents);
      }
    }
    if (currentItem & plate != plate) {
      return target(plate, grid, currentItem, history + ['get plate'], playerX,
          playerY, ovenContents);
    } else {
      for (int food in plateFoods) {
        if (goal & food == food && currentItem & food == 0) {
          return target(
              food,
              grid,
              currentItem,
              history + ['get preexisting item'],
              playerX,
              playerY,
              ovenContents);
        }
      }
    }
  }
  stderr.writeln(history);
  return "WAIT; target: $goal";
}

int dist(int ax, int ay, int bx, int by) {
  return (bx - ax).abs() + (by - bx).abs();
}
