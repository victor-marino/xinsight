import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/widgets/portfolio_screen/collapsed_asset_tile_view.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_body_landscape.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_body_portrait.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_header_landscape.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_header_portrait.dart';

// Class containing each individual tile shown in the asset list in portfolio screen
class AssetTile extends StatelessWidget {
  const AssetTile({
    Key? key,
    required this.assetData,
    required this.landscapeOrientation,
  }) : super(key: key);

  final PortfolioDataPoint assetData;
  final bool landscapeOrientation;

  @override
  Widget build(BuildContext context) {
    Widget collapsedView;
    Widget expandedView;
    Widget expandedHeader;
    Widget expandedBody;

    TextStyle assetPercentageTextStyle = text_styles.robotoBoldLighter(context, 17);

    collapsedView = CollapsedAssetTileView(assetData: assetData);
    expandedHeader = landscapeOrientation
        ? ExpandedAssetTileHeaderLandscape(assetData: assetData)
        : ExpandedAssetTileHeaderPortrait(assetData: assetData);
    expandedBody = landscapeOrientation
        ? ExpandedAssetTileBodyLandscape(assetData: assetData)
        : ExpandedAssetTileBodyPortrait(assetData: assetData);

    expandedView = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: SizedBox(
          width: 40,
          child: Text(
              "${getWholePercentWithoutPercentSignAsString(assetData.percentage)}%",
              textAlign: TextAlign.center,
              style: assetPercentageTextStyle),
        ),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  expandedHeader,
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: expandedBody,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.keyboard_arrow_up_rounded, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);

    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: true,
        child: ExpandablePanel(
          collapsed: ExpandableButton(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
              child: collapsedView,
            ),
          ),
          expanded: ExpandableButton(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 17, bottom: 15),
              child: expandedView,
            ),
          ),
        ),
      ),
    );
  }
}
