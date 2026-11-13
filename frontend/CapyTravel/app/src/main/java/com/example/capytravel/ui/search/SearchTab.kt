package com.example.capytravel.ui.search

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun SearchTab(modifier: Modifier = Modifier) {
    Column(
        modifier
    ) {
        var searchMode by rememberSaveable { mutableIntStateOf(0) }
        SearchHeader(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        SearchBar(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        SearchNavigation(
            searchMode = searchMode,
            onSearchModeChange = { searchMode = it },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        if (searchMode == 0) {
            PlaceTaxonomyPicker(
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(
                modifier = Modifier.height(32.dp)
            )
        }
        SearchResults(
            results = List(5) { MockPlaceResult() },
            modifier = Modifier.fillMaxWidth()
        )
    }
}