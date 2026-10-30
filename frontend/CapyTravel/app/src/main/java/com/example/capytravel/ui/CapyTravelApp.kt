package com.example.capytravel.ui

import androidx.compose.foundation.layout.Box
import androidx.compose.material3.adaptive.navigationsuite.NavigationSuiteScaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.example.capytravel.navigation.createTabs
import org.maplibre.compose.map.MaplibreMap

@Composable
fun CapyTravelApp(modifier: Modifier = Modifier) {
    Box(modifier) {
        MaplibreMap()
    }
}