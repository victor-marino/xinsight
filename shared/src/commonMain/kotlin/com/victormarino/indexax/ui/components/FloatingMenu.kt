package com.victormarino.indexax.ui.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.victormarino.indexax.ui.main.MainPage
import org.jetbrains.compose.resources.DrawableResource
import org.jetbrains.compose.resources.painterResource

@Composable
internal fun FloatingMenu(
    pages: List<MainPage>,
    selectedIndex: Int,
    onItemSelected: (Int) -> Unit,
    modifier: Modifier = Modifier,
) {
    Surface(
        modifier = modifier,
        shape = RoundedCornerShape(50),
        shadowElevation = 8.dp,
    ) {
        Row(
            modifier = Modifier.padding(4.dp),
        ) {
            pages.forEachIndexed { index, page ->
                FloatingMenuItem(page.icon, page.title, index == selectedIndex, { onItemSelected(index) })
            }
        }
    }
}

@Composable
private fun FloatingMenuItem(icon: DrawableResource, title: String, selected: Boolean, onClick: () -> Unit) {
    IconButton(
        onClick = onClick,
    ) {
        Icon(
            painter = painterResource(icon),
            contentDescription = title,
            tint = if (selected) {
                MaterialTheme.colorScheme.primary
            } else {
                MaterialTheme.colorScheme.onSurfaceVariant
            },
        )
    }
}