-- Schema reconstructed from inspected public PostgreSQL catalog metadata, 2026-10-01.

-- For a NEW sandbox database. Does not contain rows, credentials, grants or policies.

-- Original sequence-backed bigint columns are retained. FK constraints follow all tables.

BEGIN;

CREATE SEQUENCE public.agent_audit_log_audit_id_seq AS bigint;

CREATE TABLE public.agent_audit_log (
    audit_id bigint DEFAULT nextval('agent_audit_log_audit_id_seq'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    workflow_name character varying(100),
    agent_name character varying(100),
    action character varying(100),
    input_data jsonb,
    output_data jsonb,
    status character varying(30),
    CONSTRAINT agent_audit_log_pkey PRIMARY KEY (audit_id)
);

ALTER SEQUENCE public.agent_audit_log_audit_id_seq OWNED BY public.agent_audit_log.audit_id;

ALTER TABLE public.agent_audit_log ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.customers_customer_id_seq AS bigint;

CREATE TABLE public.customers (
    customer_id bigint DEFAULT nextval('customers_customer_id_seq'::regclass) NOT NULL,
    customer_name character varying(100) NOT NULL,
    country character varying(50),
    segment character varying(30),
    signup_date date DEFAULT CURRENT_DATE,
    CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.data_quality_results_result_id_seq AS bigint;

CREATE TABLE public.data_quality_results (
    result_id bigint DEFAULT nextval('data_quality_results_result_id_seq'::regclass) NOT NULL,
    checked_at timestamp with time zone DEFAULT now(),
    check_name character varying(100),
    observed_value numeric,
    baseline_value numeric,
    severity character varying(20),
    status character varying(20),
    details jsonb,
    CONSTRAINT data_quality_results_pkey PRIMARY KEY (result_id)
);

ALTER SEQUENCE public.data_quality_results_result_id_seq OWNED BY public.data_quality_results.result_id;

ALTER TABLE public.data_quality_results ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.dataops_orchestrator_runs (
    namespace text NOT NULL,
    run_id bigint NOT NULL,
    incident_date date NOT NULL,
    execution_id text NOT NULL,
    status text NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    result jsonb,
    CONSTRAINT dataops_orchestrator_runs_namespace_check CHECK ((namespace = ANY (ARRAY['PRODUCTION'::text, 'DRY_RUN'::text, 'TEST'::text]))),
    CONSTRAINT dataops_orchestrator_runs_namespace_incident_date_key UNIQUE (namespace, incident_date),
    CONSTRAINT dataops_orchestrator_runs_pkey PRIMARY KEY (namespace, run_id),
    CONSTRAINT dataops_orchestrator_runs_status_check CHECK ((status = ANY (ARRAY['RUNNING'::text, 'HEALTHY'::text, 'DRY_RUN_COMPLETED'::text, 'REMEDIATION_APPROVED'::text, 'REMEDIATION_REJECTED'::text, 'FAILED'::text])))
);

ALTER TABLE public.dataops_orchestrator_runs ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.incidents_incident_id_seq AS bigint;

CREATE TABLE public.incidents (
    incident_id bigint DEFAULT nextval('incidents_incident_id_seq'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    incident_title text,
    source character varying(50),
    severity character varying(20),
    status character varying(20) DEFAULT 'OPEN'::character varying,
    description text,
    probable_cause text,
    confidence numeric(5,2),
    recommended_action text,
    requires_approval boolean DEFAULT false,
    approved boolean,
    resolution_notes text,
    CONSTRAINT incidents_pkey PRIMARY KEY (incident_id)
);

ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;

ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.orders_order_id_seq AS bigint;

CREATE TABLE public.orders (
    order_id bigint DEFAULT nextval('orders_order_id_seq'::regclass) NOT NULL,
    external_order_id character varying(50),
    order_ts timestamp with time zone DEFAULT now(),
    customer_id bigint,
    product_id bigint,
    quantity integer,
    unit_price numeric(12,2),
    discount_pct numeric(5,2) DEFAULT 0,
    status character varying(30),
    source character varying(50),
    is_quarantined boolean DEFAULT false,
    CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.pipeline_runs_run_id_seq AS bigint;

CREATE TABLE public.pipeline_runs (
    run_id bigint DEFAULT nextval('pipeline_runs_run_id_seq'::regclass) NOT NULL,
    pipeline_name character varying(100),
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    status character varying(20),
    rows_processed integer,
    error_message text,
    CONSTRAINT pipeline_runs_pkey PRIMARY KEY (run_id)
);

ALTER SEQUENCE public.pipeline_runs_run_id_seq OWNED BY public.pipeline_runs.run_id;

ALTER TABLE public.pipeline_runs ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.products_product_id_seq AS bigint;

CREATE TABLE public.products (
    product_id bigint DEFAULT nextval('products_product_id_seq'::regclass) NOT NULL,
    product_name character varying(100) NOT NULL,
    category character varying(50),
    unit_price numeric(12,2) NOT NULL,
    CONSTRAINT products_pkey PRIMARY KEY (product_id)
);

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE SEQUENCE public.runbooks_runbook_id_seq AS bigint;

CREATE TABLE public.runbooks (
    runbook_id bigint DEFAULT nextval('runbooks_runbook_id_seq'::regclass) NOT NULL,
    title character varying(200),
    category character varying(100),
    content text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT runbooks_pkey PRIMARY KEY (runbook_id)
);

ALTER SEQUENCE public.runbooks_runbook_id_seq OWNED BY public.runbooks.runbook_id;

ALTER TABLE public.runbooks ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.dataops_orchestrator_runs ADD CONSTRAINT dataops_orchestrator_runs_run_id_fkey FOREIGN KEY (run_id) REFERENCES pipeline_runs(run_id);

ALTER TABLE public.orders ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE public.orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(product_id);

COMMIT;

