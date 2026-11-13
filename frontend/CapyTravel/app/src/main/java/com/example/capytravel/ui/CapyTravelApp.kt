package com.example.capytravel.ui

import androidx.compose.material3.adaptive.currentWindowAdaptiveInfoV2
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.window.core.layout.WindowSizeClass
import com.example.capytravel.ui.overview.ContentScaffold

@Composable
fun CapyTravelApp(
    currentTab: Int,
    onCloseContentTab: () -> Unit,
    modifier: Modifier = Modifier,
    windowSize: WindowSizeClass = currentWindowAdaptiveInfoV2().windowSizeClass,
) {
    ContentScaffold(
        currentTab = currentTab,
        onCloseContentTab = onCloseContentTab,
        modifier = modifier
    )
}