package com.example.capytravel.ui.search

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.example.capytravel.R

enum class PlaceTaxonomy(val label: Int, val icon: Int, val color: Color) {
    ServicesAndBusiness (
        label = R.string.services_and_business,
        icon = R.drawable.services_and_business_icon,
        color = Color(220, 138, 120)
    ),
    Shopping (
        label = R.string.shopping,
        icon = R.drawable.shopping_icon,
        color = Color(221, 120, 120)
    ),
    FoodAndDrink (
        label = R.string.food_and_drink,
        icon = R.drawable.food_and_drink_icon,
        color = Color(234, 118, 203)
    ),
    HealthAndCare (
        label = R.string.health_care,
        icon = R.drawable.health_care_icon,
        color = Color(136, 57, 239)
    ),
    LifestyleServices (
        label = R.string.lifestyle_services,
        icon = R.drawable.lifestyle_services_icon,
        color = Color(210, 15, 57)
    ),
    TravelAndTransportation (
        label = R.string.travel_and_transportation,
        icon = R.drawable.travel_and_transportation_icon,
        color = Color(230, 69, 83)

    ),
    Education (
        label = R.string.education,
        icon = R.drawable.education_icon,
        color = Color(254, 100, 11)
    ),
    CulturalAndHistoric (
        label = R.string.cultural_and_historic,
        icon = R.drawable.cultural_and_historic_icon,
        color = Color(223, 142, 29)
    ),
    SportsAndRecreation (
        label = R.string.sports_and_recreation,
        icon = R.drawable.sports_and_recreation_icon,
        color = Color(64, 160, 43)
    ),
    Lodging (
        label = R.string.lodging,
        icon = R.drawable.lodging_icon,
        color = Color(23, 146, 153)
    ),
    CommunityAndGovernment (
        label = R.string.community_and_government,
        icon = R.drawable.community_and_government_icon,
        color = Color(4, 165, 229)
    ),
    ArtsAndEntertainment (
        label = R.string.arts_and_entertainment,
        icon = R.drawable.arts_and_entertainment_icon,
        color = Color(32, 159, 181)
    ),
    GeographicEntities (
        label = R.string.geographical_entities,
        icon = R.drawable.geographic_entities_icon,
        color = Color(30, 102, 245)
    )
}

@Composable
fun PlaceTaxonomyPicker(modifier: Modifier = Modifier) {
    var current by rememberSaveable { mutableIntStateOf(-1) }
    FlowRow(
        modifier,
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalArrangement = Arrangement.spacedBy(dimensionResource(R.dimen.padding_small)),
        maxItemsInEachRow = 5
    ) {
        PlaceTaxonomy.entries.forEachIndexed { index, taxonomy ->
            PlaceTaxonomyItem(
                item = taxonomy,
                onClick = { current = if (current != index) index else -1 },
                modifier = Modifier
                    .padding(dimensionResource(R.dimen.padding_extra_small))
                    .clip(CircleShape)
                    .background(
                        color =
                            if (current == index)
                                taxonomy.color
                            else
                                MaterialTheme.colorScheme.surfaceContainer
                    )
            )
        }
    }
    PlaceTaxonomySelectedTag(
        current = current,
        onClick = { current = -1 },
        modifier = Modifier.fillMaxWidth()
    )
}

@Composable
fun PlaceTaxonomyItem(item: PlaceTaxonomy, onClick: () -> Unit, modifier: Modifier = Modifier) {
    IconButton(
        onClick = onClick,
        modifier = modifier
    ) {
        Icon(
            painter = painterResource(item.icon),
            contentDescription = stringResource(item.label)
        )
    }
}

@Composable
fun PlaceTaxonomySelectedTag(current: Int, onClick: () -> Unit, modifier: Modifier = Modifier) {
    if (current != -1) {
        val item = PlaceTaxonomy.entries[current]
        Spacer(Modifier.height(32.dp))
        Box(
            modifier,
            contentAlignment = Alignment.Center
        ) {
            SuggestionChip(
                onClick = onClick,
                label = {
                    Text(
                        text = stringResource(item.label),
                        color = item.color
                    )
                }
            )
        }
    }
}