// ============================================================
// SOLUCIÓN TALLER MONGODB
// Caso: Dulcería Picante para Pitoflanes
// ============================================================

// ============================================================
// 1. CREAR / SELECCIONAR BASE DE DATOS
// ============================================================

// use cambia la base de datos actual.
// Si no existe, MongoDB la crea automáticamente.
use("dulceria_picante");

// ============================================================
// 2. LIMPIAR COLECCIONES
// ============================================================

// Elimina la colección clientes si existe.
db.clientes.drop();

// Elimina la colección categorías si existe.
db.categorias.drop();

// Elimina la colección proveedores si existe.
db.proveedores.drop();

// Elimina la colección productos si existe.
db.productos.drop();

// Elimina la colección ventas si existe.
db.ventas.drop();

// Elimina la colección promociones si existe.
db.promociones.drop();

// ============================================================
// 3. INSERTAR CATEGORÍAS
// ============================================================

// insertMany permite insertar varios documentos.
db.categorias.insertMany([

  // Primera categoría
  {
    nombre: "Chocolates", // Nombre de la categoría
    descripcion: "Productos basados en chocolate", // Explicación
    estado: "activa" // Estado actual
  },

  {
    nombre: "Gomitas",
    descripcion: "Gomitas de diferentes sabores",
    estado: "activa"
  },

  {
    nombre: "Bombones",
    descripcion: "Bombones especiales",
    estado: "activa"
  },

  {
    nombre: "Chupetas",
    descripcion: "Chupetas temáticas",
    estado: "activa"
  },

  {
    nombre: "Ediciones Especiales",
    descripcion: "Productos exclusivos",
    estado: "activa"
  }

]);

// ============================================================
// 4. INSERTAR PROVEEDORES
// ============================================================

db.proveedores.insertMany([

  {
    nombreEmpresa: "Dulces La Tentación",
    contacto: "Laura Mejía",
    telefono: "3001112233",
    correo: "ventas@tentacion.com",
    ciudad: "Medellín",

    // Tiempo promedio de entrega
    tiempoEntregaDias: 3,

    estado: "activo"
  },

  {
    nombreEmpresa: "Sabores Traviesos",
    contacto: "Carlos Pérez",
    telefono: "3012223344",
    correo: "info@saborestraviesos.com",
    ciudad: "Bogotá",
    tiempoEntregaDias: 5,
    estado: "activo"
  },

  {
    nombreEmpresa: "Confitería Picante",
    contacto: "Sofía Ríos",
    telefono: "3023334455",
    correo: "pedidos@picante.com",
    ciudad: "Cali",
    tiempoEntregaDias: 4,
    estado: "activo"
  }

]);

// ============================================================
// 5. INSERTAR CLIENTES
// ============================================================

db.clientes.insertMany([

  {
    nombre: "Camila Restrepo",
    correo: "camila@email.com",
    telefono: "3101112233",
    ciudad: "Medellín",

    // Fecha de registro del cliente
    fechaRegistro: new Date(),

    tipoCliente: "VIP",

    // Puntos acumulados
    puntos: 950,

    preferencias: [
      "chocolates",
      "gomitas"
    ]
  },

  {
    nombre: "Andrés Gómez",
    correo: "andres@email.com",
    telefono: "3112223344",
    ciudad: "Bogotá",
    fechaRegistro: new Date(),
    tipoCliente: "frecuente",
    puntos: 500,
    preferencias: [
      "bombones"
    ]
  },

  {
    nombre: "Mariana López",
    correo: "mariana@email.com",
    telefono: "3123334455",
    ciudad: "Cali",
    fechaRegistro: new Date(),
    tipoCliente: "nuevo",
    puntos: 100,
    preferencias: [
      "gomitas"
    ]
  }

]);

// ============================================================
// 6. INSERTAR PRODUCTOS
// ============================================================

db.productos.insertMany([

  {
    nombre: "Nepe Crepe",

    descripcion:
      "Crepe dulce con chocolate y toque picante",

    categoria: "Ediciones Especiales",

    proveedor: "Dulces La Tentación",

    precioVenta: 15000,

    costoCompra: 7000,

    stockActual: 35,

    stockMinimo: 10,

    estado: "activo",

    // Producto estrella
    esFlagship: true,

    unidadesVendidas: 120,

    fechaCreacion: new Date(),

    fechaUltimaVenta: new Date()
  },

  {
    nombre: "Teta Azul",

    descripcion:
      "Dulce azul famoso en redes sociales",

    categoria: "Bombones",

    proveedor: "Sabores Traviesos",

    precioVenta: 12000,

    costoCompra: 5000,

    stockActual: 20,

    stockMinimo: 8,

    estado: "activo",

    esFlagship: true,

    unidadesVendidas: 90,

    fechaCreacion: new Date(),

    fechaUltimaVenta: new Date()
  },

  {
    nombre: "Bombón Despistado",

    descripcion:
      "Producto con pocas ventas",

    categoria: "Bombones",

    proveedor: "Confitería Picante",

    precioVenta: 8000,

    costoCompra: 3500,

    stockActual: 90,

    stockMinimo: 10,

    estado: "activo",

    esFlagship: false,

    unidadesVendidas: 3,

    fechaCreacion: new Date(),

    fechaUltimaVenta: new Date("2026-02-01")
  },

  {
    nombre: "Chocolate Misterioso",

    descripcion:
      "Chocolate sorpresa",

    categoria: "Chocolates",

    proveedor: "Dulces La Tentación",

    precioVenta: 10000,

    costoCompra: 4000,

    stockActual: 70,

    stockMinimo: 15,

    estado: "activo",

    esFlagship: false,

    unidadesVendidas: 10,

    fechaCreacion: new Date(),

    fechaUltimaVenta: new Date("2026-03-01")
  }

]);

// ============================================================
// 7. INSERTAR VENTAS
// ============================================================

db.ventas.insertMany([

  {
    cliente: "Camila Restrepo",

    fecha: new Date(),

    productos: [

      {
        nombre: "Nepe Crepe",

        cantidad: 2,

        precioUnitario: 15000,

        descuento: 0
      },

      {
        nombre: "Teta Azul",

        cantidad: 1,

        precioUnitario: 12000,

        descuento: 1000
      }

    ],

    total: 41000,

    metodoPago: "Tarjeta",

    estado: "completada"
  },

  {
    cliente: "Andrés Gómez",

    fecha: new Date(),

    productos: [

      {
        nombre: "Bombón Despistado",

        cantidad: 1,

        precioUnitario: 8000,

        descuento: 0
      }

    ],

    total: 8000,

    metodoPago: "Efectivo",

    estado: "completada"
  }

]);

// ============================================================
// 8. INSERTAR PROMOCIONES
// ============================================================

db.promociones.insertMany([

  {
    nombre:
      "Semana del Antojo",

    descripcion:
      "Promoción general del negocio",

    tipo: "general",

    porcentajeDescuento: 10,

    fechaInicio: new Date("2026-05-01"),

    fechaFin: new Date("2026-05-15"),

    estado: "activa"
  },

  {
    nombre:
      "Rebaja Salvadora",

    descripcion:
      "Promoción para productos olvidados",

    tipo: "producto",

    porcentajeDescuento: 25,

    productosAplicables: [
      "Bombón Despistado",
      "Chocolate Misterioso"
    ],

    fechaInicio: new Date("2026-05-01"),

    fechaFin: new Date("2026-05-30"),

    estado: "activa"
  }

]);

// ============================================================
// 9. CONSULTAS BÁSICAS
// ============================================================

// ------------------------------------------------------------
// Consultar todos los productos activos
// ------------------------------------------------------------

// find busca documentos.
db.productos.find({
  estado: "activo"
});

// ------------------------------------------------------------
// Consultar clientes VIP
// ------------------------------------------------------------

db.clientes.find({
  tipoCliente: "VIP"
});

// ------------------------------------------------------------
// Consultar productos flagship
// ------------------------------------------------------------

db.productos.find({
  esFlagship: true
});

// ------------------------------------------------------------
// Consultar productos con precio mayor a 10000
// ------------------------------------------------------------

// $gt significa "greater than".
db.productos.find({
  precioVenta: {
    $gt: 10000
  }
});

// ------------------------------------------------------------
// Consultar productos agotados
// ------------------------------------------------------------

db.productos.find({
  stockActual: 0
});

// ============================================================
// 10. CONSULTAS AVANZADAS
// ============================================================

// ------------------------------------------------------------
// Productos con bajo stock
// ------------------------------------------------------------

// $expr permite comparar campos.
db.productos.find({

  $expr: {
    $lte: [
      "$stockActual",
      "$stockMinimo"
    ]
  }

});

// ------------------------------------------------------------
// Productos con muchas existencias y pocas ventas
// ------------------------------------------------------------

db.productos.find({

  stockActual: {
    $gt: 50
  },

  unidadesVendidas: {
    $lt: 15
  }

});

// ------------------------------------------------------------
// Clientes con más de 500 puntos
// ------------------------------------------------------------

db.clientes.find({

  puntos: {
    $gt: 500
  }

});

// ------------------------------------------------------------
// Buscar productos cuyo nombre contenga "Chocolate"
// ------------------------------------------------------------

// $regex permite usar expresiones regulares.
db.productos.find({

  nombre: {
    $regex: "Chocolate",
    $options: "i"
  }

});

// ============================================================
// 11. ACTUALIZACIONES
// ============================================================

// ------------------------------------------------------------
// Aumentar stock de Nepe Crepe
// ------------------------------------------------------------

// $inc incrementa valores numéricos.
db.productos.updateOne(

  {
    nombre: "Nepe Crepe"
  },

  {
    $inc: {
      stockActual: 20
    }
  }

);

// ------------------------------------------------------------
// Disminuir stock luego de una venta
// ------------------------------------------------------------

db.productos.updateOne(

  {
    nombre: "Teta Azul"
  },

  {
    $inc: {
      stockActual: -2
    }
  }

);

// ------------------------------------------------------------
// Cambiar estado de un producto
// ------------------------------------------------------------

// $set modifica valores.
db.productos.updateOne(

  {
    nombre: "Chocolate Misterioso"
  },

  {
    $set: {
      estado: "en promoción"
    }
  }

);

// ------------------------------------------------------------
// Sumar puntos a un cliente
// ------------------------------------------------------------

db.clientes.updateOne(

  {
    nombre: "Camila Restrepo"
  },

  {
    $inc: {
      puntos: 100
    }
  }

);

// ============================================================
// 12. ELIMINACIONES
// ============================================================

// ------------------------------------------------------------
// Eliminar promociones vencidas
// ------------------------------------------------------------

db.promociones.deleteMany({

  estado: "vencida"

});

// ------------------------------------------------------------
// Eliminación lógica
// ------------------------------------------------------------

// En vez de borrar el producto,
// se marca como descontinuado.
db.productos.updateMany(

  {
    unidadesVendidas: {
      $lt: 5
    }
  },

  {
    $set: {
      estado: "descontinuado"
    }
  }

);

// ============================================================
// 13. AGREGACIONES
// ============================================================

// ------------------------------------------------------------
// Total vendido por producto
// ------------------------------------------------------------

db.ventas.aggregate([

  // Separa cada producto del arreglo productos.
  {
    $unwind: "$productos"
  },

  // Agrupa por nombre del producto.
  {
    $group: {

      _id: "$productos.nombre",

      // Suma cantidades vendidas.
      unidadesVendidas: {
        $sum: "$productos.cantidad"
      },

      // Suma ingresos.
      totalVendido: {

        $sum: {

          $multiply: [
            "$productos.cantidad",
            "$productos.precioUnitario"
          ]

        }

      }

    }
  },

  // Orden descendente.
  {
    $sort: {
      totalVendido: -1
    }
  }

]);

// ------------------------------------------------------------
// Clientes que más dinero han gastado
// ------------------------------------------------------------

db.ventas.aggregate([

  {
    $group: {

      _id: "$cliente",

      totalGastado: {
        $sum: "$total"
      }

    }
  },

  {
    $sort: {
      totalGastado: -1
    }
  }

]);

// ------------------------------------------------------------
// Método de pago más usado
// ------------------------------------------------------------

db.ventas.aggregate([

  {
    $group: {

      _id: "$metodoPago",

      cantidad: {
        $sum: 1
      }

    }
  },

  {
    $sort: {
      cantidad: -1
    }
  }

]);

// ============================================================
// 14. ÍNDICES
// ============================================================

// ------------------------------------------------------------
// Índice único para correos
// ------------------------------------------------------------

// Evita clientes repetidos.
db.clientes.createIndex(

  {
    correo: 1
  },

  {
    unique: true
  }

);

// ------------------------------------------------------------
// Índice para tipo de cliente
// ------------------------------------------------------------

db.clientes.createIndex({

  tipoCliente: 1

});

// ------------------------------------------------------------
// Índice para nombre de producto
// ------------------------------------------------------------

db.productos.createIndex({

  nombre: 1

});

// ------------------------------------------------------------
// Índice para productos flagship
// ------------------------------------------------------------

db.productos.createIndex({

  esFlagship: 1

});

// ------------------------------------------------------------
// Índice para fechas de ventas
// ------------------------------------------------------------

db.ventas.createIndex({

  fecha: 1

});

// ============================================================
// 15. EXPLAIN
// ============================================================

// explain muestra cómo MongoDB ejecuta la consulta.
db.productos.find({

  esFlagship: true

}).explain("executionStats");

// ============================================================
// 16. RESPUESTAS DE NEGOCIO
// ============================================================

// Productos que necesitan promociones:
// - Bombón Despistado
// - Chocolate Misterioso

// Productos estrella:
// - Nepe Crepe
// - Teta Azul

// Clientes para promociones VIP:
// - Camila Restrepo
// - Andrés Gómez

// Productos que necesitan reposición:
// Productos cuyo stockActual <= stockMinimo
