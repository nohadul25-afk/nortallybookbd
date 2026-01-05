#!/bin/bash
# --------------------------------------------------
# Nor Tallybook BD - Full Project Skeleton Generator
# Automatically creates folders, files, and initial code
# Android 10+ (API 29+) compatible
# --------------------------------------------------

ROOT_DIR=$(pwd)
echo "Project root: $ROOT_DIR"

# ------------------ Create folders ------------------
echo "Creating folders..."

mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui
mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data
mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/backup
mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/auth
mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/notifications
mkdir -p $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/utils

mkdir -p $ROOT_DIR/app/src/main/res/layout
mkdir -p $ROOT_DIR/app/src/main/res/values
mkdir -p $ROOT_DIR/app/src/main/res/drawable

# ------------------ Kotlin UI files ------------------
echo "Creating UI files..."

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/DashboardFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class DashboardFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_dashboard, container, false)
    }
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/CustomerListFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class CustomerListFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_customer_list, container, false)
    }
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/LedgerFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class LedgerFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_ledger, container, false)
    }
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/TransactionEntryFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class TransactionEntryFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_transaction_entry, container, false)
    }
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/ReportsFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class ReportsFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_reports, container, false)
    }
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/ui/SettingsFragment.kt <<EOL
package com.nor.tallybookbd.ui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.nor.tallybookbd.R

class SettingsFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_settings, container, false)
    }
}
EOL

# ------------------ Data Layer ------------------
echo "Creating Data files..."

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data/Customer.kt <<EOL
package com.nor.tallybookbd.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Customer(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val name: String,
    val phone: String
)
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data/Transaction.kt <<EOL
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
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data/CustomerDao.kt <<EOL
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
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data/TransactionDao.kt <<EOL
package com.nor.tallybookbd.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface TransactionDao {
    @Insert
    suspend fun insert(transaction: Transaction)
    
    @Query("SELECT * FROM `Transaction`")
    suspend fun getAll(): List<Transaction>
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/data/AppDatabase.kt <<EOL
package com.nor.tallybookbd.data

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(entities = [Customer::class, Transaction::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun customerDao(): CustomerDao
    abstract fun transactionDao(): TransactionDao
}
EOL

# ------------------ Backup ------------------
cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/backup/BackupManager.kt <<EOL
package com.nor.tallybookbd.backup

class BackupManager {
    // TODO: Google Drive auto-backup logic
}
EOL

# ------------------ Auth ------------------
cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/auth/PinLockActivity.kt <<EOL
package com.nor.tallybookbd.auth

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class PinLockActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // TODO: Set content view
    }
}
EOL

# ------------------ Notifications ------------------
cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/notifications/ReminderWorker.kt <<EOL
package com.nor.tallybookbd.notifications

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

class ReminderWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {
    override fun doWork(): Result {
        // TODO: Reminder/Notification logic
        return Result.success()
    }
}
EOL

# ------------------ Utils ------------------
cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/utils/EncryptionUtils.kt <<EOL
package com.nor.tallybookbd.utils

object EncryptionUtils {
    // TODO: Encryption helper functions
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/utils/DateUtils.kt <<EOL
package com.nor.tallybookbd.utils

object DateUtils {
    // TODO: Date helper functions
}
EOL

cat > $ROOT_DIR/app/src/main/java/com/nor/tallybookbd/utils/Constants.kt <<EOL
package com.nor.tallybookbd.utils

object Constants {
    // TODO: App constants
}
EOL

# ------------------ XML Layouts ------------------
echo "Creating XML layout skeletons..."

for layout in fragment_dashboard fragment_customer_list fragment_ledger fragment_transaction_entry fragment_reports fragment_settings activity_pin_lock
do
cat > $ROOT_DIR/app/src/main/res/layout/$layout.xml <<EOL
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">
    
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="$layout" />

</LinearLayout>
EOL
done

# ------------------ XML Values ------------------
cat > $ROOT_DIR/app/src/main/res/values/colors.xml <<EOL
<resources>
    <color name="primaryColor">#6200EE</color>
    <color name="primaryDarkColor">#3700B3</color>
    <color name="accentColor">#03DAC5</color>
</resources>
EOL

cat > $ROOT_DIR/app/src/main/res/values/strings.xml <<EOL
<resources>
    <string name="app_name">Nor Tallybook Bd</string>
</resources>
EOL

cat > $ROOT_DIR/app/src/main/res/values/styles.xml <<EOL
<resources>
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    </style>
</resources>
EOL

# ------------------ Gradle files ------------------
touch $ROOT_DIR/build.gradle
touch $ROOT_DIR/settings.gradle
touch $ROOT_DIR/app/build.gradle

echo "All folders, files, and skeleton code created successfully!"
