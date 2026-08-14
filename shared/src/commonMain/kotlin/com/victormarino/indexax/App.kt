package com.victormarino.indexax

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.*
import androidx.compose.ui.tooling.preview.Preview
import com.victormarino.indexax.ui.main.MainScreen
import com.victormarino.indexax.ui.theme.XInsightTheme

@Composable
@Preview
fun App() {
    XInsightTheme {
        MainScreen()
    }
}
