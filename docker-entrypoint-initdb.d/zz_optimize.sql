-- Create a stored procedure to optimize and analyze tables
DELIMITER //

CREATE PROCEDURE optimize_and_analyze_all_tables()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE current_schema VARCHAR(255);
  DECLARE current_table VARCHAR(255);
  DECLARE cur CURSOR FOR 
    SELECT TABLE_SCHEMA, TABLE_NAME 
    FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'mysql', 'sys');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO current_schema, current_table;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET @sql_optimize = CONCAT('OPTIMIZE TABLE `', current_schema, '`.`', current_table, '`');
    PREPARE stmt_optimize FROM @sql_optimize;
    EXECUTE stmt_optimize;
    DEALLOCATE PREPARE stmt_optimize;

    SET @sql_analyze = CONCAT('ANALYZE TABLE `', current_schema, '`.`', current_table, '`');
    PREPARE stmt_analyze FROM @sql_analyze;
    EXECUTE stmt_analyze;
    DEALLOCATE PREPARE stmt_analyze;
  END LOOP;

  CLOSE cur;
END //

DELIMITER ;

-- Call the stored procedure
CALL optimize_and_analyze_all_tables();