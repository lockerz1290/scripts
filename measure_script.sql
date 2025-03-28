DECLARE
  -- Zmienne do pomiaru czasu
  v_start_time TIMESTAMP;
  v_end_time TIMESTAMP;
  v_time_query1 INTERVAL DAY TO SECOND;
  v_time_query2 INTERVAL DAY TO SECOND;
  
  -- Licznik pętli
  v_iterations NUMBER := 5; -- Liczba iteracji do wykonania
  
  -- Statystyki
  v_total_time_query1 INTERVAL DAY TO SECOND := INTERVAL '0' SECOND;
  v_total_time_query2 INTERVAL DAY TO SECOND := INTERVAL '0' SECOND;
  v_avg_time_query1 INTERVAL DAY TO SECOND;
  v_avg_time_query2 INTERVAL DAY TO SECOND;
  
  -- Kursor dla wyników pierwszego zapytania
  CURSOR c_query1 IS
    -- TU WPISZ PIERWSZE ZAPYTANIE (zwracające wszystkie kolumny)
    -- Przykład:
    SELECT * FROM employees WHERE department_id = 10;
    
  -- Kursor dla wyników drugiego zapytania
  CURSOR c_query2 IS
    -- TU WPISZ DRUGIE ZAPYTANIE (zwracające wszystkie kolumny)
    -- Przykład:
    SELECT * FROM employees WHERE department_id = 20;
    
  -- Rekordy do przechowywania wyników (dla przykładu)
  r_query1 c_query1%ROWTYPE;
  r_query2 c_query2%ROWTYPE;
  
  -- Liczniki rekordów
  v_count1 NUMBER := 0;
  v_count2 NUMBER := 0;
BEGIN
  -- Nagłówek wyników czasowych
  DBMS_OUTPUT.PUT_LINE('Iteracja | Zapytanie 1 Czas | Zapytanie 2 Czas | Różnica');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  
  -- Pętla testująca
  FOR i IN 1..v_iterations LOOP
    -- Wykonaj i zmierz pierwsze zapytanie
    v_start_time := SYSTIMESTAMP;
    
    -- Otwórz kursor i przetwarzaj wyniki
    OPEN c_query1;
    LOOP
      FETCH c_query1 INTO r_query1;
      EXIT WHEN c_query1%NOTFOUND;
      v_count1 := v_count1 + 1;
      -- Tutaj możesz przetwarzać dane (r_query1.zmienna)
    END LOOP;
    CLOSE c_query1;
    
    v_end_time := SYSTIMESTAMP;
    v_time_query1 := v_end_time - v_start_time;
    v_total_time_query1 := v_total_time_query1 + v_time_query1;
    
    -- Wykonaj i zmierz drugie zapytanie
    v_start_time := SYSTIMESTAMP;
    
    -- Otwórz kursor i przetwarzaj wyniki
    OPEN c_query2;
    LOOP
      FETCH c_query2 INTO r_query2;
      EXIT WHEN c_query2%NOTFOUND;
      v_count2 := v_count2 + 1;
      -- Tutaj możesz przetwarzać dane (r_query2.zmienna)
    END LOOP;
    CLOSE c_query2;
    
    v_end_time := SYSTIMESTAMP;
    v_time_query2 := v_end_time - v_start_time;
    v_total_time_query2 := v_total_time_query2 + v_time_query2;
    
    -- Wyświetl wyniki czasowe dla tej iteracji
    DBMS_OUTPUT.PUT_LINE(
      LPAD(i, 8) || ' | ' ||
      TO_CHAR(v_time_query1, 'HH24:MI:SS.FF3') || ' | ' ||
      TO_CHAR(v_time_query2, 'HH24:MI:SS.FF3') || ' | ' ||
      TO_CHAR(v_time_query2 - v_time_query1, 'HH24:MI:SS.FF3')
    );
  END LOOP;
  
  -- Oblicz średnie czasy
  v_avg_time_query1 := v_total_time_query1 / v_iterations;
  v_avg_time_query2 := v_total_time_query2 / v_iterations;
  
  -- Podsumowanie czasowe
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('ŚREDNIA:');
  DBMS_OUTPUT.PUT_LINE('Zapytanie 1: ' || TO_CHAR(v_avg_time_query1, 'HH24:MI:SS.FF3'));
  DBMS_OUTPUT.PUT_LINE('Zapytanie 2: ' || TO_CHAR(v_avg_time_query2, 'HH24:MI:SS.FF3'));
  DBMS_OUTPUT.PUT_LINE('Różnica: ' || TO_CHAR(v_avg_time_query2 - v_avg_time_query1, 'HH24:MI:SS.FF3'));
  
  -- Statystyki dotyczące liczby zwróconych rekordów
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('LICZBA ZWRÓCONYCH REKORDÓW:');
  DBMS_OUTPUT.PUT_LINE('Zapytanie 1: ' || v_count1/v_iterations || ' (średnio na iterację)');
  DBMS_OUTPUT.PUT_LINE('Zapytanie 2: ' || v_count2/v_iterations || ' (średnio na iterację)');
  
  -- Wyświetlenie przykładowych wyników (pierwszy rekord z ostatniej iteracji)
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('PRZYKŁADOWE WYNIKI (pierwszy rekord z ostatniej iteracji):');
END;
