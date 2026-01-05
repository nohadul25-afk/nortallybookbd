package com.nor.tallybookbd.data

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(entities = [Customer::class, Transaction::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun customerDao(): CustomerDao
    abstract fun transactionDao(): TransactionDao
}
