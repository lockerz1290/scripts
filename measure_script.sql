DECLARE
  -- Zmienne do pomiaru czasu
  v_start_time TIMESTAMP;
  v_end_time TIMESTAMP;
  v_time_query1 INTERVAL DAY TO SECOND;
  v_time_query2 INTERVAL DAY TO SECOND;
  
  -- Licznik pętli
  v_iterations NUMBER := 10; -- Liczba iteracji do wykonania
  
  -- Statystyki
  v_total_time_query1 INTERVAL DAY TO SECOND := INTERVAL '0' SECOND;
  v_total_time_query2 INTERVAL DAY TO SECOND := INTERVAL '0' SECOND;
  v_avg_time_query1 INTERVAL DAY TO SECOND;
  v_avg_time_query2 INTERVAL DAY TO SECOND;
  
  -- Wyniki (jeśli zapytania zwracają dane)
  v_result1 NUMBER;
  v_result2 NUMBER;
BEGIN
  -- Nagłówek wyników
  DBMS_OUTPUT.PUT_LINE('Iteracja | Zapytanie 1 Czas | Zapytanie 2 Czas | Różnica');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  
  -- Pętla testująca
  FOR i IN 1..v_iterations LOOP
    -- Wykonaj i zmierz pierwsze zapytanie
    v_start_time := SYSTIMESTAMP;
    
    -- TU WPISZ PIERWSZE ZAPYTANIE (np. SELECT COUNT(*) INTO v_result1 FROM tabela1 WHERE warunek)
    -- Przykład:
    SELECT COUNT(*) INTO v_result1 FROM employees WHERE department_id = 10;
    
    v_end_time := SYSTIMESTAMP;
    v_time_query1 := v_end_time - v_start_time;
    v_total_time_query1 := v_total_time_query1 + v_time_query1;
    
    -- Wykonaj i zmierz drugie zapytanie
    v_start_time := SYSTIMESTAMP;
    
    -- TU WPISZ DRUGIE ZAPYTANIE (np. SELECT COUNT(*) INTO v_result2 FROM tabela2 WHERE warunek)
    -- Przykład:
    SELECT COUNT(*) INTO v_result2 FROM employees WHERE department_id = 20;
    
    v_end_time := SYSTIMESTAMP;
    v_time_query2 := v_end_time - v_start_time;
    v_total_time_query2 := v_total_time_query2 + v_time_query2;
    
    -- Wyświetl wyniki dla tej iteracji
    DBMS_OUTPUT.PUT_LINE(
      LPAD(i, 8) || ' | ' ||
      TO_CHAR(v_time_query1, 'HH24:MI:SS.FF3') || ' | ' ||
      TO_CHAR(v_time_query2, 'HH24:MI:SS.FF3') || ' | ' ||
      TO_CHAR(v_time_query2 - v_time_query1, 'HH24:MI:SS.FF3')
    );
    
    -- Opcjonalne czyszczenie bufora (dla niektórych operacji)
    COMMIT;
  END LOOP;
  
  -- Oblicz średnie czasy
  v_avg_time_query1 := v_total_time_query1 / v_iterations;
  v_avg_time_query2 := v_total_time_query2 / v_iterations;
  
  -- Podsumowanie
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('ŚREDNIA:');
  DBMS_OUTPUT.PUT_LINE('Zapytanie 1: ' || TO_CHAR(v_avg_time_query1, 'HH24:MI:SS.FF3'));
  DBMS_OUTPUT.PUT_LINE('Zapytanie 2: ' || TO_CHAR(v_avg_time_query2, 'HH24:MI:SS.FF3'));
  DBMS_OUTPUT.PUT_LINE('Różnica: ' || TO_CHAR(v_avg_time_query2 - v_avg_time_query1, 'HH24:MI:SS.FF3'));
  
  -- Dodatkowe statystyki
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Zapytanie 1 było szybsze w ' || 
    CASE WHEN v_avg_time_query1 < v_avg_time_query2 THEN 'TAK' ELSE 'NIE' END || ' przypadkach');
  DBMS_OUTPUT.PUT_LINE('Procentowa różnica: ' || 
    ROUND(ABS((EXTRACT(SECOND FROM v_avg_time_query1) - EXTRACT(SECOND FROM v_avg_time_query2)) / 
    GREATEST(EXTRACT(SECOND FROM v_avg_time_query1), EXTRACT(SECOND FROM v_avg_time_query2)) * 100, 2) || '%');
END;
/