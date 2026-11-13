package com.example.capytravel.ui.travel

import androidx.compose.foundation.layout.Column
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import com.example.capytravel.R

@Composable
fun TravelHeader(modifier: Modifier = Modifier) {
    Column(modifier) {
        Text(
            text = stringResource(R.string.week_calendar_title),
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Black
        )
        Text(
            text = stringResource(R.string.week_calendar_description),
            style = MaterialTheme.typography.bodyMedium
        )
    }
}