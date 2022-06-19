\c lsmsd;


insert into items (
    id,
    name
) values 
    ( '6b6900b2-4642-4bad-a32a-c01d2744b14f', 'getränkeautomat' ),
    ( '8658b598-8522-4607-a3d4-9d0d534b2f2a', 'plotter' ),
    ( 'ba9f0e3d-6514-4a4b-9a9f-771d25bdbbda', '3D-Drucker' )
;

INSERT into policies (
    user_id,
    effect,
    action
) VALUES
    ( NULL, 'ALLOW', '*' ),
    ( 'privi', 'DENY', '*')
;
