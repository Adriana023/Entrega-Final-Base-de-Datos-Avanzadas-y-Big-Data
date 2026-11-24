CREATE DATABASE ColoresyCreaciones;
GO

USE ColoresyCreaciones;
GO

-- 1. Tabla Persona
CREATE TABLE Persona (
    id_persona INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    estado VARCHAR(20)
);
GO

-- 2. Tabla Cliente (Se relaciona con Persona)
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    id_persona INT NOT NULL,
    CONSTRAINT FK_Cliente_Persona FOREIGN KEY (id_persona) REFERENCES Persona(id_persona)
);
GO

-- 3. Tabla Rol (Define los roles para los empleados)
CREATE TABLE Rol (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol VARCHAR(50) NOT NULL
);
GO

-- 4. Tabla Empleado (Se relaciona con Persona y Rol)
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    id_persona INT NOT NULL,
    id_rol INT NOT NULL,
    CONSTRAINT FK_Empleado_Persona FOREIGN KEY (id_persona) REFERENCES Persona(id_persona),
    CONSTRAINT FK_Empleado_Rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);
GO

-- 5. Tabla Proveedor
CREATE TABLE Proveedor (
    id_proveedor INT PRIMARY KEY IDENTITY(1,1),
    razon_social VARCHAR(100) NOT NULL,
    ruc VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(150)
);
GO

-- 6. Tabla MateriaPrima
CREATE TABLE MateriaPrima (
    id_materia_prima INT PRIMARY KEY IDENTITY(1,1),
    nombre_material VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    stock_actual DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0,
    descripcion VARCHAR(200)
);
GO

-- 7. Tabla CompraMateriaPrima
CREATE TABLE CompraMateriaPrima (
    id_compra INT PRIMARY KEY IDENTITY(1,1),
    id_proveedor INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_compra DATETIME NOT NULL DEFAULT GETDATE(),
    numero_factura VARCHAR(50) NOT NULL,
    total_compra DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT FK_Compra_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);
GO

-- 8. Tabla DetalleCompraMateriaPrima
CREATE TABLE DetalleCompraMateriaPrima (
    id_detalle_compra INT PRIMARY KEY IDENTITY(1,1),
    id_compra INT NOT NULL,
    id_materia_prima INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (id_compra) REFERENCES CompraMateriaPrima(id_compra),
    CONSTRAINT FK_DetalleCompra_MateriaPrima FOREIGN KEY (id_materia_prima) REFERENCES MateriaPrima(id_materia_prima)
);
GO

-- 9. Tabla FormulaPasta
CREATE TABLE FormulaPasta (
    id_formula INT PRIMARY KEY IDENTITY(1,1),
    nombre_formula VARCHAR(100) NOT NULL,
    id_empleado_creador INT NOT NULL,
    descripcion VARCHAR(250),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Formula_Empleado FOREIGN KEY (id_empleado_creador) REFERENCES Empleado(id_empleado)
);
GO

-- 10. Tabla DetalleFormulaInsumo
CREATE TABLE DetalleFormulaInsumo (
    id_detalle_formula INT PRIMARY KEY IDENTITY(1,1),
    id_formula INT NOT NULL,
    id_materia_prima INT NOT NULL,
    cantidad_requerida DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleFormula_Formula FOREIGN KEY (id_formula) REFERENCES FormulaPasta(id_formula),
    CONSTRAINT FK_DetalleFormula_MateriaPrima FOREIGN KEY (id_materia_prima) REFERENCES MateriaPrima(id_materia_prima)
);
GO

-- 11. Tabla LoteProduccion
CREATE TABLE LoteProduccion (
    id_lote INT PRIMARY KEY IDENTITY(1,1),
    id_formula INT NOT NULL,
    id_empleado_responsable INT NOT NULL,
    fecha_produccion DATETIME NOT NULL DEFAULT GETDATE(),
    cantidad_producida DECIMAL(10,2) NOT NULL,
    estado_lote VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Lote_Formula FOREIGN KEY (id_formula) REFERENCES FormulaPasta(id_formula),
    CONSTRAINT FK_Lote_Empleado FOREIGN KEY (id_empleado_responsable) REFERENCES Empleado(id_empleado)
);
GO

-- 12. ConsumoLoteMaterial
CREATE TABLE ConsumoLoteMaterial (
    id_consumo INT PRIMARY KEY IDENTITY(1,1),
    id_lote INT NOT NULL,
    id_materia_prima INT NOT NULL,
    cantidad_consumida DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Consumo_Lote FOREIGN KEY (id_lote) REFERENCES LoteProduccion(id_lote),
    CONSTRAINT FK_Consumo_MateriaPrima FOREIGN KEY (id_materia_prima) REFERENCES MateriaPrima(id_materia_prima)
);
GO

-- 13. CategoriaProducto
CREATE TABLE CategoriaProducto (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- 14. Producto
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    id_categoria INT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria) REFERENCES CategoriaProducto(id_categoria)
);
GO

-- Enlazar producto a LoteProduccion de forma segura
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('LoteProduccion') AND name = 'id_producto')
BEGIN
    ALTER TABLE LoteProduccion ADD id_producto INT NULL;
    ALTER TABLE LoteProduccion ADD CONSTRAINT FK_Lote_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto);
END
GO

-- 15. KardexInventario
CREATE TABLE KardexInventario (
    id_kardex INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    stock_resultante DECIMAL(10,2) NOT NULL,
    fecha_movimiento DATETIME NOT NULL DEFAULT GETDATE(),
    motivo VARCHAR(150),
    CONSTRAINT FK_Kardex_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    CONSTRAINT FK_Kardex_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);
GO

-- 16. MetodoPago
CREATE TABLE MetodoPago (
    id_metodo_pago INT PRIMARY KEY IDENTITY(1,1),
    nombre_metodo VARCHAR(50) NOT NULL
);
GO

-- 17. Tabla Pedido (Soporte para el indicador de Pedidos pendientes)
CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_entrega_estimada DATE NOT NULL,
    estado_pedido VARCHAR(30) DEFAULT 'Pendiente',
    observaciones VARCHAR(250),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Pedido_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);
GO

-- 18. Tabla DetallePedido
CREATE TABLE DetallePedido (
    id_detalle_pedido INT PRIMARY KEY IDENTITY(1,1),
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad_solicitada INT NOT NULL,
    precio_unitario_estimado DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    CONSTRAINT FK_DetallePedido_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
GO

-- 19. Venta (Actualizada con enlace opcional a Pedido)
CREATE TABLE Venta (
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    id_pedido INT NULL,
    fecha_venta DATETIME NOT NULL DEFAULT GETDATE(),
    total_venta DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Venta_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    CONSTRAINT FK_Venta_MetodoPago FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(id_metodo_pago),
    CONSTRAINT FK_Venta_Pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);
GO

-- 20. DetalleVenta
CREATE TABLE DetalleVenta (
    id_detalle_venta INT PRIMARY KEY IDENTITY(1,1),
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
GO

-- 21. AuditoriaSistema
CREATE TABLE AuditoriaSistema (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT NULL,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT GETDATE(),
    detalles VARCHAR(500),
    CONSTRAINT FK_Auditoria_Empleado FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);
GO

-- 22. ConfiguracionTaller
CREATE TABLE ConfiguracionTaller (
    id_configuracion INT PRIMARY KEY IDENTITY(1,1),
    clave VARCHAR(50) NOT NULL UNIQUE,
    valor VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255)
);
GO

