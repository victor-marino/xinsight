// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:expandable/expandable.dart';
import 'package:indexax/widgets/portfolio_screen/collapsed_asset_tile_view.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_header.dart';
import 'package:indexax/widgets/portfolio_screen/expanded_asset_tile_body.dart';

class AssetTile extends StatelessWidget {
  const AssetTile({
    Key key,
    @required this.assetData,
  }) : super(key: key);
  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    Widget collapsedView;
    Widget expandedView;
    Widget expandedHeader;
    Widget expandedBody;

    collapsedView = CollapsedAssetTileView(assetData: assetData);
    expandedHeader = ExpandedAssetTileHeader(assetData: assetData);
    expandedBody = ExpandedAssetTileBody(assetData: assetData);

    expandedView = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Container(
          width: 40,
          child: Text(
              getWholePercentWithoutPercentSignAsString(assetData.percentage) +
                  "%",
              textAlign: TextAlign.center,
              style: kAssetListPercentageTextStyle),
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
              Row(
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




