package com.nor.tallybookbd.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Customer(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val name: String,
    val phone: String
)
