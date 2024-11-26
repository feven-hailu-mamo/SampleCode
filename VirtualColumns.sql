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
/
