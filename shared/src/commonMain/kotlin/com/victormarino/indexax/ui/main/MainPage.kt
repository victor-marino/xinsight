package com.victormarino.indexax.ui.main

import org.jetbrains.compose.resources.DrawableResource
import xinsight.shared.generated.resources.Res
import xinsight.shared.generated.resources.dashboard_24px
import xinsight.shared.generated.resources.list_24px
import xinsight.shared.generated.resources.monitoring_24px
import xinsight.shared.generated.resources.pie_chart_24px
import xinsight.shared.generated.resources.trending_up_24px

enum class MainPage(val title: String, val icon: DrawableResource) {
    Overview("Overview", Res.drawable.dashboard_24px),
    Portfolio("Portfolio", Res.drawable.pie_chart_24px),
    Evolution("Evolution", Res.drawable.monitoring_24px),
    Transactions("Transactions", Res.drawable.list_24px),
    Projection("Projection", Res.drawable.trending_up_24px),
}