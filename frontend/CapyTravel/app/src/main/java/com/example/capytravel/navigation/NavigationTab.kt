package com.example.capytravel.navigation

import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.adaptive.navigationsuite.NavigationSuiteScope
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import com.example.capytravel.R

enum class NavigationTab(val icon: Int, val label: Int) {
    Search (
        icon = R.drawable.search_icon,
        label = R.string.side_search
    ),
    Travel (
        icon = R.drawable.travel_icon,
        label = R.string.side_travel
    ),
    Account (
        icon = R.drawable.account_icon,
        label = R.string.side_account
    )
}

fun NavigationSuiteScope.createTabs(
    currentTab: Int,
    onTabSelected: (Int) -> Unit
) {
    NavigationTab.entries.forEachIndexed { index, it ->
        item(
            label = {
                Text(
                    text = stringResource(it.label)
                )
            },
            icon = {
                Icon(
                    painter = painterResource(it.icon),
                    contentDescription = stringResource(it.label)
                )
            },
            selected = currentTab == index,
            onClick = { onTabSelected(index) }
        )
    }
}