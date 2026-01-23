DELIMITER //

DROP PROCEDURE IF EXISTS MigrateWithHourlyPartitions //

CREATE PROCEDURE MigrateWithHourlyPartitions(IN start_id BIGINT, IN end_id BIGINT)
BEGIN
    -- 1. Create the skeleton using the production schema
    DROP TABLE IF EXISTS transmissions_test;
    CREATE TABLE transmissions_test LIKE _transmissions;

    -- 2. Modify the Primary Key (Instant on empty table)
    ALTER TABLE transmissions_test 
        DROP PRIMARY KEY, 
        ADD PRIMARY KEY (id, received_date_time);

    -- 3. Add 23 Hourly Partitions for Jan 23, 2026
    ALTER TABLE transmissions_test 
    PARTITION BY RANGE COLUMNS(received_date_time) (
        PARTITION p00 VALUES LESS THAN ('2026-01-23 01:00:00'),
        PARTITION p01 VALUES LESS THAN ('2026-01-23 02:00:00'),
        PARTITION p02 VALUES LESS THAN ('2026-01-23 03:00:00'),
        PARTITION p03 VALUES LESS THAN ('2026-01-23 04:00:00'),
        PARTITION p04 VALUES LESS THAN ('2026-01-23 05:00:00'),
        PARTITION p05 VALUES LESS THAN ('2026-01-23 06:00:00'),
        PARTITION p06 VALUES LESS THAN ('2026-01-23 07:00:00'),
        PARTITION p07 VALUES LESS THAN ('2026-01-23 08:00:00'),
        PARTITION p08 VALUES LESS THAN ('2026-01-23 09:00:00'),
        PARTITION p09 VALUES LESS THAN ('2026-01-23 10:00:00'),
        PARTITION p10 VALUES LESS THAN ('2026-01-23 11:00:00'),
        PARTITION p11 VALUES LESS THAN ('2026-01-23 12:00:00'),
        PARTITION p12 VALUES LESS THAN ('2026-01-23 13:00:00'),
        PARTITION p13 VALUES LESS THAN ('2026-01-23 14:00:00'),
        PARTITION p14 VALUES LESS THAN ('2026-01-23 15:00:00'),
        PARTITION p15 VALUES LESS THAN ('2026-01-23 16:00:00'),
        PARTITION p16 VALUES LESS THAN ('2026-01-23 17:00:00'),
        PARTITION p17 VALUES LESS THAN ('2026-01-23 18:00:00'),
        PARTITION p18 VALUES LESS THAN ('2026-01-23 19:00:00'),
        PARTITION p19 VALUES LESS THAN ('2026-01-23 20:00:00'),
        PARTITION p20 VALUES LESS THAN ('2026-01-23 21:00:00'),
        PARTITION p21 VALUES LESS THAN ('2026-01-23 22:00:00'),
        PARTITION p22 VALUES LESS THAN ('2026-01-23 23:00:00'),
        PARTITION p_future VALUES LESS THAN (MAXVALUE)
    );

    -- 4. Drop the heavy index before the big move
    -- This ensures we only deal with sequential writes during the migration.
    ALTER TABLE transmissions_test DROP INDEX id_transmissions_field;

    -- 5. Perform the Bulk Insert
    -- Uses the parameters passed into the procedure.
    INSERT INTO transmissions_test
    SELECT * FROM _transmissions
    WHERE id >= start_id AND id < end_id;

    -- 6. Rebuild the Composite Index
    -- Rebuilding on partitioned tables is efficient as MySQL sorts by partition.
    ALTER TABLE transmissions_test ADD INDEX id_transmissions_field 
    (tracker_id, received_date_time, report_date_time, vehicle_registration);

END //

DELIMITER ;
