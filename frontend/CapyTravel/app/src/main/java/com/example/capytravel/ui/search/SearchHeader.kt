package com.example.capytravel.ui.search

import androidx.compose.foundation.layout.Column
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import com.example.capytravel.R

@Composable
fun SearchHeader(modifier: Modifier = Modifier) {
    Column(modifier) {
        Text(
            text = stringResource(R.string.search_bar_title),
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Black
        )
        Text(
            text = stringResource(R.string.search_bar_description),
            style = MaterialTheme.typography.bodyMedium
        )
    }
}