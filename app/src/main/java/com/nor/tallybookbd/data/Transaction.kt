package com.nor.tallybookbd.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Transaction(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val customerId: Int,
    val amount: Double,
    val date: Long
)
