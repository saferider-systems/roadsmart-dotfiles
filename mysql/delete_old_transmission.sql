-- ============================================================================
-- DELETE _transmissions DATA BEFORE 2026 IN BATCHES
-- ============================================================================
-- MySQL 8.0.44 Compatible Procedure
-- Deletes data before January 1, 2026 in chunks of 10,000 rows
DROP PROCEDURE IF EXISTS delete_old_transmissions;

delimiter $$

CREATE PROCEDURE delete_old_transmissions()
BEGIN
    DECLARE rows_deleted INT DEFAULT 1;
    
    -- Loop until all old data is deleted
    WHILE rows_deleted > 0 DO
        -- Delete a batch
        DELETE FROM _transmissions
        WHERE createdAt < '2026-01-01 00:00:00'
        LIMIT 10000;
        
        -- Get number of rows affected
        SET rows_deleted = ROW_COUNT();
        
        -- Small delay to reduce database load (100ms)
        DO SLEEP(0.1);
        
    END WHILE;
    
    SELECT 'Deletion complete' as status;
    
END$$

delimiter
;

-- Execute the procedure
call delete_old_transmissions()
;

-- Optional: Drop the procedure after use
-- DROP PROCEDURE IF EXISTS delete_old_transmissions;
