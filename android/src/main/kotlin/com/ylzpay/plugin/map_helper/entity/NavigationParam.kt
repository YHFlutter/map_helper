package com.ylzpay.plugin.map_helper.entity
import androidx.annotation.Keep

/**
 *  Author:      SherlockShi
 *  Email:       sherlock_shi@163.com
 *  Date:        2021-03-03 14:57
 *  Description:
 */
@Keep
data class NavigationParam(
    val address: String?,
    val lat: String?,
    val lng: String?
)