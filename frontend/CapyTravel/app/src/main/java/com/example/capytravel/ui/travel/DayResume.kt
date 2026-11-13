package com.example.capytravel.ui.travel

import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.capytravel.R

@Composable
fun DayResume(modifier: Modifier = Modifier) {
    Surface(modifier) {
        Row (
            modifier = modifier
                .fillMaxWidth()
                .horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(8.dp),

            ) {
            DayResumeItem(
                iconId = R.drawable.clock_icon,
                textId = R.string.resume_duration

            )
            DayResumeItem(
                iconId = R.drawable.walk_icon,
                textId = R.string.resume_distance
            )
            DayResumeItem(
                iconId = R.drawable.intensity_icon,
                textId = R.string.resume_intensity
            )
        }
    }
}

@Composable
fun DayResumeItem(
    iconId: Int,
    textId: Int,
    modifier: Modifier = Modifier
) {
    SuggestionChip(
        icon = {
            Icon(
                painterResource(iconId),
                contentDescription = null,
                modifier = Modifier.size(16.dp)
            )
        },
        label = {
            Text(
                text = stringResource(textId),
                style = MaterialTheme.typography.bodySmall,
                fontWeight = FontWeight.Bold
            )
        },
        onClick = {},
        modifier = modifier
    )
}