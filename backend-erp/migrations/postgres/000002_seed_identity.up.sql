-- =============================================================================
-- SEED: Roles, Permisos y Usuario Admin para VB-ERP
-- =============================================================================

-- ── PERMISOS ──────────────────────────────────────────────────────────────────
-- Convención: módulo:recurso:acción
INSERT INTO permissions (name, module, action, description) VALUES

  -- ── IDENTITY (Usuarios, Roles, Permisos) ──────────────────────────────────
  ('identity:users:read',        'identity', 'read',   'Ver lista y detalle de usuarios'),
  ('identity:users:create',      'identity', 'create', 'Crear nuevos usuarios'),
  ('identity:users:update',      'identity', 'update', 'Editar usuarios existentes'),
  ('identity:users:delete',      'identity', 'delete', 'Desactivar/eliminar usuarios'),
  ('identity:roles:read',        'identity', 'read',   'Ver roles y sus permisos'),
  ('identity:roles:manage',      'identity', 'manage', 'Crear, editar y eliminar roles'),
  ('identity:permissions:read',  'identity', 'read',   'Ver permisos del sistema'),

  -- ── INVENTORY (Inventario) ────────────────────────────────────────────────
  ('inventory:products:read',    'inventory', 'read',   'Ver productos y catálogo'),
  ('inventory:products:create',  'inventory', 'create', 'Crear nuevos productos'),
  ('inventory:products:update',  'inventory', 'update', 'Editar productos'),
  ('inventory:products:delete',  'inventory', 'delete', 'Eliminar productos'),
  ('inventory:stock:read',       'inventory', 'read',   'Ver niveles de stock'),
  ('inventory:stock:adjust',     'inventory', 'adjust', 'Ajustar stock manualmente'),
  ('inventory:stock:transfer',   'inventory', 'transfer','Transferir stock entre almacenes'),
  ('inventory:warehouses:read',  'inventory', 'read',   'Ver almacenes'),
  ('inventory:warehouses:manage','inventory', 'manage', 'Crear y editar almacenes'),
  ('inventory:categories:read',  'inventory', 'read',   'Ver categorías de productos'),
  ('inventory:categories:manage','inventory', 'manage', 'Gestionar categorías'),

  -- ── BILLING (Facturación y Ventas) ────────────────────────────────────────
  ('billing:invoices:read',      'billing', 'read',   'Ver facturas'),
  ('billing:invoices:create',    'billing', 'create', 'Crear facturas'),
  ('billing:invoices:update',    'billing', 'update', 'Editar facturas en borrador'),
  ('billing:invoices:delete',    'billing', 'delete', 'Anular facturas'),
  ('billing:invoices:approve',   'billing', 'approve','Aprobar y emitir facturas'),
  ('billing:payments:read',      'billing', 'read',   'Ver pagos recibidos'),
  ('billing:payments:register',  'billing', 'create', 'Registrar pagos'),
  ('billing:credit_notes:read',  'billing', 'read',   'Ver notas de crédito'),
  ('billing:credit_notes:create','billing', 'create', 'Emitir notas de crédito'),
  ('billing:quotes:read',        'billing', 'read',   'Ver cotizaciones'),
  ('billing:quotes:create',      'billing', 'create', 'Crear cotizaciones'),
  ('billing:quotes:approve',     'billing', 'approve','Aprobar cotizaciones'),

  -- ── PURCHASING (Compras) ──────────────────────────────────────────────────
  ('purchasing:orders:read',     'purchasing', 'read',   'Ver órdenes de compra'),
  ('purchasing:orders:create',   'purchasing', 'create', 'Crear órdenes de compra'),
  ('purchasing:orders:update',   'purchasing', 'update', 'Editar órdenes de compra'),
  ('purchasing:orders:approve',  'purchasing', 'approve','Aprobar órdenes de compra'),
  ('purchasing:orders:receive',  'purchasing', 'receive','Recibir mercancía de compras'),
  ('purchasing:suppliers:read',  'purchasing', 'read',   'Ver proveedores'),
  ('purchasing:suppliers:manage','purchasing', 'manage', 'Gestionar proveedores'),

  -- ── CRM (Clientes y Relaciones) ───────────────────────────────────────────
  ('crm:customers:read',         'crm', 'read',   'Ver clientes'),
  ('crm:customers:create',       'crm', 'create', 'Crear clientes'),
  ('crm:customers:update',       'crm', 'update', 'Editar clientes'),
  ('crm:customers:delete',       'crm', 'delete', 'Eliminar clientes'),
  ('crm:leads:read',             'crm', 'read',   'Ver leads/prospectos'),
  ('crm:leads:manage',           'crm', 'manage', 'Gestionar leads'),
  ('crm:contacts:read',          'crm', 'read',   'Ver contactos'),
  ('crm:contacts:manage',        'crm', 'manage', 'Gestionar contactos'),

  -- ── FINANCE (Finanzas y Contabilidad) ─────────────────────────────────────
  ('finance:accounts:read',      'finance', 'read',   'Ver cuentas contables'),
  ('finance:accounts:manage',    'finance', 'manage', 'Gestionar plan de cuentas'),
  ('finance:journal:read',       'finance', 'read',   'Ver asientos contables'),
  ('finance:journal:create',     'finance', 'create', 'Crear asientos contables'),
  ('finance:journal:approve',    'finance', 'approve','Aprobar asientos contables'),
  ('finance:reports:read',       'finance', 'read',   'Ver reportes financieros'),
  ('finance:reports:export',     'finance', 'export', 'Exportar reportes financieros'),
  ('finance:budgets:read',       'finance', 'read',   'Ver presupuestos'),
  ('finance:budgets:manage',     'finance', 'manage', 'Gestionar presupuestos'),

  -- ── HR (Recursos Humanos) ─────────────────────────────────────────────────
  ('hr:employees:read',          'hr', 'read',   'Ver empleados'),
  ('hr:employees:create',        'hr', 'create', 'Registrar empleados'),
  ('hr:employees:update',        'hr', 'update', 'Editar empleados'),
  ('hr:employees:delete',        'hr', 'delete', 'Dar de baja empleados'),
  ('hr:payroll:read',            'hr', 'read',   'Ver nómina'),
  ('hr:payroll:process',         'hr', 'process','Procesar nómina'),
  ('hr:attendance:read',         'hr', 'read',   'Ver asistencia'),
  ('hr:attendance:manage',       'hr', 'manage', 'Gestionar asistencia'),

  -- ── REPORTS (Reportes globales) ───────────────────────────────────────────
  ('reports:dashboard:read',     'reports', 'read',   'Ver dashboard principal'),
  ('reports:sales:read',         'reports', 'read',   'Ver reportes de ventas'),
  ('reports:inventory:read',     'reports', 'read',   'Ver reportes de inventario'),
  ('reports:finance:read',       'reports', 'read',   'Ver reportes financieros'),
  ('reports:hr:read',            'reports', 'read',   'Ver reportes de RRHH'),
  ('reports:export',             'reports', 'export', 'Exportar cualquier reporte')

ON CONFLICT (name) DO NOTHING;

-- =============================================================================
-- ROLES
-- =============================================================================
INSERT INTO roles (id, name, description) VALUES
  ('00000000-0000-0000-0000-000000000001', 'super_admin',         'Acceso total al sistema sin restricciones'),
  ('00000000-0000-0000-0000-000000000002', 'admin',               'Administrador general del ERP'),
  ('00000000-0000-0000-0000-000000000003', 'finance_manager',     'Gerente de finanzas y contabilidad'),
  ('00000000-0000-0000-0000-000000000004', 'sales_manager',       'Gerente de ventas y CRM'),
  ('00000000-0000-0000-0000-000000000005', 'inventory_manager',   'Gerente de inventario y almacén'),
  ('00000000-0000-0000-0000-000000000006', 'purchasing_manager',  'Gerente de compras y proveedores'),
  ('00000000-0000-0000-0000-000000000007', 'hr_manager',          'Gerente de recursos humanos'),
  ('00000000-0000-0000-0000-000000000008', 'accountant',          'Contador — asientos y reportes financieros'),
  ('00000000-0000-0000-0000-000000000009', 'sales_agent',         'Agente de ventas — cotizaciones y facturas'),
  ('00000000-0000-0000-0000-000000000010', 'warehouse_operator',  'Operador de almacén — stock y recepciones'),
  ('00000000-0000-0000-0000-000000000011', 'purchasing_agent',    'Agente de compras — órdenes de compra'),
  ('00000000-0000-0000-0000-000000000012', 'hr_agent',            'Agente de RRHH — empleados y asistencia'),
  ('00000000-0000-0000-0000-000000000013', 'auditor',             'Auditor — solo lectura en todos los módulos'),
  ('00000000-0000-0000-0000-000000000014', 'viewer',              'Visualizador — solo dashboard y reportes básicos')
ON CONFLICT (name) DO NOTHING;

-- =============================================================================
-- ASIGNACIÓN DE PERMISOS A ROLES
-- =============================================================================

-- ── super_admin: TODOS los permisos ──────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000001', id FROM permissions
ON CONFLICT DO NOTHING;

-- ── admin: todos excepto nómina y asientos contables (requieren roles especializados) ──
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000002', id FROM permissions
  WHERE name NOT IN ('hr:payroll:process', 'finance:journal:approve')
ON CONFLICT DO NOTHING;

-- ── finance_manager ───────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000003', id FROM permissions
  WHERE module IN ('finance', 'reports')
     OR name IN ('billing:invoices:read', 'billing:payments:read', 'billing:credit_notes:read')
ON CONFLICT DO NOTHING;

-- ── sales_manager ─────────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000004', id FROM permissions
  WHERE module IN ('billing', 'crm')
     OR name IN ('inventory:products:read', 'inventory:stock:read',
                 'reports:dashboard:read', 'reports:sales:read')
ON CONFLICT DO NOTHING;

-- ── inventory_manager ─────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000005', id FROM permissions
  WHERE module = 'inventory'
     OR name IN ('purchasing:orders:read', 'purchasing:orders:receive',
                 'reports:dashboard:read', 'reports:inventory:read')
ON CONFLICT DO NOTHING;

-- ── purchasing_manager ────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000006', id FROM permissions
  WHERE module = 'purchasing'
     OR name IN ('inventory:products:read', 'inventory:stock:read',
                 'reports:dashboard:read')
ON CONFLICT DO NOTHING;

-- ── hr_manager ────────────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000007', id FROM permissions
  WHERE module = 'hr'
     OR name IN ('reports:dashboard:read', 'reports:hr:read')
ON CONFLICT DO NOTHING;

-- ── accountant ────────────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000008', id FROM permissions
  WHERE name IN (
    'finance:accounts:read', 'finance:journal:read', 'finance:journal:create',
    'finance:reports:read',  'finance:reports:export', 'finance:budgets:read',
    'billing:invoices:read', 'billing:payments:read',  'billing:credit_notes:read',
    'reports:dashboard:read','reports:finance:read'
  )
ON CONFLICT DO NOTHING;

-- ── sales_agent ───────────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000009', id FROM permissions
  WHERE name IN (
    'billing:invoices:read',   'billing:invoices:create',
    'billing:quotes:read',     'billing:quotes:create',
    'billing:payments:read',   'billing:payments:register',
    'crm:customers:read',      'crm:customers:create',   'crm:customers:update',
    'crm:leads:read',          'crm:leads:manage',
    'crm:contacts:read',       'crm:contacts:manage',
    'inventory:products:read', 'inventory:stock:read',
    'reports:dashboard:read',  'reports:sales:read'
  )
ON CONFLICT DO NOTHING;

-- ── warehouse_operator ────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000010', id FROM permissions
  WHERE name IN (
    'inventory:products:read',  'inventory:stock:read',
    'inventory:stock:adjust',   'inventory:stock:transfer',
    'inventory:warehouses:read','inventory:categories:read',
    'purchasing:orders:read',   'purchasing:orders:receive',
    'reports:dashboard:read',   'reports:inventory:read'
  )
ON CONFLICT DO NOTHING;

-- ── purchasing_agent ──────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000011', id FROM permissions
  WHERE name IN (
    'purchasing:orders:read',    'purchasing:orders:create',  'purchasing:orders:update',
    'purchasing:suppliers:read', 'purchasing:suppliers:manage',
    'inventory:products:read',   'inventory:stock:read',
    'reports:dashboard:read'
  )
ON CONFLICT DO NOTHING;

-- ── hr_agent ──────────────────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000012', id FROM permissions
  WHERE name IN (
    'hr:employees:read',    'hr:employees:create',  'hr:employees:update',
    'hr:attendance:read',   'hr:attendance:manage',
    'hr:payroll:read',
    'reports:dashboard:read'
  )
ON CONFLICT DO NOTHING;

-- ── auditor: solo lectura en TODO ─────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000013', id FROM permissions
  WHERE action = 'read'
ON CONFLICT DO NOTHING;

-- ── viewer: solo dashboard ────────────────────────────────────────────────────
INSERT INTO role_permissions (role_id, permission_id)
  SELECT '00000000-0000-0000-0000-000000000014', id FROM permissions
  WHERE name IN ('reports:dashboard:read', 'reports:sales:read', 'reports:inventory:read')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- USUARIO SUPER ADMIN POR DEFECTO
-- password: Admin1234!
-- =============================================================================
INSERT INTO users (id, name, email, password) VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Super Administrador',
  'admin@vb-erp.com',
  '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
) ON CONFLICT (email) DO NOTHING;

INSERT INTO user_roles (user_id, role_id) VALUES (
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001'  -- super_admin
) ON CONFLICT DO NOTHING;
