package com.example.capytravel.ui.overview

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import com.example.capytravel.R
import com.example.capytravel.ui.search.SearchTab
import com.example.capytravel.ui.travel.TravelTab

@Composable
fun ContentTab(
    currentTab: Int,
    onCloseContentTab: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier) {
        ContentTabHeader(
            onCloseContentTab = onCloseContentTab,
            modifier = Modifier
                .align(Alignment.End)
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.surfaceContainer)
        )
        when (currentTab) {
            0 -> SearchTab(modifier = Modifier.fillMaxWidth())
            1 -> TravelTab(modifier = Modifier.fillMaxWidth())
        }
    }
}

@Composable
fun ContentTabHeader(
    onCloseContentTab: () -> Unit,
    modifier: Modifier = Modifier
) {
    IconButton(
        onClick = onCloseContentTab,
        modifier = modifier
    ) {
        Icon(
            painter = painterResource(R.drawable.close_icon),
            contentDescription = stringResource(R.string.close)
        )
    }
}