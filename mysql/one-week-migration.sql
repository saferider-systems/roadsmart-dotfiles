DELIMITER //

DROP PROCEDURE IF EXISTS MigrateWithDailyPartitions //

CREATE PROCEDURE MigrateWithDailyPartitions(IN start_id BIGINT, IN end_id BIGINT)
BEGIN
    -- 1. Create the skeleton using the production schema
    DROP TABLE IF EXISTS transmissions_test;
    CREATE TABLE transmissions_test LIKE _transmissions;
    
    -- 2. Enforce NOT NULL constraint on partition key
    -- Required because partitioning by received_date_time means NULL values cannot be stored
    ALTER TABLE transmissions_test 
        MODIFY COLUMN received_date_time DATETIME NOT NULL;
    
    -- 3. Modify the Primary Key (Instant on empty table)
    -- MySQL partitioning requires that ALL unique keys must include the partitioning column
    ALTER TABLE transmissions_test 
        DROP PRIMARY KEY, 
        ADD PRIMARY KEY (id, received_date_time);
    
    -- 4. Add Daily Partitions (1 week: Jan 18-24, 2026)
    -- Each partition represents exactly one day of telemetry data
    ALTER TABLE transmissions_test 
    PARTITION BY RANGE COLUMNS(received_date_time) (
        PARTITION p_20260118 VALUES LESS THAN ('2026-01-19 00:00:00'),
        PARTITION p_20260119 VALUES LESS THAN ('2026-01-20 00:00:00'),
        PARTITION p_20260120 VALUES LESS THAN ('2026-01-21 00:00:00'),
        PARTITION p_20260121 VALUES LESS THAN ('2026-01-22 00:00:00'),
        PARTITION p_20260122 VALUES LESS THAN ('2026-01-23 00:00:00'),
        PARTITION p_20260123 VALUES LESS THAN ('2026-01-24 00:00:00'),
        PARTITION p_20260124 VALUES LESS THAN ('2026-01-25 00:00:00'),
        PARTITION p_future VALUES LESS THAN (MAXVALUE)
    );
    
    -- 5. Drop the heavy index before the big move
    -- Crucial for performance when moving millions of rows
    ALTER TABLE transmissions_test DROP INDEX id_transmissions_field;
    
    -- 6. Perform the Bulk Insert
    -- MySQL routes each row to the correct partition based on received_date_time
    INSERT INTO transmissions_test
    SELECT * FROM _transmissions
    WHERE id >= start_id AND id < end_id;
    
    -- 7. Rebuild the Composite Index
    -- Rebuilding after data load is 3-5x faster than maintaining during INSERT
    ALTER TABLE transmissions_test ADD INDEX id_transmissions_field 
    (tracker_id, received_date_time, report_date_time, vehicle_registration);
    
END //

DELIMITER ;
