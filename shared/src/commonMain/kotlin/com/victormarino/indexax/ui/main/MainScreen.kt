package com.victormarino.indexax.ui.main

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.victormarino.indexax.ui.components.FloatingMenu
import kotlinx.coroutines.launch

@Preview
@Composable
fun MainScreen() {
    val pages = MainPage.entries
    val pagerState = rememberPagerState(
        pageCount = { pages.size },
    )

    val coroutineScope = rememberCoroutineScope()

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

        Box(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .windowInsetsPadding(
                    WindowInsets.safeDrawing.only(WindowInsetsSides.Bottom)
                )
                .padding(
                    horizontal = 16.dp,
                    vertical = 16.dp,
                ),
        ) {
            FloatingMenu(
                pages = pages,
                selectedIndex = pagerState.currentPage,
                onItemSelected = { pageIndex ->
                    coroutineScope.launch {
                        pagerState.animateScrollToPage(pageIndex)
                    }
                },
            )
        }
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