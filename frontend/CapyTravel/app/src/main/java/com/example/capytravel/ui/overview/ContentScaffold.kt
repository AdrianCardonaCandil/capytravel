package com.example.capytravel.ui.overview

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.BottomSheetScaffold
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.rememberBottomSheetScaffoldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.unit.dp
import com.example.capytravel.R
import org.maplibre.compose.map.MaplibreMap

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContentScaffold(
    currentTab: Int,
    onCloseContentTab: () -> Unit,
    modifier: Modifier = Modifier
) {
    val sheetHeight by animateDpAsState(
        targetValue = if (currentTab != -1) 200.dp else 0.dp,
        animationSpec = tween(durationMillis = 250)
    )
    BottomSheetScaffold(
        scaffoldState = rememberBottomSheetScaffoldState(),
        sheetPeekHeight = sheetHeight,
        sheetContainerColor = MaterialTheme.colorScheme.surface,
        sheetContentColor = MaterialTheme.colorScheme.onSurface,
        sheetContent = {
            ContentTab(
                currentTab = currentTab,
                onCloseContentTab = onCloseContentTab,
                modifier = Modifier
                    .verticalScroll(rememberScrollState())
                    .fillMaxWidth()
                    .padding(dimensionResource(R.dimen.padding_large))
            )
        },
        modifier = modifier
    ) {
        MaplibreMap()
    }
}