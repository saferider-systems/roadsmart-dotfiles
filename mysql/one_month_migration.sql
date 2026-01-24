DELIMITER //

DROP PROCEDURE IF EXISTS MigrateWithWeeklyPartitions //

CREATE PROCEDURE MigrateWithWeeklyPartitions(IN start_id BIGINT, IN end_id BIGINT)
BEGIN
    -- 1. Create the skeleton using the production schema
    DROP TABLE IF EXISTS transmissions_test;
    CREATE TABLE transmissions_test LIKE _transmissions;

    -- 2. Modify the Primary Key (Instant on empty table)
    ALTER TABLE transmissions_test 
        DROP PRIMARY KEY, 
        ADD PRIMARY KEY (id, received_date_time);

    -- 3. Add Weekly Partitions (5-week coverage starting Jan 23, 2026)
    -- We define the "Less Than" date as the start of the following week.
    ALTER TABLE transmissions_test 
    PARTITION BY RANGE COLUMNS(received_date_time) (
        PARTITION p_2026_w04 VALUES LESS THAN ('2026-01-26 00:00:00'),
        PARTITION p_2026_w05 VALUES LESS THAN ('2026-02-02 00:00:00'),
        PARTITION p_2026_w06 VALUES LESS THAN ('2026-02-09 00:00:00'),
        PARTITION p_2026_w07 VALUES LESS THAN ('2026-02-16 00:00:00'),
        PARTITION p_2026_w08 VALUES LESS THAN ('2026-02-23 00:00:00'),
        PARTITION p_future VALUES LESS THAN (MAXVALUE)
    );

    -- 4. Drop the heavy index before the big move
    -- Crucial for performance when moving millions of rows.
    ALTER TABLE transmissions_test DROP INDEX id_transmissions_field;

    -- 5. Perform the Bulk Insert
    INSERT INTO transmissions_test
    SELECT * FROM _transmissions
    WHERE id >= start_id AND id < end_id;

    -- 6. Rebuild the Composite Index
    -- Rebuilding on 5 larger partitions is faster than rebuilding on 168 small hourly ones.
    ALTER TABLE transmissions_test ADD INDEX id_transmissions_field 
    (tracker_id, received_date_time, report_date_time, vehicle_registration);

END //

DELIMITER ;
