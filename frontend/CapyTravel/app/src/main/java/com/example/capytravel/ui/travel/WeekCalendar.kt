package com.example.capytravel.ui.travel

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalLocale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.capytravel.R
import com.kizitonwose.calendar.compose.WeekCalendar
import com.kizitonwose.calendar.compose.weekcalendar.rememberWeekCalendarState
import com.kizitonwose.calendar.core.WeekDay
import com.kizitonwose.calendar.core.atStartOfMonth
import com.kizitonwose.calendar.core.daysOfWeek
import java.time.DayOfWeek
import java.time.LocalDate
import java.time.YearMonth
import java.time.format.TextStyle

@Composable
fun WeekCalendar(modifier: Modifier = Modifier) {
    val daysOfWeek = remember { daysOfWeek(firstDayOfWeek = DayOfWeek.MONDAY) }
    Column(
        modifier,
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        WeekCalendarHeader(
            daysOfWeek = daysOfWeek,
            modifier = Modifier.fillMaxWidth()
        )
        WeekCalendarBody(
            daysOfWeek = daysOfWeek,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@Composable
fun WeekCalendarBody(
    daysOfWeek: List<DayOfWeek>,
    modifier: Modifier = Modifier
) {
    val currentMonth = remember { YearMonth.now() }
    val state = rememberWeekCalendarState(
        startDate = remember { currentMonth.minusMonths(25).atStartOfMonth() },
        endDate = remember { currentMonth.plusMonths(25).atEndOfMonth() },
        firstVisibleWeekDate = remember { LocalDate.now() },
        firstDayOfWeek = daysOfWeek.first()
    )
    WeekCalendar(
        state = state,
        modifier = modifier,
        dayContent = {
            WeekCalendarDay(
                day = it,
                modifier = Modifier
                    .aspectRatio(1f)
                    .clip(CircleShape)
                    .clickable(onClick = {})
            )
        }
    )
}

@Composable
fun WeekCalendarDay(day: WeekDay, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier,
        contentAlignment = Alignment.Center
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize(0.6f) // 0.5 for foldable, 0.4 for tablet
                .clip(CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = day.date.dayOfMonth.toString()
            )
        }
    }
}

@Composable
fun WeekCalendarHeader(
    daysOfWeek: List<DayOfWeek>,
    modifier: Modifier = Modifier
) {
    Column(modifier) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            HeaderWeekSelector()
            IconButton(
                onClick = {},
                modifier = Modifier
                    .clip(CircleShape)
                    .background(color = MaterialTheme.colorScheme.surfaceContainer)
            ) {
                Icon(
                    painter = painterResource(R.drawable.more_vert_icon),
                    contentDescription = stringResource(R.string.more)
                )
            }
        }
        Spacer(
            modifier = Modifier.height(32.dp)
        )
        HeaderWeekDays(
            daysOfWeek = daysOfWeek,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@Composable
fun HeaderWeekSelector(modifier: Modifier = Modifier) {
    Row(
        modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(32.dp)
    ) {
        IconButton(
            onClick = {},
            modifier = Modifier
                .clip(CircleShape)
                .background(color = MaterialTheme.colorScheme.surfaceContainer)
        ) {
            Icon(
                painter = painterResource(R.drawable.arrow_back_icon),
                contentDescription = stringResource(R.string.back)
            )
        }
        Text(
            text = stringResource(R.string.mock_header_week_selector),
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.Bold
        )
        IconButton(
            onClick = {},
            modifier = Modifier
                .clip(CircleShape)
                .background(color = MaterialTheme.colorScheme.surfaceContainer)
        ) {
            Icon(
                painter = painterResource(R.drawable.arrow_forward_icon),
                contentDescription = stringResource(R.string.forward)
            )
        }
    }
}

@Composable
fun HeaderWeekDays(daysOfWeek: List<DayOfWeek>, modifier: Modifier = Modifier) {
    Row(modifier) {
        daysOfWeek.forEachIndexed  { index, day ->
            Text(
                text = day.getDisplayName(
                    TextStyle.SHORT,
                    LocalLocale.current.platformLocale
                ),
                color = if (index >= 5) Color.Red else MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.weight(1f),
                style = MaterialTheme.typography.labelMedium,
                textAlign = TextAlign.Center
            )
        }
    }
}