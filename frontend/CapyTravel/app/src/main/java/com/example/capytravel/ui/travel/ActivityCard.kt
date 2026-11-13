package com.example.capytravel.ui.travel

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.example.capytravel.R

data class MockPlaceResult(
    val id:        String = "1",
    val name:      String = "Alton Towers Resort",
    val taxonomy:  String = "Cultural and Historic",
    val hierarchy: Map<String, String> = mapOf("country" to "England", "region" to "West Midlands", "county" to "Staffordshire", "locality" to "Alton / Farley")
)

@Composable
fun ActivityCard(
    modifier: Modifier = Modifier,
    place: MockPlaceResult = MockPlaceResult()
) {
    var isDropdownExpanded by rememberSaveable { mutableStateOf(false) }
    Card(
        modifier,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceContainer
        )
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                painter = painterResource(R.drawable.mock_place_image),
                contentDescription = "Just an image for testing purposes",
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .padding(dimensionResource(R.dimen.padding_medium))
                    .size(64.dp)
                    .shadow(elevation = 4.dp, CircleShape)
                    .clip(CircleShape)
            )
            Column(
                modifier = Modifier
                    .weight(1f)
                    .padding(dimensionResource(R.dimen.padding_large)),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Text(
                    text = place.name,
                    fontWeight = FontWeight.Bold,
                    style = MaterialTheme.typography.labelLarge,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    text = place.taxonomy,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    style = MaterialTheme.typography.labelMedium,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
            Box(modifier = Modifier) {
                IconButton(
                    onClick = {
                        isDropdownExpanded = !isDropdownExpanded
                    }
                ) {
                    Icon(
                        painter = painterResource(R.drawable.arrow_downward_icon),
                        contentDescription = stringResource(R.string.down)
                    )
                }
            }
        }
    }
}