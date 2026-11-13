package com.example.capytravel.ui.search

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import com.example.capytravel.R

enum class SearchNavigationTab(val label: Int) {
    Places (
        label = R.string.places_tab
    ),
    Localities (
        label = R.string.localities_tab
    ),
    Addresses (
        label = R.string.addresses_tab
    )
}

@Composable
fun SearchNavigation(
    searchMode: Int,
    onSearchModeChange: (Int) -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier,
        horizontalArrangement = Arrangement.SpaceAround
    ) {
        SearchNavigationTab.entries.forEachIndexed { index, tab ->
            SearchNavigationTab(
                tab = tab,
                selected = searchMode == index,
                modifier = Modifier.padding(dimensionResource(R.dimen.padding_medium)).clickable(onClick = { onSearchModeChange(index) })
            )
        }
    }
}

@Composable
fun SearchNavigationTab(tab: SearchNavigationTab, selected: Boolean, modifier: Modifier = Modifier) {
    Text(
        text = stringResource(tab.label),
        textAlign = TextAlign.Center,
        color =
            if (selected)
                MaterialTheme.colorScheme.primary
            else
                MaterialTheme.colorScheme.onSurface,
        fontWeight =
            if (selected) FontWeight.Bold else FontWeight.Normal,
        modifier = modifier
    )
}