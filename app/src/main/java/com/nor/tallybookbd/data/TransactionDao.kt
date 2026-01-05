package com.nor.tallybookbd.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface TransactionDao {
    @Insert
    suspend fun insert(transaction: Transaction)
    
    @Query("SELECT * FROM ")
    suspend fun getAll(): List<Transaction>
}
