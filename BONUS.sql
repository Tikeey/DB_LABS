--Data_Base Schema
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    iin varchar(12) UNIQUE NOT NULL CHECK (LENGTH(iin) = 12 AND iin ~ '^\d{12}$'),
    full_name varchar(50) NOT NULL,
    phone varchar(12) NOT NULL,
    email varchar(70) NOT NULL,
    status varchar(20) NOT NULL CHECK (status IN('active', 'blocked', 'frozen')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    daily_limit_kzt numeric(12, 2) DEFAULT 10000000
);

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id int NOT NULL REFERENCES customers(customer_id),
    account_number varchar(20) UNIQUE NOT NULL CHECK (account_number ~ '^KZ\d{18}$'),
    currency varchar(3) NOT NULL CHECK (currency IN('KZT', 'USD', 'EUR', 'RUB')),
    balance numeric(12, 2) DEFAULT 0.00 CHECK (balance >= 0),
    is_active boolean DEFAULT TRUE,
    opened_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at timestamptz
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account_id int REFERENCES accounts(account_id),
    to_account_id int REFERENCES accounts(account_id),
    amount numeric(12, 2) NOT NULL CHECK (amount > 0),
    currency varchar(3) NOT NULL CHECK (currency IN('KZT', 'USD', 'EUR', 'RUB')),
    exchange_rate numeric(10, 6),
    amount_kzt numeric(12, 2),
    type varchar(20) NOT NULL CHECK (type IN('transfer', 'deposit', 'withdrawal')),
    status varchar(20) NOT NULL CHECK (status IN('pending', 'completed', 'failed', 'reversed')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamptz,
    description varchar(300)
);

CREATE TABLE exchange_rates (
    rate_id SERIAL PRIMARY KEY,
    from_currency varchar(3) NOT NULL CHECK (from_currency IN('KZT', 'USD', 'EUR', 'RUB')),
    to_currency varchar(3) NOT NULL CHECK (to_currency IN('KZT', 'USD', 'EUR', 'RUB')),
    rate numeric(10, 6) NOT NULL CHECK (rate > 0),
    valid_from timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to timestamptz
);

CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name varchar(50) NOT NULL,
    record_id int NOT NULL,
    action varchar(50) NOT NULL CHECK (action IN('INSERT', 'UPDATE', 'DELETE')),
    old_values jsonb,
    new_values jsonb,
    changed_by int NOT NULL,
    changed_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address inet NOT NULL --inet тип данных для хранения IP-адресов
);

--10 различных подходящих записей (все записи были сгенерированы ИИ для разных сценариев использования)

INSERT INTO customers (iin, full_name, phone, email, status, daily_limit_kzt) 
VALUES
    ('111111111111', 'John Doe', '770111111111', 'john.doe@example.com', 'active', 500000.00),
    ('222222222222', 'Alice Smith', '770222222222', 'alice.s@example.com', 'active', 1000000.00),
    ('333333333333', 'Bob Brown', '770333333333', 'bob.b@example.com', 'blocked', 0.00),
    ('444444444444', 'Company Corp', '770444444444', 'corp@bigbank.kz', 'active', 50000000.00),
    ('555555555555', 'Sarah Connor', '770555555555', 'sarah.c@example.com', 'active', 2000000.00),
    ('666666666666', 'Mike Wazowski', '770666666666', 'mike.w@example.com', 'frozen', 10000.00),
    ('777777777777', 'Jane Goodall', '770777777777', 'jane.g@example.com', 'active', 50000.00),
    ('888888888888', 'Peter Pan', '770888888888', 'peter.p@example.com', 'active', 100000.00),
    ('999999999999', 'Tony Stark', '770999999999', 'tony.s@example.com', 'active', 5000000.00),
    ('101010101010', 'Darth Vader', '771010101010', 'darth.v@example.com', 'active', 100000.00);

INSERT INTO accounts (customer_id, account_number, currency, balance, is_active) 
VALUES
    (1, 'KZ111111111111111111', 'KZT', 150000.00, TRUE),
    (1, 'KZ222222222222222222', 'USD', 1000.00, TRUE),
    (2, 'KZ333333333333333333', 'KZT', 5000000.00, TRUE),
    (3, 'KZ444444444444444444', 'KZT', 100.00, TRUE),
    (4, 'KZ555555555555555555', 'KZT', 50000000.00, TRUE),
    (5, 'KZ666666666666666666', 'EUR', 2500.00, TRUE),
    (7, 'KZ777777777777777777', 'RUB', 15000.00, TRUE),
    (8, 'KZ888888888888888888', 'USD', 500.00, FALSE),
    (9, 'KZ999999999999999999', 'KZT', 10000000.00, TRUE),
    (10, 'KZ000000000000000000', 'KZT', 500.00, TRUE);

INSERT INTO exchange_rates (from_currency, to_currency, rate, valid_from, valid_to) 
VALUES
    ('USD', 'KZT', 460.000, CURRENT_TIMESTAMP, '2999-01-01'),
    ('KZT', 'USD', 0.00217, CURRENT_TIMESTAMP, '2999-01-01'),
    ('EUR', 'KZT', 495.000, CURRENT_TIMESTAMP, '2999-01-01'),
    ('KZT', 'EUR', 0.00202, CURRENT_TIMESTAMP, '2999-01-01'),
    ('RUB', 'KZT', 5.000, CURRENT_TIMESTAMP, '2999-01-01'),
    ('KZT', 'RUB', 0.200, CURRENT_TIMESTAMP, '2999-01-01'),
    ('USD', 'KZT', 450.000, '2025-01-01 10:00:00Z', CURRENT_TIMESTAMP),
    ('KZT', 'KZT', 1.000, CURRENT_TIMESTAMP, '2999-01-01'),
    ('EUR', 'USD', 1.076, CURRENT_TIMESTAMP, '2999-01-01'),
    ('USD', 'RUB', 92.000, CURRENT_TIMESTAMP, '2999-01-01');

INSERT INTO transactions (from_account_id, to_account_id, amount, currency, exchange_rate, amount_kzt, type, status, completed_at, description) 
VALUES
    (1, 4, 50000.00, 'KZT', 1.000, 50000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Ежемесячный перевод другу'),
    (2, 1, 50.00, 'USD', 460.000, 23000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Конвертация USD на KZT'),
    (9, NULL, 10000.00, 'KZT', 1.000, 10000.00, 'withdrawal', 'completed', CURRENT_TIMESTAMP, 'Снятие наличных в банкомате'),
    (NULL, 1, 20000.00, 'KZT', 1.000, 20000.00, 'deposit', 'completed', CURRENT_TIMESTAMP, 'Пополнение через кассу'),
    (5, 4, 1000000.00, 'KZT', 1.000, 1000000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Крупный перевод партнеру'),
    (6, 3, 100.00, 'EUR', 495.000, 49500.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Перевод EUR с конвертацией'),
    (1, 7, 5000.00, 'KZT', 0.200, 5000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Перевод KZT с конвертацией в RUB'),
    (9, 10, 1000.00, 'KZT', 1.000, 1000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Пробный перевод'),
    (5, 9, 5000000.00, 'KZT', 1.000, 5000000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Перевод VIP клиенту'),
    (7, 1, 1000.00, 'RUB', 5.000, 5000.00, 'transfer', 'completed', CURRENT_TIMESTAMP, 'Перевод RUB с конвертацией в KZT');


--Tasks
--Task 1
CREATE PROCEDURE process_transfer(
    from_account_number varchar,
    to_account_number varchar,
    amount numeric(12, 2),
    currency varchar(3),
    description varchar(300),
    p_changed_by int DEFAULT 1,
    p_ip_address inet DEFAULT '127.0.0.1'
)
AS $$
DECLARE
    v_from_acc_rec RECORD;
    v_to_acc_rec RECORD;
    
    v_rate_transfer_to_sender numeric(10, 6);
    v_rate_transfer_to_kzt numeric(10, 6);
    v_rate_transfer_to_receiver numeric(10, 6);

    v_debit_amount numeric(12, 2);
    v_credit_amount numeric(12, 2);
    v_transfer_amount_kzt numeric(12, 2);
    v_total_transferred numeric(12, 2);     
    v_transaction_id int;

BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    -- 1. Предварительные проверки и блокировка (SELECT ... FOR UPDATE)

    SELECT a.account_id, a.currency, a.balance, c.customer_id, c.status, c.daily_limit_kzt
    INTO v_from_acc_rec
    FROM accounts a JOIN customers c ON a.customer_id = c.customer_id
    WHERE a.account_number = from_account_number AND a.is_active = TRUE
    FOR UPDATE; -- Блокировка строки
    IF NOT FOUND THEN RAISE EXCEPTION 'ACC_001: Source account not found or is inactive.'; END IF;

    SELECT a.account_id, a.currency
    INTO v_to_acc_rec
    FROM accounts a
    WHERE a.account_number = to_account_number AND a.is_active = TRUE
    FOR UPDATE; -- Блокировка строки
    IF NOT FOUND THEN RAISE EXCEPTION 'ACC_002: Destination account not found or is inactive.'; END IF;
    
    IF v_from_acc_rec.status <> 'active' THEN RAISE EXCEPTION 'CUST_001: Sender customer status is %.', v_from_acc_rec.status; END IF;

    -- 2. РАСЧЕТ СУММ И ПРОВЕРКИ
    
    -- 2.1. Расчет KZT для лимита
    v_transfer_amount_kzt := amount;
    IF currency <> 'KZT' THEN
        SELECT rate INTO v_rate_transfer_to_kzt
        FROM exchange_rates
        WHERE from_currency = currency AND to_currency = 'KZT' AND valid_from <= CURRENT_TIMESTAMP
        ORDER BY valid_from DESC LIMIT 1;
        
        IF NOT FOUND THEN RAISE EXCEPTION 'RATE_002: Exchange rate to KZT (for limit check) not found.'; END IF;
        v_transfer_amount_kzt := amount * v_rate_transfer_to_kzt;
    END IF;

    -- 2.2. Проверка дневного лимита (в KZT)
    SELECT COALESCE(SUM(amount_kzt), 0.00) INTO v_total_transferred
    FROM transactions
    WHERE from_account_id = v_from_acc_rec.account_id AND status = 'completed' AND type = 'transfer' AND created_at::DATE = CURRENT_DATE;

    IF (v_total_transferred + v_transfer_amount_kzt) > v_from_acc_rec.daily_limit_kzt THEN
        RAISE EXCEPTION 'LIMIT_001: Daily transfer limit exceeded.';
    END IF;
    
    -- 2.3. Расчет суммы списания (v_debit_amount)
    v_rate_transfer_to_sender := 1.0;
    v_debit_amount := amount;
    IF currency <> v_from_acc_rec.currency THEN
        SELECT rate INTO v_rate_transfer_to_sender
        FROM exchange_rates
        WHERE from_currency = currency AND to_currency = v_from_acc_rec.currency AND valid_from <= CURRENT_TIMESTAMP
        ORDER BY valid_from DESC LIMIT 1;
        
        IF NOT FOUND THEN RAISE EXCEPTION 'RATE_001: Exchange rate for debit not found.'; END IF;
        v_debit_amount := amount * v_rate_transfer_to_sender;
    END IF;

    -- 2.4. Проверка баланса
    IF v_from_acc_rec.balance < v_debit_amount THEN RAISE EXCEPTION 'BAL_001: Insufficient balance.'; END IF;
    
    -- 2.5. Расчет суммы зачисления (v_credit_amount)
    v_rate_transfer_to_receiver := 1.0;
    v_credit_amount := amount;
    IF currency <> v_to_acc_rec.currency THEN
        SELECT rate INTO v_rate_transfer_to_receiver
        FROM exchange_rates
        WHERE from_currency = currency AND to_currency = v_to_acc_rec.currency AND valid_from <= CURRENT_TIMESTAMP
        ORDER BY valid_from DESC LIMIT 1;
          
        IF NOT FOUND THEN RAISE EXCEPTION 'RATE_003: Exchange rate for credit not found.'; END IF;
        v_credit_amount := amount * v_rate_transfer_to_receiver;
    END IF;
    
    -- 3. Исполнение и Логирование (Без SAVEPOINT)

    -- 3.1. Создание записи транзакции со статусом 'completed'
    INSERT INTO transactions (from_account_id, to_account_id, amount, currency, exchange_rate, amount_kzt, type, status, description, completed_at)
    VALUES (v_from_acc_rec.account_id, v_to_acc_rec.account_id, amount, currency, 
            COALESCE(v_rate_transfer_to_sender, 1.0), v_transfer_amount_kzt, 'transfer', 'completed', description, CURRENT_TIMESTAMP)
    RETURNING transaction_id INTO v_transaction_id;

    -- 3.2. Обновление балансов (Любая ошибка здесь приведет к полному ROLLBACK)
    UPDATE accounts SET balance = balance - v_debit_amount WHERE account_id = v_from_acc_rec.account_id;
    UPDATE accounts SET balance = balance + v_credit_amount WHERE account_id = v_to_acc_rec.account_id;

    -- 3.3. Логирование аудита (Успех)
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by, ip_address)
    VALUES ('transactions', v_transaction_id, 'INSERT', jsonb_build_object('status', 'completed', 'debit_amount', v_debit_amount), p_changed_by, p_ip_address);

    -- 3.4. Завершаем всю транзакцию
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- 4. Логирование неудачной попытки
        
        -- Логируем ошибку в audit_logs
        INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by, ip_address)
        VALUES ('process_transfer_failed', COALESCE(v_transaction_id, 0), 'FAILED', jsonb_build_object('error_step', 'Full Rollback', 'error', SQLERRM), p_changed_by, p_ip_address);
        
        -- Полный откат всех изменений
        ROLLBACK; 
        
        -- Повторный RAISE для информирования вызывающего кода
        RAISE; 
END;
$$ LANGUAGE plpgsql;


--Task 2
-- View 1
CREATE VIEW customer_balance_summary AS
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(a.account_id) AS total_accounts,
-- Агрегация: Суммирование всех балансов клиента, конвертированных в KZT. 
    SUM(a.balance * COALESCE(er.rate, 1)) AS total_balance_kzt,
    c.daily_limit_kzt,
    COALESCE(
        (
            SELECT SUM(t.amount_kzt)
            FROM accounts sub_a
            JOIN transactions t ON sub_a.account_id = t.from_account_id
            WHERE sub_a.customer_id = c.customer_id
              AND t.created_at::DATE = CURRENT_DATE 
              AND t.type = 'transfer'
              AND t.status = 'completed'
        ), 0
    ) AS daily_limit_used_kzt,
    (
-- Подзапрос: Расчет использованного лимита за сегодня в процентах.
        COALESCE(
            (
                SELECT SUM(t.amount_kzt)
                FROM accounts sub_a
                JOIN transactions t ON sub_a.account_id = t.from_account_id
                WHERE sub_a.customer_id = c.customer_id
                  AND t.created_at::DATE = CURRENT_DATE 
                  AND t.type = 'transfer'
                  AND t.status = 'completed'
            ), 0
        ) * 100.0 / NULLIF(c.daily_limit_kzt, 0)
    ) AS daily_utilization_percent,
-- Оконная функция: Ранжирование клиентов по общему балансу в KZT (Rich Rank).
    RANK() OVER (ORDER BY SUM(a.balance * COALESCE(er.rate, 1)) DESC) AS rich_rank
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN exchange_rates er 
    ON er.from_currency = a.currency 
    AND er.to_currency = 'KZT' 
    AND er.valid_from <= CURRENT_TIMESTAMP
    AND (er.valid_to IS NULL OR er.valid_to >= CURRENT_TIMESTAMP)
WHERE a.is_active = TRUE
GROUP BY c.customer_id, c.full_name, c.daily_limit_kzt;

-- View 2
CREATE VIEW daily_transaction_report AS
WITH DailyVolume AS (
    SELECT 
        created_at::DATE AS trans_date,
        type,
        COUNT(*) AS trans_count,
        SUM(amount_kzt) AS total_volume,
        AVG(amount_kzt) AS avg_amount
    FROM transactions
    WHERE status = 'completed'
    GROUP BY 1, 2
)
SELECT 
    trans_date,
    type,
    trans_count,
    total_volume,
    avg_amount,
-- Оконная функция: Накопительный итог (Running Total) объема транзакций по типу.
    SUM(total_volume) OVER (PARTITION BY type ORDER BY trans_date) AS running_total,
-- Оконная функция: Расчет роста/падения объема по сравнению с предыдущим днем (Day-over-Day Growth)
    (total_volume - LAG(total_volume, 1, 0) OVER (PARTITION BY type ORDER BY trans_date)) * 100.0 / NULLIF(LAG(total_volume, 1, 0) OVER (PARTITION BY type ORDER BY trans_date), 0) AS dod_growth_percent
FROM DailyVolume
ORDER BY trans_date, type;

-- View 3
CREATE VIEW suspicious_activity_view WITH (security_barrier = true) AS
WITH transaction_flags AS (
    SELECT 
        t.transaction_id,
        t.from_account_id,
        t.amount_kzt,
        t.created_at,
-- Оконная функция LAG: Расчет интервала времени с момента предыдущей транзакции клиента.
        (t.created_at - LAG(t.created_at, 1) OVER (PARTITION BY t.from_account_id ORDER BY t.created_at)) AS time_since_last_trans,
-- Оконная функция COUNT: Подсчет количества транзакций клиента за текущий час.
        COUNT(t.transaction_id) OVER (PARTITION BY t.from_account_id, DATE_TRUNC('hour', t.created_at)) AS hourly_trans_count
    FROM transactions t
    WHERE t.status = 'completed' AND t.type = 'transfer'
)
SELECT 
    transaction_id,
    from_account_id,
    created_at,
    CASE WHEN amount_kzt > 5000000 THEN 'High Value (>5M KZT)' ELSE NULL END AS high_value_flag,
    CASE WHEN hourly_trans_count > 10 THEN 'Excessive Hourly Transactions (>10)' ELSE NULL END AS excessive_transactions_flag,
    CASE WHEN time_since_last_trans < INTERVAL '1 minute' THEN 'Rapid Sequential Transfer' ELSE NULL END AS rapid_transfer_flag
FROM transaction_flags
WHERE amount_kzt > 5000000
   OR hourly_trans_count > 10
   OR time_since_last_trans < INTERVAL '1 minute';


--Task 3
-- 1. B-tree Index: Стандартный, для поиска и сортировки по балансу.
CREATE INDEX idx_accounts_balance ON accounts (balance);

-- 2. Hash Index: Для поиска по валюте (быстрый точный поиск).
CREATE INDEX idx_accounts_currency ON accounts USING hash (currency);

-- 3. GIN Index: JSONB-индекс. Обязательно для JSONB, иначе поиск по new_values будет очень медленным.
CREATE INDEX idx_audit_log_new_values ON audit_logs USING GIN (new_values);

-- 4. Partial Index: "Частичный" индекс. Индексируем только АКТИВНЫЕ счета. Индекс меньше = поиск быстрее.
CREATE INDEX idx_active_accounts ON accounts (account_number) WHERE is_active = TRUE;

-- 5. Composite Index: "Составной" индекс. Для запросов, которые часто ищут по from_account_id И status.
CREATE INDEX idx_transactions_customer_status ON transactions (from_account_id, status);

-- 6. Expression Index: Индекс на выражении. Ускоряет поиск по email без учета регистра (LOWER(email)). 
CREATE INDEX idx_customers_email_lower ON customers (LOWER(email));

/* 7. Covering Index (B-tree с INCLUDE):
Ускоряет проверку дневного лимита. База может прочитать сумму лимита прямо из индекса
(Index Only Scan) без обращения к основной таблице transactions.
*/
CREATE INDEX idx_trans_limit_check ON transactions (from_account_id, created_at) INCLUDE (amount_kzt);


--Task 4
CREATE OR REPLACE PROCEDURE process_salary_batch(
    company_account_number VARCHAR,
    payments_json JSONB,
    p_changed_by INT DEFAULT 1,
    p_ip_address INET DEFAULT '127.0.0.1'
)
AS $$
DECLARE
-- Данные компании
    v_company_rec RECORD;
    v_total_batch_amount NUMERIC(12, 2) := 0.00;
    
-- Итератор и данные платежа
    v_payment_detail JSONB;
    v_target_iin VARCHAR(12);
    v_amount NUMERIC(12, 2);
    v_description VARCHAR(300);
    
-- Статистика для возврата
    v_successful_count INT := 0;
    v_failed_count INT := 0;
    v_failed_details JSONB := '[]'::JSONB;

-- Вспомогательные переменные
    v_target_account_id INT;
    v_target_currency VARCHAR(3);
    v_debit_amount_transfer NUMERIC(12, 2);
    v_credit_amount_transfer NUMERIC(12, 2);
    v_rate NUMERIC(10, 6);
    v_transaction_id INT;
    v_error_message VARCHAR(300);
    
-- Используем JSONB для атомарного обновления
    v_balance_updates JSONB := '{}'::JSONB; 
    
-- Уникальный идентификатор блокировки
    v_lock_id BIGINT;

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    v_lock_id := ('x' || SUBSTR(MD5(company_account_number), 1, 15))::BIT(64)::BIGINT;

-- 1.1. Консультативная блокировка
    IF NOT pg_try_advisory_lock(v_lock_id) THEN
        RAISE EXCEPTION 'BATCH_001: Concurrent batch processing detected. Lock is held by another process.';
    END IF;
    
-- 1.2. Получение данных счета компании и блокировка
    SELECT a.account_id, a.currency, a.balance, c.customer_id
    INTO v_company_rec
    FROM accounts a JOIN customers c ON a.customer_id = c.customer_id
    WHERE a.account_number = company_account_number AND a.is_active = TRUE
    FOR UPDATE;
    
    IF NOT FOUND THEN
        PERFORM pg_advisory_unlock(v_lock_id);
        RAISE EXCEPTION 'ACC_001: Company account not found or is inactive.';
    END IF;
    
-- 1.3. Расчет общей суммы пакета
    SELECT COALESCE(SUM((elem->>'amount')::NUMERIC), 0.00)
    INTO v_total_batch_amount
    FROM jsonb_array_elements(payments_json) AS elem;
    
-- 1.4. Проверка общего баланса компании
    IF v_company_rec.balance < v_total_batch_amount THEN
-- Снятие блокировки перед RAISE
        PERFORM pg_advisory_unlock(v_lock_id);
        RAISE EXCEPTION 'BAL_001: Insufficient balance in company account (Required: %).', v_total_batch_amount;
    END IF;
    
-- Инициализация JSONB для атомарного обновления
-- Устанавливаем начальное изменение для счета компании (ДЕБЕТ)
    v_balance_updates := jsonb_set(v_balance_updates, ARRAY[v_company_rec.account_id::TEXT], (-v_total_batch_amount)::JSONB, TRUE);
    
--2. Пакетная обработка платежей (Итерация с SAVEPOINT)
    FOR v_payment_detail IN SELECT * FROM jsonb_array_elements(payments_json)
    LOOP
        v_target_iin := v_payment_detail->>'iin';
        v_amount := (v_payment_detail->>'amount')::NUMERIC;
        v_description := COALESCE(v_payment_detail->>'description', 'Salary payment');
        v_error_message := NULL;
        v_transaction_id := NULL;
        
-- Используем уникальное имя для SAVEPOINT
        EXECUTE 'SAVEPOINT payment_sp_' || v_successful_count + v_failed_count;

        BEGIN
-- 2.1. Поиск целевого счета и блокировка
            SELECT a.account_id, a.currency
            INTO v_target_account_id, v_target_currency
            FROM accounts a JOIN customers c ON a.customer_id = c.customer_id
            WHERE c.iin = v_target_iin AND a.is_active = TRUE
            FOR UPDATE NOWAIT; 
            
            IF NOT FOUND THEN
                v_error_message := 'ACC_002: Employee account not found or inactive for IIN: ' || v_target_iin;
                RAISE EXCEPTION '%', v_error_message;
            END IF;

-- 2.2. Расчет суммы зачисления и курса
            v_debit_amount_transfer := v_amount;
            v_credit_amount_transfer := v_amount;
            v_rate := 1.0;

            IF v_company_rec.currency <> v_target_currency THEN
                SELECT rate INTO v_rate
                FROM exchange_rates
                WHERE from_currency = v_company_rec.currency AND to_currency = v_target_currency
                  AND valid_from <= CURRENT_TIMESTAMP AND (valid_to IS NULL OR valid_to > CURRENT_TIMESTAMP)
                ORDER BY valid_from DESC LIMIT 1;
                
                IF NOT FOUND THEN
                    v_error_message := 'RATE_001: Exchange rate (' || v_company_rec.currency || ' -> ' || v_target_currency || ') not found.';
                    RAISE EXCEPTION '%', v_error_message;
                END IF;
                v_credit_amount_transfer := v_amount * v_rate;
            END IF;
            
-- 2.3. Вставка записи в transactions (статус 'pending')
            INSERT INTO transactions (from_account_id, to_account_id, amount, currency, exchange_rate, amount_kzt, type, status, description, completed_at)
            VALUES (v_company_rec.account_id, v_target_account_id, v_amount, v_company_rec.currency, 
                    v_rate, v_amount * (SELECT rate FROM exchange_rates WHERE from_currency = v_company_rec.currency AND to_currency = 'KZT' ORDER BY valid_from DESC LIMIT 1),
                    'transfer', 'pending', v_description, NULL)
            RETURNING transaction_id INTO v_transaction_id;
            
-- 2.4. Накопление изменений для атомарного обновления (КРЕДИТ)
            v_balance_updates := jsonb_set(v_balance_updates, ARRAY[v_target_account_id::TEXT], v_credit_amount_transfer::JSONB, TRUE);

            v_successful_count := v_successful_count + 1;
            
-- Освобождение SAVEPOINT (если операция прошла успешно)
            EXECUTE 'RELEASE SAVEPOINT payment_sp_' || v_successful_count + v_failed_count - 1;

        EXCEPTION
            WHEN OTHERS THEN
-- 2.5. Обработка сбоя (Частичный откат и логирование)
                
-- Откат до SAVEPOINT
                EXECUTE 'ROLLBACK TO payment_sp_' || v_successful_count + v_failed_count;
                
                v_error_message := COALESCE(v_error_message, SQLERRM);
                
-- Логирование ошибки в audit_logs
                INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by, ip_address)
                VALUES ('salary_batch_failed', COALESCE(v_transaction_id, 0), 'FAILED', 
                        jsonb_build_object('iin', v_target_iin, 'amount', v_amount, 'error', v_error_message), 
                        p_changed_by, p_ip_address);

-- Добавление в статистику ошибок
                v_failed_details := jsonb_insert(v_failed_details, '{' || v_failed_count || '}', 
                                                jsonb_build_object('iin', v_target_iin, 'amount', v_amount, 'error', v_error_message), TRUE);
                v_failed_count := v_failed_count + 1;
                
-- Если транзакция была вставлена, обновить ее статус на 'failed'
                IF v_transaction_id IS NOT NULL THEN
                    UPDATE transactions SET status = 'failed', completed_at = CURRENT_TIMESTAMP WHERE transaction_id = v_transaction_id;
                END IF;
        END;
    END LOOP;

    IF v_successful_count > 0 THEN
-- 3.1. Атомарное обновление балансов через UNNEST JSONB
        UPDATE accounts AS a
        SET balance = balance + (updates.value::TEXT::NUMERIC)
        FROM jsonb_each_text(v_balance_updates) AS updates(key, value)
        WHERE a.account_id = updates.key::INT;
        
-- 3.2. Обновление статусов успешно завершенных транзакций
        UPDATE transactions
        SET status = 'completed', completed_at = CURRENT_TIMESTAMP
        WHERE from_account_id = v_company_rec.account_id
          AND status = 'pending';
    END IF;

-- 3.3. Снятие консультативной блокировки
    PERFORM pg_advisory_unlock(v_lock_id);

-- 3.4. Завершение всей транзакции
    COMMIT;
    
    RAISE NOTICE 'Batch processed: Successful: %, Failed: %', v_successful_count, v_failed_count;
    RAISE NOTICE 'Failed details: %', v_failed_details;

EXCEPTION
    WHEN OTHERS THEN
-- 4.1. Снятие блокировки (обязательно при любом сбое!)
        PERFORM pg_advisory_unlock(v_lock_id);
        
-- 4.2. Полный откат всех изменений
        ROLLBACK; 
        
-- 4.3. Повторный RAISE для информирования вызывающего кода
        RAISE EXCEPTION 'BATCH_003: Critical batch failure during pre-check or final COMMIT: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

--Test Cases:
/*
For Task 1:
1.1 CALL process_transfer('KZ111111111111111111', 'KZ333333333333333333', 10000.00, 'KZT', 'Standard KZT Transfer', 1, '127.0.0.1');
Цель Теста Успешная Транзакция, Результат: Полное завершение
1.2 CALL process_transfer('KZ222222222222222222', 'KZ111111111111111111', 100.00, 'USD', 'USD to KZT transfer', 1, '127.0.0.1');
Цель Теста Успешная Транзакция, Результат: Успех.
1.3 Баланс KZ111...: 140,000 KZT. CALL process_transfer('KZ111111111111111111', 'KZ333333333333333333', 500000.00, 'KZT', 'Insufficient balance test', 1, '127.0.0.1');
Цель Теста Недостаточно Средств, Результат: Откат (ROLLBACK).
1.4 Предварительно вставить транзакции на 480 000 KZT для KZ111... (Лимит: 500 000 KZT). CALL process_transfer('KZ111111111111111111', 'KZ333333333333333333', 30000.00, 'KZT', 'Daily limit exceed', 1, '127.0.0.1');
Цель Теста Превышение Лимита, Результат: Откат (ROLLBACK).
1.5 Требует двух отдельных psql сессий. Сессия 1: BEGIN;
SELECT * FROM accounts WHERE account_number = 'KZ111111111111111111' FOR UPDATE;
Сессия 2: CALL process_transfer('KZ111111111111111111', 'KZ333333333333333333', 10.00, 'KZT', 'Lock test', 1, '127.0.0.1');
Цель Теста Блокировка, Результат: Сессия 2 ждет, пока Сессия 1 не выполнит COMMIT/ROLLBACK.
*/

--Explain Analyze
/*
1) EXPLAIN ANALYZE SELECT COALESCE(SUM(amount_kzt), 0.00) FROM transactions WHERE from_account_id = 1 AND status = 'completed' AND type = 'transfer' AND created_at::DATE = CURRENT_DATE;
 Aggregate  (cost=1.25..1.26 rows=1 width=32) (actual time=0.017..0.020 rows=1 loops=1)
   ->  Seq Scan on transactions  (cost=0.00..1.25 rows=1 width=16) (actual time=0.007..0.010 rows=2 loops=1)
         Filter: ((from_account_id = 1) AND ((status)::text = 'completed'::text) AND ((type)::text = 'transfer'::text) AND ((created_at)::date = CURRENT_DATE))
         Rows Removed by Filter: 8
 Planning Time: 0.215 ms
 Execution Time: 0.064 ms
(6 rows)
2) EXPLAIN ANALYZE SELECT * FROM audit_logs WHERE new_values @> '{"error_step": "Full Rollback"}' LIMIT 1;
 Limit  (cost=0.00..6.31 rows=1 width=352) (actual time=0.006..0.009 rows=0 loops=1)
   ->  Seq Scan on audit_logs  (cost=0.00..12.62 rows=2 width=352) (actual time=0.003..0.004 rows=0 loops=1)
         Filter: (new_values @> '{"error_step": "Full Rollback"}'::jsonb)
 Planning Time: 0.188 ms
 Execution Time: 0.026 ms
(5 rows)
3) EXPLAIN ANALYZE SELECT account_id FROM accounts WHERE account_number = 'KZ111111111111111111' AND is_active = TRUE;
 Seq Scan on accounts  (cost=0.00..1.12 rows=1 width=4) (actual time=0.006..0.008 rows=1 loops=1)
   Filter: (is_active AND ((account_number)::text = 'KZ111111111111111111'::text))
   Rows Removed by Filter: 9
 Planning Time: 0.173 ms
 Execution Time: 0.020 ms
(5 rows)
4) EXPLAIN ANALYZE SELECT customer_id FROM customers WHERE LOWER(email) = 'john.doe@example.com';
 Seq Scan on customers  (cost=0.00..1.15 rows=1 width=4) (actual time=0.012..0.020 rows=1 loops=1)
   Filter: (lower((email)::text) = 'john.doe@example.com'::text)
   Rows Removed by Filter: 9
 Planning Time: 0.176 ms
 Execution Time: 0.039 ms
(5 rows)
5)EXPLAIN ANALYZE SELECT transaction_id FROM transactions WHERE from_account_id = 1 AND status = 'completed';
Seq Scan on transactions  (cost=0.00..1.15 rows=1 width=4) (actual time=0.009..0.014 rows=2 loops=1)
   Filter: ((from_account_id = 1) AND ((status)::text = 'completed'::text))
   Rows Removed by Filter: 8
 Planning Time: 0.216 ms
 Execution Time: 0.033 ms
(5 rows)
*/


--BRIEF DOCUMENTATION
/*
Задача 1:
Ключевая логика: Обеспечение полной надежности (ACID) и предотвращение гонки данных (Race Conditions).
Надежность: Установлен максимальный уровень изоляции (SERIALIZABLE).
Блокировка: Используется SELECT ... FOR UPDATE, чтобы мгновенно заблокировать счета отправителя и получателя. Никто не может изменить их баланс, пока перевод не завершится.
Атомарность: Все изменения (списание, зачисление, вставка транзакции) выполняются в одном блоке. Если что-то не так (например, не хватило баланса), происходит полный ROLLBACK (откат).

Задача 2:
Ключевая логика: Использование продвинутых оконных функций для получения аналитики, которую нельзя получить простым GROUP BY.
Рейтинги и динамика: Применяются функции:
RANK() для ранжирования клиентов по общему богатству.
SUM() OVER для расчета накопительного итога объема транзакций.
LAG() для сравнения текущих данных с предыдущим днем (рост/падение) и для обнаружения слишком быстрых (подозрительных) последовательных переводов.

Задача 3:
Ключевая логика: Выбор разных типов индексов для максимального ускорения часто используемых запросов.
Covering Index (с INCLUDE): Самый важный, чтобы ускорить проверку дневного лимита из Задачи 1. Позволяет СУБД прочитать сумму лимита прямо из индекса.
GIN Index: Обязателен для быстрого поиска по ключам и значениям внутри неструктурированных данных JSONB в логах аудита.
Partial Index: Индексирует только активные счета. Это уменьшает размер индекса и делает поиск по ним быстрее.

Задача 4:
Ключевая логика: Высокая производительность и устойчивость к сбоям при массовой обработке.
Конкурентность: Используется консультативная блокировка (Advisory Lock), чтобы убедиться, что только один процесс одновременно обрабатывает зарплату для одной и той же компании.
Устойчивость: Применен SAVEPOINT на каждый платеж. Если один платеж сбойнет, он откатывается до точки сохранения, а остальная часть пакета продолжает работу.
Производительность: Все изменения балансов накапливаются в структуре JSONB. В конце выполняется всего один запрос UPDATE, чтобы атомарно изменить балансы компании и всех успешных сотрудников, что в разы быстрее, чем обновлять по одному.
*/