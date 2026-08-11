package com.victormarino.indexax.ui.main

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier

@Composable
fun MainScreen() {
    val pages = MainPage.entries
    val pagerState = rememberPagerState(
        pageCount = { pages.size },
    )

    Box(modifier = Modifier.fillMaxSize()) {
        HorizontalPager(
            state = pagerState,
            modifier = Modifier.fillMaxSize(),
        ) { pageIndex ->
            when (pages[pageIndex]) {
                MainPage.Overview -> PlaceholderPage("Overview")
                MainPage.Portfolio -> PlaceholderPage("Portfolio")
                MainPage.Evolution -> PlaceholderPage("Evolution")
                MainPage.Projection -> PlaceholderPage("Projection")
                MainPage.Transactions -> PlaceholderPage("Transactions")
            }
        }

        // FloatingPageMenu will eventually be aligned over the pager here.
    }
}

@Composable
private fun PlaceholderPage(title: String) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center,
    ) {
        Text(title)
    }
}