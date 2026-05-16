import 'package:flutter/material.dart';
import '../data/models/team_model.dart';

class TeamConstants {
  static const Map<String, List<String>> adjectives = {
    'it': [
      "eroici",
      "sfigati",
      "speciali",
      "stellari",
      "puzzolenti",
      "ubriachi",
      "nucleari",
      "atomici",
      "acrobatici",
      "esplosivi",
      "patriottici",
      "letali",
      "digitali",
      "luminosi",
      "artificiali",
      "palestrati",
      "futuristici",
      "alcolizzati",
      "insopportabili",
      "antipatici",
      "pericolosi",
      "accattivanti",
      "sexy",
      "cattivissimi",
      "veloci",
      "lenti",
      "gagliardi",
      "fulminati",
      "pazzi",
      "mitici",
      "leggendari",
      "furiosi",
      "calmi",
      "timidi",
      "coraggiosi",
      "codardi",
      "giganti",
      "minuscoli",
      "invisibili",
      "elastici",
      "magnetici",
      "radioattivi",
      "tossici",
      "eleganti",
      "sfrenati",
      "spietati",
      "ridicoli",
      "maestosi",
    ],
    'en': [
      "heroic",
      "losers",
      "special",
      "stellar",
      "stinkers",
      "drunk",
      "nuclear",
      "atomic",
      "acrobatic",
      "explosive",
      "patriotic",
      "lethal",
      "digital",
      "luminous",
      "artificial",
      "gymnastic",
      "futuristic",
      "alcoholic",
      "insufferable",
      "obnoxious",
      "dangerous",
      "endearing",
      "sexy",
      "naughty",
      "fast",
      "slow",
      "sturdy",
      "fried",
      "crazy",
      "mythical",
      "legendary",
      "furious",
      "calm",
      "shy",
      "brave",
      "cowardly",
      "giant",
      "tiny",
      "invisible",
      "elastic",
      "magnetic",
      "radioactive",
      "toxic",
      "elegant",
      "wild",
      "ruthless",
      "ridiculous",
      "majestic",
    ],
  };

  static const Map<String, List<String>> nouns = {
    'it': [
      "piccioni",
      "passeri",
      "scoiattoli",
      "criceti",
      "guerrieri",
      "cavalli",
      "elfi",
      "nani",
      "canguri",
      "australopitechi",
      "astronauti",
      "informatici",
      "programmatori",
      "scienziati",
      "ingegneri",
      "scarpari",
      "pappagalli",
      "dinosauri",
      "ciclopi",
      "titani",
      "giuristi",
      "cyborg",
      "ammazzavampiri",
      "licantropi",
      "zombie",
      "turisti",
      "draghi",
      "centauri",
      "vichinghi",
      "samurai",
      "pirati",
      "alieni",
      "robot",
      "ninja",
      "gladiatori",
      "maghi",
      "troll",
      "goblin",
      "yeti",
      "unicorni",
      "falchi",
      "lupi",
      "leoni",
      "tigri",
      "polpi",
      "pinguini",
      "ratti",
      "gabbiani",
      "serpenti",
      "gorilla",
      "fantini",
      "maggiordomi",
    ],
    'en': [
      "pigeons",
      "sparrows",
      "squirrels",
      "hamsters",
      "warriors",
      "horses",
      "elves",
      "dwarves",
      "kangaroos",
      "australopithecus",
      "astronauts",
      "computer scientists",
      "programmers",
      "scientists",
      "engineers",
      "scarpers",
      "parrots",
      "dinosaurs",
      "cyclops",
      "titans",
      "jurists",
      "cyborgs",
      "vampire slayers",
      "werewolves",
      "zombies",
      "tourists",
      "dragons",
      "centaurs",
      "vikings",
      "samurais",
      "pirates",
      "aliens",
      "robots",
      "ninjas",
      "gladiators",
      "wizards",
      "trolls",
      "goblins",
      "yetis",
      "unicorns",
      "hawks",
      "wolves",
      "lions",
      "tigers",
      "octopuses",
      "penguins",
      "rats",
      "seagulls",
      "snakes",
      "gorillas",
      "jockeys",
      "butlers",
    ],
  };

  static const List<String> colors = [
    "#E53935", // Red 600
    "#D81B60", // Pink 600
    "#8E24AA", // Purple 600
    "#5E35B1", // Deep Purple 600
    "#3949AB", // Indigo 600
    "#1E88E5", // Blue 600
    "#039BE5", // Light Blue 600
    "#00ACC1", // Cyan 600
    "#00897B", // Teal 600
    "#43A047", // Green 600
    "#7CB342", // Light Green 600
    "#C0CA33", // Lime 600
    "#FDD835", // Yellow 600
    "#FFB300", // Amber 600
    "#FB8C00", // Orange 600
    "#F4511E", // Deep Orange 600
    "#6D4C41", // Brown 600
    "#757575", // Grey 600
    "#546E7A", // Blue Grey 600
    "#0D47A1", // Dark Blue
    "#1B5E20", // Dark Green
    "#B71C1C", // Dark Red
    "#F50057", // Pink Accent
    "#00E676", // Green Accent
    "#651FFF", // Deep Purple Accent
    "#FF9100", // Orange Accent
    "#2979FF", // Blue Accent
  ];

  static const List<TeamPattern> patterns = [
    TeamPattern.vertical,
    TeamPattern.horizontal,
    TeamPattern.diagonal,
  ];

  /// Converts a hex [String] (e.g., "#FF0000" or "FF0000") to a Flutter [Color].
  /// Handles cleaning of the string and normalization to 8-character hex.
  static Color hexToColor(String hex) {
    // Normalization: Uppercase and remove #
    hex = hex.toUpperCase().replaceAll('#', '').replaceAll(' ', '');
    
    if (hex.length == 6) {
      hex = 'FF$hex'; // Default to opaque if alpha is missing
    } else if (hex.length != 8) {
      // Return a safe fallback (Grey) if the format is invalid
      return const Color(0xFF9E9E9E); 
    }
    
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      // Return a safe fallback (Grey) in case of parsing error
      return const Color(0xFF9E9E9E);
    }
  }
}
