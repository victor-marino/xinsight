import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/transaction.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/asset_details_popup.dart';
import 'package:expandable/expandable.dart';
import 'package:indexa_dashboard/widgets/collapsed_asset_tile_view.dart';
import 'package:indexa_dashboard/widgets/expanded_asset_tile_header.dart';
import 'package:indexa_dashboard/widgets/expanded_asset_tile_body.dart';

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




