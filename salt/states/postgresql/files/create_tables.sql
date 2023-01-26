--
-- Table structure for table `jids`
--

CREATE TABLE IF NOT EXISTS jids (
  jid varchar(255) NOT NULL primary key,
  load jsonb NOT NULL);

CREATE INDEX IF NOT EXISTS idx_jids_jsonb on jids
  USING gin (load)
  WITH (fastupdate=on);

ALTER TABLE jids OWNER TO salt;

--
-- Table structure for table `salt_returns`
--

CREATE TABLE IF NOT EXISTS salt_returns (
  fun varchar(50) NOT NULL,
  jid varchar(255) NOT NULL,
  return jsonb NOT NULL,
  id varchar(255) NOT NULL,
  success varchar(10) NOT NULL,
  full_ret jsonb NOT NULL,
  alter_time TIMESTAMP WITH TIME ZONE DEFAULT NOW());

CREATE INDEX IF NOT EXISTS idx_salt_returns_id ON salt_returns (id);
CREATE INDEX IF NOT EXISTS idx_salt_returns_jid ON salt_returns (jid);
CREATE INDEX IF NOT EXISTS idx_salt_returns_fun ON salt_returns (fun);
CREATE INDEX IF NOT EXISTS idx_salt_returns_return ON salt_returns
    USING gin (return) with (fastupdate=on);
CREATE INDEX IF NOT EXISTS idx_salt_returns_full_ret ON salt_returns
    USING gin (full_ret) with (fastupdate=on);

ALTER TABLE salt_returns OWNER TO salt;

--
-- Table structure for table `salt_events`
--

CREATE SEQUENCE IF NOT EXISTS seq_salt_events_id;
CREATE TABLE IF NOT EXISTS salt_events (
    id BIGINT NOT NULL UNIQUE DEFAULT nextval('seq_salt_events_id'),
    tag varchar(255) NOT NULL,
    data jsonb NOT NULL,
    alter_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    master_id varchar(255) NOT NULL);

CREATE INDEX IF NOT EXISTS idx_salt_events_tag on
    salt_events (tag);
CREATE INDEX IF NOT EXISTS idx_salt_events_data ON salt_events
    USING gin (data) with (fastupdate=on);

ALTER TABLE salt_events OWNER TO salt;
ALTER SEQUENCE seq_salt_events_id OWNER TO salt;

--

CREATE OR REPLACE FUNCTION parse_orch_return(character varying(255), jsonb)
RETURNS TABLE (id character varying(255), subjid text, state text, return jsonb, result boolean, changes boolean)
LANGUAGE plpgsql
IMMUTABLE
PARALLEL SAFE
AS $BODY$
DECLARE
    key text;
    ret jsonb;
    mid text;
    mret jsonb;
    subkey text;
    subret jsonb;
BEGIN
    FOR key, ret IN
        SELECT * FROM JSONB_EACH($2->'return'->'data'->$1)
    LOOP
        IF ret->>'__jid__' IS NULL THEN
            id := $1;
            subjid := '';
            state := key;
            return := ret;
            result := (ret->>'result')::boolean;
            changes := ret->'changes' <> '{}'::jsonb;
            RETURN NEXT;
        ELSIF ((ret->'changes'->'out')::text <> 'highstate') IS NOT TRUE THEN
            id := $1;
            subjid := '';
            state := key;
            return := ret;
            result := (ret->>'result')::boolean;
            changes := ret->'changes' <> '{}'::jsonb;
            RETURN NEXT;
        ELSE
            FOR mid, mret IN
                SELECT * FROM JSONB_EACH(ret->'changes'->'ret')
            LOOP
                CONTINUE WHEN jsonb_typeof(mret) <> 'object';
                id := mid;
                subjid := ret->>'__jid__';
                FOR subkey, subret IN
                    SELECT * FROM JSONB_EACH(mret)
                LOOP
                    state := subkey;
                    return := subret;
                    result := (subret->>'result')::boolean;
                    changes := subret->'changes' <> '{}'::jsonb;
                    RETURN NEXT;
                END LOOP;
            END LOOP;
        END IF;
    END LOOP;
END;
$BODY$;

CREATE OR REPLACE VIEW orchestrations AS SELECT id, jid, fun, (return->>'success')::boolean success FROM salt_returns WHERE fun IN ('runner.state.orchestrate', 'runner.state.orch');
CREATE OR REPLACE VIEW states AS SELECT sr.jid, to_timestamp(sr.jid, 'YYYYMMDDHH24MISSUS') jid_timestamp, (sr.return)->>'user' AS username, o.id, o.subjid, o.state, o.return, o.result, o.changes FROM salt_returns sr, parse_orch_return(sr.id, sr.return) o WHERE fun IN ('runner.state.orchestrate', 'runner.state.orch');

SELECT
    id,
    CASE WHEN (result IS true AND changes IS false) THEN 'unchanged'
    WHEN (result IS false) THEN 'failed'
    WHEN (result IS true AND changes IS true) THEN 'changed'
    END status,
    state,
    jsonb_pretty(return::jsonb) AS return
FROM states
WHERE jid='$JID';

--

GRANT CONNECT ON DATABASE salt TO saltro;
GRANT USAGE ON SCHEMA public TO saltro;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO saltro;
