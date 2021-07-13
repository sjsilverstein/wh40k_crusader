import 'package:flutter/material.dart';

class FactionIcon extends StatelessWidget {
  final String faction;
  FactionIcon(this.faction);

  AssetImage _getAssetImage() {
    AssetImage assetImage;
    switch (faction) {
      case 'Imperial':
        assetImage = AssetImage('assets/icons/factions/imperial.png');
        break;
      case 'Chaos':
        assetImage = AssetImage('assets/icons/factions/chaos.png');
        break;
      case 'Aeldari':
        assetImage = AssetImage('assets/icons/factions/aeldari.png');
        break;
      case 'Tyranids':
        assetImage = AssetImage('assets/icons/factions/tyranid.png');
        break;
      case 'Orks':
        assetImage = AssetImage('assets/icons/factions/orks.png');
        break;
      case 'Necrons':
        assetImage = AssetImage('assets/icons/factions/necrons.png');
        break;
      case 'T\'au Empire':
        assetImage = AssetImage('assets/icons/factions/tau.png');
        break;
      default:
        return AssetImage('assets/icons/factions/imperial.png');
    }
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      _getAssetImage(),
      color: Colors.black,
    );
  }
}
