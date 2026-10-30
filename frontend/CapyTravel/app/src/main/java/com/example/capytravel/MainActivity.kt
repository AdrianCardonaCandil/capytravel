package com.example.capytravel

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.material3.adaptive.navigationsuite.NavigationSuiteScaffold
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.example.capytravel.navigation.createTabs
import com.example.capytravel.ui.CapyTravelApp
import com.example.capytravel.ui.theme.CapyTravelTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            var currentTab by rememberSaveable { mutableIntStateOf(0) }
            CapyTravelTheme {
                NavigationSuiteScaffold(
                    navigationSuiteItems = {
                        createTabs(
                            currentTab,
                            { currentTab = it })
                    }
                ) {
                    CapyTravelApp(
                        modifier = Modifier
                            .fillMaxSize().safeDrawingPadding()
                    )
                }
            }
        }
    }
}