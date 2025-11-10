SET SERVEROUTPUT ON;

DECLARE
    TYPE performance_array IS VARRAY(5) OF NUMBER;
    TYPE intervention_table IS TABLE OF VARCHAR2(100);
    
    TYPE district_count IS TABLE OF NUMBER INDEX BY VARCHAR2(10);
    v_count_per_district district_count;

    TYPE dropout_rec IS RECORD (
        id           NUMBER,
        name         VARCHAR2(50),
        age          NUMBER,
        district     VARCHAR2(10),
        job_title    VARCHAR2(50),
        reason       VARCHAR2(100),
        scores       performance_array,
        actions      intervention_table
    );

    TYPE dropout_table IS TABLE OF dropout_rec;
    all_dropouts dropout_table := dropout_table();

    emp_count NUMBER := 2;
BEGIN
    all_dropouts.EXTEND;
    all_dropouts(1).id       := 1;
    all_dropouts(1).name     := 'Alice Mwali';
    all_dropouts(1).age      := 27;
    all_dropouts(1).district := 'KIG';
    all_dropouts(1).job_title := 'Accountant';
    all_dropouts(1).reason   := 'Low salary';
    all_dropouts(1).scores   := performance_array(90, 85, 88, 80, 75);
    all_dropouts(1).actions  := intervention_table('Salary review', 'Career counselling');

    all_dropouts.EXTEND;
    all_dropouts(2).id       := 2;
    all_dropouts(2).name     := 'Eric Mbabazi';
    all_dropouts(2).age      := 31;
    all_dropouts(2).district := 'NOR';
    all_dropouts(2).job_title := 'IT Support';
    all_dropouts(2).reason   := 'Relocated';
    all_dropouts(2).scores   := performance_array(88, 84, 82, 79, 77);
    all_dropouts(2).actions  := intervention_table('Remote work option', 'Transport facilitation');

    FOR i IN 1 .. emp_count LOOP
        v_count_per_district(all_dropouts(i).district) :=
            NVL(v_count_per_district(all_dropouts(i).district), 0) + 1;
    END LOOP;

    FOR i IN 1 .. emp_count LOOP
        IF all_dropouts(i).age < 18 THEN
            GOTO invalid_age;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('All ages valid.');
    GOTO continue_processing;

    <<invalid_age>>
    DBMS_OUTPUT.PUT_LINE('ERROR: Invalid age detected.');
    RETURN;

    <<continue_processing>>
    FOR i IN 1 .. emp_count LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
        DBMS_OUTPUT.PUT_LINE('Employee: ' || all_dropouts(i).name);
        DBMS_OUTPUT.PUT_LINE('District: ' || all_dropouts(i).district);
        DBMS_OUTPUT.PUT_LINE('Reason: ' || all_dropouts(i).reason);

        DBMS_OUTPUT.PUT_LINE('Scores:');
        FOR s IN 1 .. all_dropouts(i).scores.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || all_dropouts(i).scores(s));
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Actions Taken:');
        FOR a IN 1 .. all_dropouts(i).actions.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || all_dropouts(i).actions(a));
        END LOOP;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('------ Dropout Count by District ------');
    DBMS_OUTPUT.PUT_LINE('KIG: ' || NVL(v_count_per_district('KIG'), 0));
    DBMS_OUTPUT.PUT_LINE('NOR: ' || NVL(v_count_per_district('NOR'), 0));
END;
/
