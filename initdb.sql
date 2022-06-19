\c lsmsd;

CREATE TABLE IF NOT EXISTS items (
    id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    name text not null,
    description text,
    image_url text,
    documentation_url text
);


--- Policies
---
--- Policies have 3 parts:
---   - user_id: id of the user requesting access. If NULL, the policy applies
---              to all users 
---   - effect: either 'ALLOW' or 'DENY'. An action against a resource is
---             permitted, if there are one or more 'ALLOW' statements that
---             apply AND no 'DENY' statement applies
---   - action: identifier for the action the user intends to perform.
---             typically one of 'create', 'read', 'update', 'delete'. Typed
---             as text to allow user-defined actions.
---   - item_id: item this policy applies to. if NULL, the policy applies to
---              all items

CREATE TYPE policy_effect AS ENUM ('ALLOW', 'DENY');

CREATE TABLE IF NOT EXISTS policies (
    id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    user_id text,
    effect policy_effect NOT NULL,
    action text NOT NULL,
    item_id uuid,
    CONSTRAINT fk_item
        FOREIGN KEY(item_id)
            REFERENCES items(id)
);

CREATE FUNCTION is_user_allowed(user_id text, action text, item uuid) RETURNS boolean AS $$
DECLARE
    allow_stmts integer;
    deny_stmts integer;
BEGIN
    SELECT COUNT(*) from policies where 
        (effect = 'ALLOW'
            AND (policies.user_id = is_user_allowed.user_id OR policies.user_id IS NULL)
            AND (policies.action = is_user_allowed.action OR policies.action = '*')
            AND (policies.item_id = is_user_allowed.item OR policies.item_id IS NULL)
        )
        INTO allow_stmts;

    SELECT COUNT(*) from policies where 
        (effect = 'DENY' 
            AND (policies.user_id = is_user_allowed.user_id OR policies.user_id IS NULL)
            AND (policies.action = is_user_allowed.action OR policies.action = '*')
            AND (policies.item_id = is_user_allowed.item OR policies.item_id IS NULL)
        )
        INTO deny_stmts;

    RETURN (allow_stmts > 0 AND deny_stmts < 1);
END;
$$ LANGUAGE plpgsql;