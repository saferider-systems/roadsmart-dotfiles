/*
================================================================================
Stored Procedure: MigrateWithDailyPartitions
================================================================================
Purpose:
    Test migration procedure to create a partitioned copy of _transmissions table
    with daily partitions for one week of data (Jan 18-24, 2026).

    This procedure demonstrates the partition strategy before applying it to
    production, allowing validation of:
    - Partition distribution across dates
    - Index rebuild performance
    - Query performance on partitioned data
    - Data integrity after migration

Parameters:
    @start_id (BIGINT) - Starting ID for range of records to migrate
    @end_id (BIGINT)   - Ending ID for range of records to migrate (exclusive)

Usage Example:
    -- Migrate one week of data for testing
    CALL MigrateWithDailyPartitions(10726600000, 10850000000);

Expected Duration:
    - For ~140M rows (1 week): 10-15 minutes
    - Breakdown:
        * Table structure setup: < 5 seconds
        * Data insert: 3-5 minutes
        * Index rebuild: 5-8 minutes

Performance Notes:
    - Drops the composite index BEFORE bulk insert for speed
    - Rebuilds the index AFTER insert (faster than maintaining during insert)
    - Uses RANGE COLUMNS partitioning for efficient date-based queries
    - Each partition represents exactly one day of telemetry data

Post-Migration Validation:
    - Verify partition distribution
    - Check for NULL received_date_time values (should be 0)
    - Compare row counts between source and destination
    - Test query performance on partitioned table

Author: Database Team
Created: 2026-01-24
Version: 1.0 - Test migration with daily partitions
================================================================================
*/

DROP PROCEDURE IF EXISTS MigrateWithDailyPartitions;

CREATE PROCEDURE MigrateWithDailyPartitions(
    IN start_id BIGINT,
    IN end_id BIGINT
)
BEGIN
    -- ========================================================================
    -- STEP 1: Create table structure from production schema
    -- ========================================================================
    -- Drop existing test table if present to ensure clean state
    DROP TABLE IF EXISTS transmissions_test;
    
    -- Clone the structure of _transmissions (columns, data types, indexes)
    -- Note: Does NOT copy data, partitioning, or triggers
    CREATE TABLE transmissions_test LIKE _transmissions;
    
    -- ========================================================================
    -- STEP 2: Enforce NOT NULL constraint on partition key
    -- ========================================================================
    -- Required because partitioning by received_date_time means NULL values
    -- cannot be stored. This prevents partition routing errors.
    ALTER TABLE transmissions_test 
    MODIFY COLUMN received_date_time DATETIME NOT NULL;
    
    -- ========================================================================
    -- STEP 3: Modify Primary Key to include partition column
    -- ========================================================================
    -- MySQL partitioning requires that ALL unique keys (including PRIMARY KEY)
    -- must include the partitioning column (received_date_time).
    -- 
    -- Why this works:
    -- - id remains first in the key, so lookups by id alone are still efficient
    -- - Composite key (id, received_date_time) enables partition pruning
    -- - Executed on empty table, so this is instantaneous
    ALTER TABLE transmissions_test
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (id, received_date_time);
    
    -- ========================================================================
    -- STEP 4: Create daily partitions for one week (Jan 18-24, 2026)
    -- ========================================================================
    -- Uses RANGE COLUMNS partitioning for intuitive date-based routing
    -- Each partition contains exactly one day of data
    -- 
    -- Partition logic:
    -- - p_20260118: Stores 2026-01-18 00:00:00 to 2026-01-18 23:59:59
    -- - p_20260119: Stores 2026-01-19 00:00:00 to 2026-01-19 23:59:59
    -- - ... and so on
    -- - p_future: Catches any data beyond Jan 24 (safety net)
    ALTER TABLE transmissions_test
    PARTITION BY RANGE COLUMNS (received_date_time) (
        PARTITION p_20260118 VALUES LESS THAN ('2026-01-19 00:00:00'),
        PARTITION p_20260119 VALUES LESS THAN ('2026-01-20 00:00:00'),
        PARTITION p_20260120 VALUES LESS THAN ('2026-01-21 00:00:00'),
        PARTITION p_20260121 VALUES LESS THAN ('2026-01-22 00:00:00'),
        PARTITION p_20260122 VALUES LESS THAN ('2026-01-23 00:00:00'),
        PARTITION p_20260123 VALUES LESS THAN ('2026-01-24 00:00:00'),
        PARTITION p_20260124 VALUES LESS THAN ('2026-01-25 00:00:00'),
        PARTITION p_future VALUES LESS THAN (MAXVALUE)
    );
    
    -- ========================================================================
    -- STEP 5: Drop composite index before bulk insert
    -- ========================================================================
    -- The id_transmissions_field index is expensive to maintain during INSERT
    -- Dropping it before the bulk insert significantly improves performance
    -- We'll rebuild it in Step 7 after all data is loaded
    ALTER TABLE transmissions_test DROP INDEX id_transmissions_field;
    
    -- ========================================================================
    -- STEP 6: Bulk insert data from production table
    -- ========================================================================
    -- Copies all rows within the specified ID range
    -- MySQL automatically routes each row to the correct partition based on
    -- its received_date_time value
    -- 
    -- Note: start_id and end_id only filter which rows to copy - they do NOT
    -- affect partition placement. Partition routing is purely date-based.
    INSERT INTO transmissions_test
    SELECT * FROM _transmissions
    WHERE id >= start_id AND id < end_id;
    
    -- ========================================================================
    -- STEP 7: Rebuild composite index after data load
    -- ========================================================================
    -- Rebuilding the index after all data is loaded is 3-5x faster than
    -- maintaining the index during INSERT operations
    -- 
    -- This composite index supports common query patterns:
    -- - Lookups by tracker_id + date range
    -- - Time-series queries filtered by vehicle
    ALTER TABLE transmissions_test ADD INDEX id_transmissions_field
    (tracker_id, received_date_time, report_date_time, vehicle_registration);
    
END;
