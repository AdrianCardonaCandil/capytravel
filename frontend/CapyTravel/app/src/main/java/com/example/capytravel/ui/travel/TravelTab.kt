package com.example.capytravel.ui.travel

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun TravelTab(modifier: Modifier = Modifier) {
    Column(modifier) {
        TravelHeader(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        WeekCalendar(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        DayInformation(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(16.dp)
        )
        DayResume(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        ActivityCard(
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(
            modifier = Modifier.height(8.dp)
        )
        ActivityDivider(
            modifier = Modifier.fillMaxWidth()
        )
    }
}