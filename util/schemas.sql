-- DDL for tables for gasapp



--=======================================================
--=======================================================
--carapp.vehicle
--=======================================================
--=======================================================
DROP TRIGGER IF EXISTS vehicle_upd ON carapp.vehicle;
DROP FUNCTION IF EXISTS carapp.vehicle_mod_trigger_fnc();
TRUNCATE TABLE carapp.vehicle CASCADE;
DROP TABLE IF EXISTS carapp.vehicle CASCADE;
DROP SEQUENCE IF EXISTS vehicle_rowid_seq;

CREATE TABLE carapp.vehicle (
    rowid SERIAL,
    change_date timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    upd_status varchar(1) DEFAuLT 'I' NOT NULL,
    vehicle_id SERIAL,
    make varchar(100) NOT NULL,
    model varchar(150) NOT NULL,
    year smallint NOT NULL,
    PRIMARY KEY(vehicle_id)
);



CREATE FUNCTION carapp.vehicle_mod_trigger_fnc() RETURNS trigger AS $vehicle_mod_trigger_fnc$
    BEGIN
        NEW.change_date := CURRENT_TIMESTAMP;
        NEW.upd_status = 'U';
        RETURN NEW;
    END;
$vehicle_mod_trigger_fnc$ LANGUAGE plpgsql;



CREATE TRIGGER vehicle_upd
    BEFORE UPDATE ON carapp.vehicle
    FOR EACH ROW
    EXECUTE PROCEDURE carapp.vehicle_mod_trigger_fnc();



-- Current car population
INSERT INTO carapp.vehicle(make, model, year) VALUES ('jeep', 'wrangler', 1997);
INSERT INTO carapp.vehicle(make, model, year) VALUES ('ford', 'windstar', 1998);


--=======================================================
--=======================================================
--carapp.gas
--=======================================================
--=======================================================
DROP TRIGGER IF EXISTS gas_upd ON carapp.gas;
DROP FUNCTION IF EXISTS carapp.gas_mod_trigger_fnc();
TRUNCATE TABLE carapp.gas CASCADE;
DROP TABLE IF EXISTS carapp.gas CASCADE;
DROP SEQUENCE IF EXISTS gas_rowid_seq;


CREATE TABLE carapp.gas (
    rowid SERIAL,
    change_date timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    upd_status varchar(1) DEFAuLT 'I' NOT NULL,
    vehicle_id integer,
    purchase_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gallons real NOT NULL,
    cost real NOT NULL,
    PRIMARY KEY(rowid),
    CONSTRAINT fk_gas_vehicle_id
        FOREIGN KEY(vehicle_id)
            REFERENCES carapp.vehicle(vehicle_id)
);



CREATE OR REPLACE FUNCTION carapp.gas_mod_trigger_fnc() RETURNS trigger AS $gas_mod_trigger_fnc$
    BEGIN
        NEW.change_date := CURRENT_TIMESTAMP;
        NEW.upd_status = 'U';
        RETURN NEW;
    END;
$gas_mod_trigger_fnc$ LANGUAGE plpgsql;



CREATE TRIGGER gas_upd
    BEFORE UPDATE ON carapp.gas
    FOR EACH ROW
    EXECUTE PROCEDURE carapp.gas_mod_trigger_fnc();



