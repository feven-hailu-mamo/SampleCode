ALTER TABLE Network
ADD (
    -- Calculate Network Address (network_int)
    network_int NUMBER GENERATED ALWAYS AS (
        CAST(
            (TO_NUMBER(SUBSTR(cidr, 1, INSTR(cidr, '.') - 1)) * 256 * 256 * 256) +
            (TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.') + 1, INSTR(cidr, '.', INSTR(cidr, '.') + 1) - INSTR(cidr, '.') - 1)) * 256 * 256) +
            (TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1, INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) - INSTR(cidr, '.', INSTR(cidr, '.') + 1) - 1)) * 256) +
            TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) + 1, INSTR(cidr, '/') - INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) - 1))
            AS NUMBER
        ) 
    ) VIRTUAL,

    -- Calculate Broadcast Address (broadcast_int)
    broadcast_int NUMBER GENERATED ALWAYS AS (
        CAST(
            (TO_NUMBER(SUBSTR(cidr, 1, INSTR(cidr, '.') - 1)) * 256 * 256 * 256) +
            (TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.') + 1, INSTR(cidr, '.', INSTR(cidr, '.') + 1) - INSTR(cidr, '.') - 1)) * 256 * 256) +
            (TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1, INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) - INSTR(cidr, '.', INSTR(cidr, '.') + 1) - 1)) * 256) +
            TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) + 1, INSTR(cidr, '/') - INSTR(cidr, '.', INSTR(cidr, '.', INSTR(cidr, '.') + 1) + 1) - 1)) + 
            (POWER(2, (32 - TO_NUMBER(SUBSTR(cidr, INSTR(cidr, '/') + 1)))) - 1)
            AS NUMBER
        )
    ) VIRTUAL
)
^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(3[0-2]|[12]?[0-9])$


-- Adding the network_int computed column
ALTER TABLE Network
ADD COLUMN network_int INT GENERATED ALWAYS AS (
    (CAST(SUBSTRING_INDEX(cidr, '.', 1) AS INT) * 256 * 256 * 256) +
    (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 2), '.', -1) AS INT) * 256 * 256) +
    (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 3), '.', -1) AS INT) * 256) +
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 4), '/', 1) AS INT)
) STORED;

-- Adding the broadcast_int computed column
ALTER TABLE Network
ADD COLUMN broadcast_int INT GENERATED ALWAYS AS (
    (CAST(SUBSTRING_INDEX(cidr, '.', 1) AS INT) * 256 * 256 * 256) +
    (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 2), '.', -1) AS INT) * 256 * 256) +
    (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 3), '.', -1) AS INT) * 256) +
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(cidr, '.', 4), '/', 1) AS INT) + 
    (POWER(2, (32 - CAST(SUBSTRING_INDEX(cidr, '/', -1) AS INT))) - 1)
) STORED;

