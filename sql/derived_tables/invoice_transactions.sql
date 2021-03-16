DROP TABLE IF EXISTS folio_reporting.invoice_transactions;

-- Create a derived table that joins invoice and invoice_lines fields to transactions for expenditure reports in system currency
--
-- Tables included:
--   finance_transactions
--	 finance_budgets
--	 finance_funds
--   invoice_invoices
--   invoice_lines
CREATE TABLE folio_reporting.invoice_transactions AS
SELECT
    ft.id AS transaction_id,
    ft.amount AS transaction_amount,
    ft.currency AS transaction_currency,
    json_extract_path_text(ft.data, 'expenseClassId') AS transaction_expense_class_id,
    ft.fiscal_year_id AS transaction_fiscal_year_id,
    ft.from_fund_id AS transaction_from_fund_id,
    ff.name AS transaction_from_fund_name,
    ff.code AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    fb.name AS transaction_from_budget_name,
    json_extract_path_text(ft.data, 'sourceInvoiceId') AS invoice_id,
    json_extract_path_text(ft.data, 'sourceInvoiceLineId') AS invoice_line_id,
    ft.transaction_type AS transaction_type,
    json_extract_path_text(ii.data, 'invoiceDate') AS invoice_date,
    json_extract_path_text(ii.data, 'paymentDate') AS invoice_payment_date,
    json_extract_path_text(ii.data, 'exchangeRate') AS invoice_exchange_rate,
    json_extract_path_text(il.data, 'total') AS invoice_line_total,
    json_extract_path_text(ii.data, 'currency') AS invoice_currency,
    json_extract_path_text(il.data, 'poLineId') AS po_line_id,
    json_extract_path_text(ii.data, 'vendorId') AS invoice_vendor_id,
    oo.name AS invoice_vendor_name
FROM
    finance_transactions AS ft
    LEFT JOIN invoice_invoices AS ii ON json_extract_path_text(ft.data, 'sourceInvoiceId') = ii.id
    LEFT JOIN invoice_lines AS il ON json_extract_path_text(ft.data, 'sourceInvoiceLineId') = il.id
    LEFT JOIN finance_funds AS ff ON ft.from_fund_id = ff.id
    LEFT JOIN finance_budgets AS fb ON ft.from_fund_id = fb.fund_id
    LEFT JOIN organization_organizations AS oo ON json_extract_path_text(ii.data, 'vendorId') = oo.id
WHERE
    transaction_type = 'Pending payment'
    OR transaction_type = 'Payment';

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_amount);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_currency);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_expense_class_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_fiscal_year_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_from_fund_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_from_fund_name);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_from_fund_code);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_from_budget_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_from_budget_name);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_id);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_line_id);

CREATE INDEX ON folio_reporting.invoice_transactions (transaction_type);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_date);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_payment_date);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_exchange_rate);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_line_total);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_currency);

CREATE INDEX ON folio_reporting.invoice_transactions (po_line_id);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_vendor_id);

CREATE INDEX ON folio_reporting.invoice_transactions (invoice_vendor_name);
