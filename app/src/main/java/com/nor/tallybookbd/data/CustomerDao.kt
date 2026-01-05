package com.nor.tallybookbd.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface CustomerDao {
    @Insert
    suspend fun insert(customer: Customer)
    
    @Query("SELECT * FROM Customer")
    suspend fun getAll(): List<Customer>
}
