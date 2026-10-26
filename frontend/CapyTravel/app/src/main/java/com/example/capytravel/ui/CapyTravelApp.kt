package com.example.capytravel.ui

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.dimensionResource
import com.example.capytravel.R
import com.example.capytravel.ui.navigation.NavigationBar
import org.maplibre.compose.map.MaplibreMap

@Composable
fun CapyTravelApp(modifier: Modifier = Modifier) {
    Box(modifier = modifier) {
        MaplibreMap()
        NavigationBar(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(dimensionResource(R.dimen.padding_large))
        )
    }
}