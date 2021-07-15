import 'package:flutter/material.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

class BattleFieldRoleIcon extends StatelessWidget {
  final String battleFieldRole;
  BattleFieldRoleIcon(this.battleFieldRole);

  AssetImage _getAssetImage() {
    AssetImage assetImage;
    switch (battleFieldRole) {
      case 'HQ':
        assetImage = AssetImage('assets/icons/battlefield_roles/hq.png');
        break;
      case 'Elite':
        assetImage = AssetImage('assets/icons/battlefield_roles/elites.png');
        break;
      case 'Troop':
        assetImage = AssetImage('assets/icons/battlefield_roles/troop.png');
        break;
      case 'Flyer':
        assetImage = AssetImage('assets/icons/battlefield_roles/flyer.png');
        break;
      case 'Lord of War':
        assetImage = AssetImage('assets/icons/battlefield_roles/lordOfWar.png');
        break;
      case 'Heavy Support':
        assetImage =
            AssetImage('assets/icons/battlefield_roles/heavy-support.png');
        break;
      case 'Fast Attack':
        assetImage =
            AssetImage('assets/icons/battlefield_roles/fast-attack.png');
        break;
      case 'Transport':
        assetImage = AssetImage('assets/icons/battlefield_roles/transport.png');
        break;
      case 'Supreme Commander':
        assetImage =
            AssetImage('assets/icons/battlefield_roles/supremeCmd.png');
        break;
      default:
        return AssetImage('assets/icons/battlefield_roles/troop.png');
    }
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageIcon(
            _getAssetImage(),
            color: Colors.black,
          ),
          VerticalSpace.tiny,
          Text(
            battleFieldRole,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    ;
  }
}
