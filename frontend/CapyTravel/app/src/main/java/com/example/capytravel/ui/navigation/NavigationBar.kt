package com.example.capytravel.ui.navigation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.capytravel.R

sealed class NavigationBarItem(val icon: Int, val label: Int) {
    data object Search : NavigationBarItem (
        icon = R.drawable.search_icon,
        label = R.string.side_search
    )
    data object Travel : NavigationBarItem (
        icon = R.drawable.travel_icon,
        label = R.string.side_travel
    )
    data object Account : NavigationBarItem (
        icon = R.drawable.account_icon,
        label = R.string.side_account
    )

    companion object {
        val values = listOf(Search, Travel, Account)
    }
}

@Composable
fun NavigationBar(modifier: Modifier = Modifier) {
    ElevatedCard(
        elevation = CardDefaults.cardElevation(
            defaultElevation = dimensionResource(R.dimen.padding_extra_small)
        ),
        modifier = modifier
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(dimensionResource(R.dimen.padding_medium)),
            horizontalArrangement = Arrangement.SpaceAround
        ) {
            NavigationBarItem.values.forEach {
                NavigationBarItemElement(it)
            }
        }
    }
}

@Composable
fun NavigationBarItemElement(item: NavigationBarItem, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon (
            painter = painterResource(item.icon),
            contentDescription = stringResource(item.label)
        )
        Text (
            text = stringResource(item.label),
            fontSize = MaterialTheme.typography.bodyMedium.fontSize,
            fontWeight = FontWeight.Light
        )
    }
}