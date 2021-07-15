import 'package:flutter/material.dart';

class FactionIcon extends StatelessWidget {
  final String faction;
  FactionIcon(this.faction);

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage;
    Color iconColor = Colors.white;
    switch (faction) {
      case 'Imperial':
        iconColor = Colors.white;
        assetImage = AssetImage('assets/icons/factions/imperial.png');
        break;
      case 'Chaos':
        iconColor = Colors.black;
        assetImage = AssetImage('assets/icons/factions/chaos.png');
        break;
      case 'Aeldari':
        iconColor = Color(0xFCF2D8);
        assetImage = AssetImage('assets/icons/factions/aeldari.png');
        break;
      case 'Tyranids':
        iconColor = Colors.purple;
        assetImage = AssetImage('assets/icons/factions/tyranid.png');
        break;
      case 'Orks':
        iconColor = Colors.orange;
        assetImage = AssetImage('assets/icons/factions/orks.png');
        break;
      case 'Necrons':
        iconColor = Colors.lightGreenAccent;
        assetImage = AssetImage('assets/icons/factions/necrons.png');
        break;
      case 'T\'au Empire':
        iconColor = Colors.deepOrange;
        assetImage = AssetImage('assets/icons/factions/tau.png');
        break;
      default:
        iconColor = Colors.white;
        assetImage = AssetImage('assets/icons/factions/imperial.png');
        break;
    }
    return ImageIcon(
      assetImage,
      color: iconColor,
    );
  }
}
