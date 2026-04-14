// ============================================================================
//  📦 EJEMPLOS COMPLETOS DE MONGODB - Fácil, Medio y Difícil
//  Ejecutar en mongosh o MongoDB Compass
// ============================================================================

// ============================================================================
// 🏗️  PARTE 1: CONFIGURACIÓN INICIAL - Crear Base de Datos y Colecciones
// ============================================================================

use("tienda_online");

// --- Colección: productos ---
db.productos.drop();
db.productos.insertMany([
  {
    nombre: "Laptop HP Pavilion",
    categoria: "Electrónica",
    precio: 2500000,
    stock: 15,
    marca: "HP",
    especificaciones: {
      ram: "16GB",
      almacenamiento: "512GB SSD",
      procesador: "Intel i7",
      pantalla: "15.6 pulgadas"
    },
    etiquetas: ["laptop", "computador", "hp", "gaming"],
    calificacion: 4.5,
    activo: true,
    fechaCreacion: new Date("2025-01-15"),
    vendedor: "TechStore"
  },
  {
    nombre: "iPhone 15 Pro",
    categoria: "Celulares",
    precio: 4800000,
    stock: 30,
    marca: "Apple",
    especificaciones: {
      ram: "8GB",
      almacenamiento: "256GB",
      procesador: "A17 Pro",
      pantalla: "6.1 pulgadas"
    },
    etiquetas: ["celular", "apple", "iphone", "premium"],
    calificacion: 4.8,
    activo: true,
    fechaCreacion: new Date("2025-03-20"),
    vendedor: "AppleStore"
  },
  {
    nombre: "Samsung Galaxy S24",
    categoria: "Celulares",
    precio: 3500000,
    stock: 25,
    marca: "Samsung",
    especificaciones: {
      ram: "12GB",
      almacenamiento: "256GB",
      procesador: "Snapdragon 8 Gen 3",
      pantalla: "6.2 pulgadas"
    },
    etiquetas: ["celular", "samsung", "android", "galaxy"],
    calificacion: 4.6,
    activo: true,
    fechaCreacion: new Date("2025-02-10"),
    vendedor: "SamsungDirect"
  },
  {
    nombre: "Audífonos Sony WH-1000XM5",
    categoria: "Audio",
    precio: 1200000,
    stock: 50,
    marca: "Sony",
    especificaciones: {
      tipo: "Over-ear",
      conectividad: "Bluetooth 5.2",
      bateria: "30 horas",
      cancelacionRuido: true
    },
    etiquetas: ["audifonos", "sony", "bluetooth", "cancelacion-ruido"],
    calificacion: 4.9,
    activo: true,
    fechaCreacion: new Date("2025-01-05"),
    vendedor: "AudioPro"
  },
  {
    nombre: "Teclado Mecánico Logitech G Pro",
    categoria: "Periféricos",
    precio: 450000,
    stock: 40,
    marca: "Logitech",
    especificaciones: {
      tipo: "Mecánico",
      switches: "GX Blue",
      iluminacion: "RGB",
      layout: "TKL"
    },
    etiquetas: ["teclado", "gaming", "mecanico", "logitech"],
    calificacion: 4.3,
    activo: true,
    fechaCreacion: new Date("2025-04-01"),
    vendedor: "GamerZone"
  },
  {
    nombre: "Monitor LG UltraWide 34\"",
    categoria: "Monitores",
    precio: 1800000,
    stock: 10,
    marca: "LG",
    especificaciones: {
      resolucion: "3440x1440",
      panel: "IPS",
      tasaRefresco: "144Hz",
      pantalla: "34 pulgadas"
    },
    etiquetas: ["monitor", "ultrawide", "lg", "gaming"],
    calificacion: 4.7,
    activo: true,
    fechaCreacion: new Date("2025-02-28"),
    vendedor: "TechStore"
  },
  {
    nombre: "Mouse Razer DeathAdder V3",
    categoria: "Periféricos",
    precio: 350000,
    stock: 60,
    marca: "Razer",
    especificaciones: {
      sensor: "Focus Pro 30K",
      peso: "59g",
      botones: 5,
      conectividad: "USB-C"
    },
    etiquetas: ["mouse", "gaming", "razer", "ergonomico"],
    calificacion: 4.4,
    activo: true,
    fechaCreacion: new Date("2025-03-15"),
    vendedor: "GamerZone"
  },
  {
    nombre: "Tablet iPad Air M2",
    categoria: "Tablets",
    precio: 3200000,
    stock: 0,
    marca: "Apple",
    especificaciones: {
      ram: "8GB",
      almacenamiento: "128GB",
      procesador: "Apple M2",
      pantalla: "11 pulgadas"
    },
    etiquetas: ["tablet", "apple", "ipad", "dibujo"],
    calificacion: 4.6,
    activo: false,
    fechaCreacion: new Date("2024-11-20"),
    vendedor: "AppleStore"
  },
  {
    nombre: "Cámara Canon EOS R6",
    categoria: "Fotografía",
    precio: 8500000,
    stock: 5,
    marca: "Canon",
    especificaciones: {
      megapixeles: 24.2,
      sensor: "Full Frame CMOS",
      video: "4K 60fps",
      estabilizacion: true
    },
    etiquetas: ["camara", "canon", "mirrorless", "profesional"],
    calificacion: 4.9,
    activo: true,
    fechaCreacion: new Date("2024-12-01"),
    vendedor: "FotoMundo"
  },
  {
    nombre: "Disco Duro Externo Seagate 2TB",
    categoria: "Almacenamiento",
    precio: 250000,
    stock: 100,
    marca: "Seagate",
    especificaciones: {
      capacidad: "2TB",
      tipo: "HDD",
      interfaz: "USB 3.0",
      velocidad: "120MB/s"
    },
    etiquetas: ["disco", "almacenamiento", "externo", "backup"],
    calificacion: 4.1,
    activo: true,
    fechaCreacion: new Date("2025-01-30"),
    vendedor: "TechStore"
  }
]);

// --- Colección: clientes ---
db.clientes.drop();
db.clientes.insertMany([
  {
    nombre: "Carlos Martínez",
    email: "carlos@email.com",
    edad: 28,
    ciudad: "Bogotá",
    departamento: "Cundinamarca",
    membresia: "gold",
    fechaRegistro: new Date("2024-06-15"),
    direcciones: [
      { tipo: "casa", direccion: "Calle 100 #15-20", principal: true },
      { tipo: "trabajo", direccion: "Carrera 7 #45-10", principal: false }
    ],
    intereses: ["tecnología", "gaming", "fotografía"],
    totalCompras: 12500000,
    activo: true
  },
  {
    nombre: "María López",
    email: "maria@email.com",
    edad: 35,
    ciudad: "Medellín",
    departamento: "Antioquia",
    membresia: "platinum",
    fechaRegistro: new Date("2023-11-20"),
    direcciones: [
      { tipo: "casa", direccion: "Calle 10 #43-25", principal: true }
    ],
    intereses: ["moda", "tecnología", "viajes"],
    totalCompras: 28000000,
    activo: true
  },
  {
    nombre: "Andrés García",
    email: "andres@email.com",
    edad: 22,
    ciudad: "Cali",
    departamento: "Valle del Cauca",
    membresia: "basic",
    fechaRegistro: new Date("2025-01-10"),
    direcciones: [
      { tipo: "casa", direccion: "Av 5N #23-45", principal: true }
    ],
    intereses: ["gaming", "deportes"],
    totalCompras: 850000,
    activo: true
  },
  {
    nombre: "Laura Rodríguez",
    email: "laura@email.com",
    edad: 30,
    ciudad: "Bogotá",
    departamento: "Cundinamarca",
    membresia: "gold",
    fechaRegistro: new Date("2024-03-05"),
    direcciones: [
      { tipo: "casa", direccion: "Carrera 15 #80-30", principal: true },
      { tipo: "trabajo", direccion: "Calle 72 #10-15", principal: false }
    ],
    intereses: ["tecnología", "música", "lectura"],
    totalCompras: 9200000,
    activo: true
  },
  {
    nombre: "Pedro Sánchez",
    email: "pedro@email.com",
    edad: 45,
    ciudad: "Barranquilla",
    departamento: "Atlántico",
    membresia: "basic",
    fechaRegistro: new Date("2025-02-20"),
    direcciones: [
      { tipo: "casa", direccion: "Calle 84 #55-12", principal: true }
    ],
    intereses: ["deportes", "viajes"],
    totalCompras: 450000,
    activo: false
  },
  {
    nombre: "Sofía Hernández",
    email: "sofia@email.com",
    edad: 27,
    ciudad: "Medellín",
    departamento: "Antioquia",
    membresia: "gold",
    fechaRegistro: new Date("2024-08-12"),
    direcciones: [
      { tipo: "casa", direccion: "Calle 50 #65-30", principal: true },
      { tipo: "oficina", direccion: "Carrera 43A #1-50", principal: false }
    ],
    intereses: ["fotografía", "tecnología", "música"],
    totalCompras: 15600000,
    activo: true
  }
]);

// --- Colección: pedidos ---
db.pedidos.drop();
db.pedidos.insertMany([
  {
    numeroPedido: "PED-001",
    clienteEmail: "carlos@email.com",
    productos: [
      { nombre: "Laptop HP Pavilion", cantidad: 1, precioUnitario: 2500000 },
      { nombre: "Mouse Razer DeathAdder V3", cantidad: 1, precioUnitario: 350000 }
    ],
    total: 2850000,
    estado: "entregado",
    metodoPago: "tarjeta_credito",
    fechaPedido: new Date("2025-01-20"),
    fechaEntrega: new Date("2025-01-25"),
    direccionEnvio: "Calle 100 #15-20, Bogotá",
    notas: "Entregar en portería"
  },
  {
    numeroPedido: "PED-002",
    clienteEmail: "maria@email.com",
    productos: [
      { nombre: "iPhone 15 Pro", cantidad: 1, precioUnitario: 4800000 }
    ],
    total: 4800000,
    estado: "entregado",
    metodoPago: "tarjeta_credito",
    fechaPedido: new Date("2025-02-05"),
    fechaEntrega: new Date("2025-02-08"),
    direccionEnvio: "Calle 10 #43-25, Medellín",
    notas: ""
  },
  {
    numeroPedido: "PED-003",
    clienteEmail: "andres@email.com",
    productos: [
      { nombre: "Teclado Mecánico Logitech G Pro", cantidad: 1, precioUnitario: 450000 },
      { nombre: "Mouse Razer DeathAdder V3", cantidad: 1, precioUnitario: 350000 }
    ],
    total: 800000,
    estado: "en_camino",
    metodoPago: "PSE",
    fechaPedido: new Date("2025-03-10"),
    fechaEntrega: null,
    direccionEnvio: "Av 5N #23-45, Cali",
    notas: "Llamar antes de entregar"
  },
  {
    numeroPedido: "PED-004",
    clienteEmail: "laura@email.com",
    productos: [
      { nombre: "Audífonos Sony WH-1000XM5", cantidad: 2, precioUnitario: 1200000 },
      { nombre: "Disco Duro Externo Seagate 2TB", cantidad: 1, precioUnitario: 250000 }
    ],
    total: 2650000,
    estado: "entregado",
    metodoPago: "tarjeta_debito",
    fechaPedido: new Date("2025-02-15"),
    fechaEntrega: new Date("2025-02-20"),
    direccionEnvio: "Carrera 15 #80-30, Bogotá",
    notas: ""
  },
  {
    numeroPedido: "PED-005",
    clienteEmail: "sofia@email.com",
    productos: [
      { nombre: "Cámara Canon EOS R6", cantidad: 1, precioUnitario: 8500000 }
    ],
    total: 8500000,
    estado: "procesando",
    metodoPago: "tarjeta_credito",
    fechaPedido: new Date("2025-04-01"),
    fechaEntrega: null,
    direccionEnvio: "Calle 50 #65-30, Medellín",
    notas: "Regalo - envolver"
  },
  {
    numeroPedido: "PED-006",
    clienteEmail: "carlos@email.com",
    productos: [
      { nombre: "Monitor LG UltraWide 34\"", cantidad: 1, precioUnitario: 1800000 },
      { nombre: "Teclado Mecánico Logitech G Pro", cantidad: 1, precioUnitario: 450000 }
    ],
    total: 2250000,
    estado: "entregado",
    metodoPago: "tarjeta_credito",
    fechaPedido: new Date("2025-03-05"),
    fechaEntrega: new Date("2025-03-10"),
    direccionEnvio: "Calle 100 #15-20, Bogotá",
    notas: ""
  },
  {
    numeroPedido: "PED-007",
    clienteEmail: "maria@email.com",
    productos: [
      { nombre: "Tablet iPad Air M2", cantidad: 1, precioUnitario: 3200000 },
      { nombre: "Audífonos Sony WH-1000XM5", cantidad: 1, precioUnitario: 1200000 }
    ],
    total: 4400000,
    estado: "entregado",
    metodoPago: "efectivo",
    fechaPedido: new Date("2025-01-25"),
    fechaEntrega: new Date("2025-01-30"),
    direccionEnvio: "Calle 10 #43-25, Medellín",
    notas: ""
  },
  {
    numeroPedido: "PED-008",
    clienteEmail: "carlos@email.com",
    productos: [
      { nombre: "Samsung Galaxy S24", cantidad: 1, precioUnitario: 3500000 },
      { nombre: "Audífonos Sony WH-1000XM5", cantidad: 1, precioUnitario: 1200000 },
      { nombre: "Disco Duro Externo Seagate 2TB", cantidad: 2, precioUnitario: 250000 }
    ],
    total: 5200000,
    estado: "cancelado",
    metodoPago: "PSE",
    fechaPedido: new Date("2025-03-28"),
    fechaEntrega: null,
    direccionEnvio: "Carrera 7 #45-10, Bogotá",
    notas: "Cancelado por el cliente"
  }
]);

print("\n✅ Base de datos 'tienda_online' creada con 3 colecciones:");
print("   📦 productos: " + db.productos.countDocuments() + " documentos");
print("   👤 clientes: " + db.clientes.countDocuments() + " documentos");
print("   📋 pedidos: " + db.pedidos.countDocuments() + " documentos");


// ============================================================================
// ============================================================================
//
//     📗 NIVEL FÁCIL - Operaciones Básicas
//
// ============================================================================
// ============================================================================


// =============================================
// 📥 INSERTAR (INSERT)
// =============================================

// --- 1. Insertar UN documento ---
db.productos.insertOne({
  nombre: "Webcam Logitech C920",
  categoria: "Periféricos",
  precio: 280000,
  stock: 35,
  marca: "Logitech",
  especificaciones: {
    resolucion: "1080p",
    fps: 30,
    microfono: true
  },
  etiquetas: ["webcam", "streaming", "logitech"],
  calificacion: 4.2,
  activo: true,
  fechaCreacion: new Date(),
  vendedor: "TechStore"
});

// --- 2. Insertar VARIOS documentos ---
db.clientes.insertMany([
  {
    nombre: "Diego Torres",
    email: "diego@email.com",
    edad: 33,
    ciudad: "Bucaramanga",
    departamento: "Santander",
    membresia: "basic",
    fechaRegistro: new Date(),
    direcciones: [
      { tipo: "casa", direccion: "Calle 36 #23-15", principal: true }
    ],
    intereses: ["tecnología", "cocina"],
    totalCompras: 0,
    activo: true
  },
  {
    nombre: "Valentina Ruiz",
    email: "valentina@email.com",
    edad: 25,
    ciudad: "Pereira",
    departamento: "Risaralda",
    membresia: "gold",
    fechaRegistro: new Date(),
    direcciones: [
      { tipo: "casa", direccion: "Av 30 de Agosto #45-10", principal: true }
    ],
    intereses: ["moda", "tecnología", "deportes"],
    totalCompras: 7500000,
    activo: true
  }
]);


// =============================================
// 🔍 CONSULTAR (FIND) - NIVEL FÁCIL
// =============================================

// --- 3. Obtener TODOS los documentos ---
db.productos.find();

// --- 4. Obtener todos con formato legible ---
db.productos.find().pretty();

// --- 5. Buscar por un campo exacto ---
db.productos.find({ categoria: "Celulares" });

// --- 6. Buscar UN solo documento ---
db.productos.findOne({ nombre: "iPhone 15 Pro" });

// --- 7. Buscar por marca ---
db.clientes.find({ ciudad: "Bogotá" });

// --- 8. Buscar productos activos ---
db.productos.find({ activo: true });

// --- 9. Buscar productos inactivos ---
db.productos.find({ activo: false });

// --- 10. Contar documentos ---
db.productos.countDocuments();

// --- 11. Contar con filtro ---
db.productos.countDocuments({ categoria: "Celulares" });

// --- 12. Limitar resultados ---
db.productos.find().limit(3);

// --- 13. Saltar documentos (paginación) ---
db.productos.find().skip(2).limit(3);

// --- 14. Ordenar ascendente por precio ---
db.productos.find().sort({ precio: 1 });

// --- 15. Ordenar descendente por precio ---
db.productos.find().sort({ precio: -1 });

// --- 16. Mostrar solo ciertos campos (proyección) ---
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 });

// --- 17. Excluir campos ---
db.productos.find({}, { especificaciones: 0, etiquetas: 0 });

// --- 18. Buscar por valor numérico exacto ---
db.productos.find({ stock: 50 });

// --- 19. Buscar pedidos por estado ---
db.pedidos.find({ estado: "entregado" });

// --- 20. Obtener valores distintos ---
db.productos.distinct("categoria");

// --- 21. Obtener marcas únicas ---
db.productos.distinct("marca");


// =============================================
// ✏️ ACTUALIZAR (UPDATE) - NIVEL FÁCIL
// =============================================

// --- 22. Actualizar UN campo de un documento ---
db.productos.updateOne(
  { nombre: "Laptop HP Pavilion" },
  { $set: { precio: 2300000 } }
);

// --- 23. Actualizar VARIOS campos ---
db.productos.updateOne(
  { nombre: "iPhone 15 Pro" },
  { $set: { precio: 4500000, stock: 28 } }
);

// --- 24. Incrementar un valor numérico ---
db.productos.updateOne(
  { nombre: "Mouse Razer DeathAdder V3" },
  { $inc: { stock: 10 } }
);

// --- 25. Decrementar stock ---
db.productos.updateOne(
  { nombre: "Audífonos Sony WH-1000XM5" },
  { $inc: { stock: -5 } }
);

// --- 26. Actualizar MUCHOS documentos a la vez ---
db.productos.updateMany(
  { categoria: "Periféricos" },
  { $set: { activo: true } }
);

// --- 27. Renombrar un campo ---
db.productos.updateOne(
  { nombre: "Webcam Logitech C920" },
  { $rename: { "vendedor": "tienda" } }
);

// --- 28. Eliminar un campo de un documento ---
db.productos.updateOne(
  { nombre: "Webcam Logitech C920" },
  { $unset: { tienda: "" } }
);

// --- 29. Establecer fecha de modificación ---
db.productos.updateOne(
  { nombre: "Laptop HP Pavilion" },
  { $currentDate: { ultimaModificacion: true } }
);


// =============================================
// 🗑️ ELIMINAR (DELETE) - NIVEL FÁCIL
// =============================================

// --- 30. Eliminar UN documento ---
db.productos.deleteOne({ nombre: "Webcam Logitech C920" });

// --- 31. Eliminar VARIOS documentos ---
// (Cuidado: esto elimina todos los que coincidan)
// db.clientes.deleteMany({ activo: false });

// --- 32. Eliminar todos los documentos de una colección ---
// (Cuidado: borra todo el contenido)
// db.temporal.deleteMany({});

// --- 33. Eliminar colección completa ---
// db.temporal.drop();


// ============================================================================
// ============================================================================
//
//     📙 NIVEL MEDIO - Operadores y Consultas Compuestas
//
// ============================================================================
// ============================================================================


// =============================================
// 🔍 CONSULTAS CON OPERADORES DE COMPARACIÓN
// =============================================

// --- 34. Mayor que ($gt) - Productos con precio mayor a 2 millones ---
db.productos.find({ precio: { $gt: 2000000 } });

// --- 35. Mayor o igual ($gte) ---
db.productos.find({ precio: { $gte: 2000000 } });

// --- 36. Menor que ($lt) - Productos baratos ---
db.productos.find({ precio: { $lt: 500000 } });

// --- 37. Menor o igual ($lte) ---
db.productos.find({ calificacion: { $lte: 4.3 } });

// --- 38. Rango de precios ($gt + $lt) ---
db.productos.find({ precio: { $gt: 1000000, $lt: 4000000 } });

// --- 39. No igual ($ne) ---
db.productos.find({ categoria: { $ne: "Celulares" } });

// --- 40. Dentro de una lista ($in) ---
db.productos.find({ categoria: { $in: ["Celulares", "Tablets"] } });

// --- 41. NO dentro de una lista ($nin) ---
db.productos.find({ marca: { $nin: ["Apple", "Samsung"] } });


// =============================================
// 🔍 CONSULTAS CON OPERADORES LÓGICOS
// =============================================

// --- 42. AND explícito ($and) ---
db.productos.find({
  $and: [
    { precio: { $gt: 1000000 } },
    { calificacion: { $gte: 4.5 } }
  ]
});

// --- 43. AND implícito (más común) ---
db.productos.find({
  precio: { $gt: 1000000 },
  calificacion: { $gte: 4.5 }
});

// --- 44. OR ($or) - Productos de Apple O Samsung ---
db.productos.find({
  $or: [
    { marca: "Apple" },
    { marca: "Samsung" }
  ]
});

// --- 45. NOR ($nor) - NI Apple NI Samsung ---
db.productos.find({
  $nor: [
    { marca: "Apple" },
    { marca: "Samsung" }
  ]
});

// --- 46. NOT ($not) - Precio NO mayor a 3 millones ---
db.productos.find({
  precio: { $not: { $gt: 3000000 } }
});

// --- 47. Combinación AND + OR ---
db.productos.find({
  activo: true,
  $or: [
    { precio: { $lt: 500000 } },
    { calificacion: { $gte: 4.8 } }
  ]
});


// =============================================
// 🔍 CONSULTAS EN CAMPOS ANIDADOS Y ARRAYS
// =============================================

// --- 48. Buscar en campo anidado (dot notation) ---
db.productos.find({ "especificaciones.ram": "16GB" });

// --- 49. Buscar en campo anidado del procesador ---
db.productos.find({ "especificaciones.procesador": "Apple M2" });

// --- 50. Buscar elemento en un array ---
db.productos.find({ etiquetas: "gaming" });

// --- 51. Buscar múltiples elementos en array ($all) ---
db.productos.find({ etiquetas: { $all: ["gaming", "mecanico"] } });

// --- 52. Buscar por tamaño del array ($size) ---
db.clientes.find({ intereses: { $size: 3 } });

// --- 53. Buscar en array de objetos ---
db.clientes.find({ "direcciones.tipo": "trabajo" });

// --- 54. Buscar en array con condición ---
db.pedidos.find({ "productos.precioUnitario": { $gt: 3000000 } });


// =============================================
// 🔍 OPERADORES DE ELEMENTO Y TIPO
// =============================================

// --- 55. Campo existe ($exists) ---
db.productos.find({ "especificaciones.cancelacionRuido": { $exists: true } });

// --- 56. Campo NO existe ---
db.productos.find({ "especificaciones.cancelacionRuido": { $exists: false } });

// --- 57. Buscar por tipo de dato ($type) ---
db.productos.find({ precio: { $type: "number" } });

// --- 58. Buscar campos null ---
db.pedidos.find({ fechaEntrega: null });


// =============================================
// 🔍 CONSULTAS CON EXPRESIONES REGULARES
// =============================================

// --- 59. Regex simple - nombres que contengan "Samsung" ---
db.productos.find({ nombre: /Samsung/ });

// --- 60. Regex case-insensitive - buscar "sony" sin importar mayúsculas ---
db.productos.find({ nombre: { $regex: "sony", $options: "i" } });

// --- 61. Empieza con... ---
db.productos.find({ nombre: { $regex: "^Laptop" } });

// --- 62. Termina con... ---
db.productos.find({ nombre: { $regex: "Pro$" } });

// --- 63. Buscar emails con dominio específico ---
db.clientes.find({ email: { $regex: "@email.com$" } });


// =============================================
// ✏️ ACTUALIZACIONES AVANZADAS - NIVEL MEDIO
// =============================================

// --- 64. Agregar elemento a un array ($push) ---
db.productos.updateOne(
  { nombre: "Laptop HP Pavilion" },
  { $push: { etiquetas: "oferta" } }
);

// --- 65. Agregar varios elementos a un array ($push + $each) ---
db.clientes.updateOne(
  { email: "carlos@email.com" },
  { $push: { intereses: { $each: ["cocina", "viajes"] } } }
);

// --- 66. Eliminar elemento de un array ($pull) ---
db.productos.updateOne(
  { nombre: "Laptop HP Pavilion" },
  { $pull: { etiquetas: "oferta" } }
);

// --- 67. Agregar solo si no existe ($addToSet) ---
db.productos.updateOne(
  { nombre: "iPhone 15 Pro" },
  { $addToSet: { etiquetas: "5G" } }
);

// --- 68. Actualizar elemento específico en array (posicional $) ---
db.clientes.updateOne(
  { email: "carlos@email.com", "direcciones.tipo": "casa" },
  { $set: { "direcciones.$.direccion": "Calle 100 #15-25 Apto 301" } }
);

// --- 69. Multiplicar valor ($mul) ---
db.productos.updateOne(
  { nombre: "Disco Duro Externo Seagate 2TB" },
  { $mul: { precio: 0.9 } }  // Aplicar 10% de descuento
);

// --- 70. Valor máximo ($max) - Solo actualiza si el nuevo valor es MAYOR ---
db.productos.updateOne(
  { nombre: "Mouse Razer DeathAdder V3" },
  { $max: { calificacion: 4.6 } }
);

// --- 71. Valor mínimo ($min) - Solo actualiza si el nuevo valor es MENOR ---
db.productos.updateOne(
  { nombre: "Mouse Razer DeathAdder V3" },
  { $min: { precio: 320000 } }
);

// --- 72. Upsert - Insertar si no existe, actualizar si existe ---
db.productos.updateOne(
  { nombre: "Cable HDMI 2.1" },
  {
    $set: {
      categoria: "Accesorios",
      precio: 45000,
      stock: 200,
      marca: "Genérica",
      activo: true
    },
    $setOnInsert: {
      fechaCreacion: new Date(),
      calificacion: 0,
      etiquetas: ["cable", "hdmi"]
    }
  },
  { upsert: true }
);

// --- 73. replaceOne - Reemplazar documento completo ---
db.productos.replaceOne(
  { nombre: "Cable HDMI 2.1" },
  {
    nombre: "Cable HDMI 2.1 - 2 metros",
    categoria: "Accesorios",
    precio: 55000,
    stock: 180,
    marca: "UGreen",
    etiquetas: ["cable", "hdmi", "4k"],
    calificacion: 4.0,
    activo: true,
    fechaCreacion: new Date()
  }
);


// =============================================
// 🗑️ ELIMINAR CON FILTROS - NIVEL MEDIO
// =============================================

// --- 74. Eliminar por condición compuesta ---
// db.productos.deleteMany({ stock: 0, activo: false });

// --- 75. Eliminar con operador de comparación ---
// db.pedidos.deleteMany({ estado: "cancelado" });

// --- 76. findOneAndDelete - Eliminar y devolver el documento ---
// db.productos.findOneAndDelete(
//   { nombre: "Cable HDMI 2.1 - 2 metros" },
//   { projection: { nombre: 1, precio: 1 } }
// );


// ============================================================================
// ============================================================================
//
//     📕 NIVEL DIFÍCIL - Aggregation Pipeline y Consultas Avanzadas
//
// ============================================================================
// ============================================================================


// =============================================
// 🔧 AGGREGATION PIPELINE - BÁSICO
// =============================================

// --- 77. $match + $group: Contar productos por categoría ---
db.productos.aggregate([
  { $match: { activo: true } },
  { $group: {
      _id: "$categoria",
      totalProductos: { $sum: 1 },
      precioPromedio: { $avg: "$precio" }
  }},
  { $sort: { totalProductos: -1 } }
]);

// --- 78. $group: Estadísticas generales de productos ---
db.productos.aggregate([
  { $group: {
      _id: null,
      totalProductos: { $sum: 1 },
      precioMinimo: { $min: "$precio" },
      precioMaximo: { $max: "$precio" },
      precioPromedio: { $avg: "$precio" },
      stockTotal: { $sum: "$stock" }
  }}
]);

// --- 79. $group por marca con total de stock ---
db.productos.aggregate([
  { $group: {
      _id: "$marca",
      cantidadProductos: { $sum: 1 },
      stockTotal: { $sum: "$stock" },
      calificacionPromedio: { $avg: "$calificacion" }
  }},
  { $sort: { calificacionPromedio: -1 } }
]);

// --- 80. $project: Transformar campos ---
db.productos.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      precio: 1,
      precioConIVA: { $multiply: ["$precio", 1.19] },
      enStock: { $cond: { if: { $gt: ["$stock", 0] }, then: "Sí", else: "No" } }
  }}
]);


// =============================================
// 🔧 AGGREGATION PIPELINE - INTERMEDIO
// =============================================

// --- 81. $unwind: Descomponer arrays ---
db.productos.aggregate([
  { $unwind: "$etiquetas" },
  { $group: {
      _id: "$etiquetas",
      cantidad: { $sum: 1 }
  }},
  { $sort: { cantidad: -1 } },
  { $limit: 10 }
]);

// --- 82. $bucket: Agrupar por rangos de precio ---
db.productos.aggregate([
  { $bucket: {
      groupBy: "$precio",
      boundaries: [0, 500000, 1500000, 3000000, 5000000, 10000000],
      default: "Otros",
      output: {
        cantidad: { $sum: 1 },
        productos: { $push: "$nombre" },
        precioPromedio: { $avg: "$precio" }
      }
  }}
]);

// --- 83. Pedidos: Total vendido por método de pago ---
db.pedidos.aggregate([
  { $match: { estado: "entregado" } },
  { $group: {
      _id: "$metodoPago",
      totalVendido: { $sum: "$total" },
      cantidadPedidos: { $sum: 1 },
      promedioCompra: { $avg: "$total" }
  }},
  { $sort: { totalVendido: -1 } }
]);

// --- 84. $addFields + $cond: Clasificar clientes ---
db.clientes.aggregate([
  { $addFields: {
      nivelGasto: {
        $cond: {
          if: { $gte: ["$totalCompras", 15000000] },
          then: "VIP",
          else: {
            $cond: {
              if: { $gte: ["$totalCompras", 5000000] },
              then: "Frecuente",
              else: "Nuevo"
            }
          }
        }
      }
  }},
  { $project: {
      _id: 0,
      nombre: 1,
      totalCompras: 1,
      nivelGasto: 1
  }}
]);

// --- 85. $facet: Múltiples agregaciones en paralelo ---
db.productos.aggregate([
  { $facet: {
      porCategoria: [
        { $group: { _id: "$categoria", total: { $sum: 1 } } },
        { $sort: { total: -1 } }
      ],
      porMarca: [
        { $group: { _id: "$marca", total: { $sum: 1 } } },
        { $sort: { total: -1 } }
      ],
      estadisticasPrecios: [
        { $group: {
            _id: null,
            min: { $min: "$precio" },
            max: { $max: "$precio" },
            avg: { $avg: "$precio" }
        }}
      ]
  }}
]);


// =============================================
// 🔧 AGGREGATION PIPELINE - AVANZADO
// =============================================

// --- 86. $lookup: JOIN entre colecciones (pedidos + clientes) ---
db.pedidos.aggregate([
  { $lookup: {
      from: "clientes",
      localField: "clienteEmail",
      foreignField: "email",
      as: "infoCliente"
  }},
  { $unwind: "$infoCliente" },
  { $project: {
      _id: 0,
      numeroPedido: 1,
      total: 1,
      estado: 1,
      "infoCliente.nombre": 1,
      "infoCliente.ciudad": 1,
      "infoCliente.membresia": 1
  }}
]);

// --- 87. $lookup + $group: Total gastado por cliente con su info ---
db.pedidos.aggregate([
  { $match: { estado: "entregado" } },
  { $group: {
      _id: "$clienteEmail",
      totalGastado: { $sum: "$total" },
      cantidadPedidos: { $sum: 1 },
      pedidos: { $push: "$numeroPedido" }
  }},
  { $lookup: {
      from: "clientes",
      localField: "_id",
      foreignField: "email",
      as: "cliente"
  }},
  { $unwind: "$cliente" },
  { $project: {
      _id: 0,
      nombre: "$cliente.nombre",
      ciudad: "$cliente.ciudad",
      membresia: "$cliente.membresia",
      totalGastado: 1,
      cantidadPedidos: 1,
      pedidos: 1
  }},
  { $sort: { totalGastado: -1 } }
]);

// --- 88. Análisis de productos más vendidos ---
db.pedidos.aggregate([
  { $match: { estado: { $ne: "cancelado" } } },
  { $unwind: "$productos" },
  { $group: {
      _id: "$productos.nombre",
      vecesVendido: { $sum: "$productos.cantidad" },
      ingresoTotal: { $sum: { $multiply: ["$productos.cantidad", "$productos.precioUnitario"] } }
  }},
  { $sort: { vecesVendido: -1 } },
  { $limit: 5 }
]);

// --- 89. Ventas mensuales con $dateToString ---
db.pedidos.aggregate([
  { $match: { estado: "entregado" } },
  { $group: {
      _id: {
        anio: { $year: "$fechaPedido" },
        mes: { $month: "$fechaPedido" }
      },
      totalVentas: { $sum: "$total" },
      cantidadPedidos: { $sum: 1 }
  }},
  { $sort: { "_id.anio": 1, "_id.mes": 1 } },
  { $project: {
      _id: 0,
      periodo: {
        $concat: [
          { $toString: "$_id.anio" },
          "-",
          { $cond: {
              if: { $lt: ["$_id.mes", 10] },
              then: { $concat: ["0", { $toString: "$_id.mes" }] },
              else: { $toString: "$_id.mes" }
          }}
        ]
      },
      totalVentas: 1,
      cantidadPedidos: 1
  }}
]);

// --- 90. KPI Dashboard - Métricas completas del negocio ---
db.pedidos.aggregate([
  { $facet: {
      resumenGeneral: [
        { $group: {
            _id: null,
            totalPedidos: { $sum: 1 },
            ingresosBrutos: { $sum: "$total" },
            ticketPromedio: { $avg: "$total" }
        }}
      ],
      porEstado: [
        { $group: {
            _id: "$estado",
            cantidad: { $sum: 1 },
            monto: { $sum: "$total" }
        }},
        { $sort: { cantidad: -1 } }
      ],
      topClientes: [
        { $match: { estado: "entregado" } },
        { $group: {
            _id: "$clienteEmail",
            gastado: { $sum: "$total" },
            pedidos: { $sum: 1 }
        }},
        { $sort: { gastado: -1 } },
        { $limit: 3 }
      ],
      productoEstrella: [
        { $unwind: "$productos" },
        { $group: {
            _id: "$productos.nombre",
            vendidos: { $sum: "$productos.cantidad" }
        }},
        { $sort: { vendidos: -1 } },
        { $limit: 1 }
      ]
  }}
]);


// =============================================
// 🔧 CONSULTAS AVANZADAS ESPECIALES
// =============================================

// --- 91. $expr: Comparar campos del mismo documento ---
// Productos donde el stock es menor que la calificación * 10
db.productos.aggregate([
  { $match: {
      $expr: {
        $lt: ["$stock", { $multiply: ["$calificacion", 10] }]
      }
  }},
  { $project: {
      _id: 0,
      nombre: 1,
      stock: 1,
      calificacion: 1,
      umbral: { $multiply: ["$calificacion", 10] }
  }}
]);

// --- 92. $cond + $switch: Categorización compleja ---
db.productos.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      precio: 1,
      rangoPrecios: {
        $switch: {
          branches: [
            { case: { $lt: ["$precio", 300000] }, then: "💚 Económico" },
            { case: { $lt: ["$precio", 1000000] }, then: "💛 Accesible" },
            { case: { $lt: ["$precio", 3000000] }, then: "🟠 Medio" },
            { case: { $lt: ["$precio", 5000000] }, then: "🔴 Premium" }
          ],
          default: "💎 Lujo"
        }
      }
  }}
]);

// --- 93. $map: Transformar arrays ---
db.clientes.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      interesesUpperCase: {
        $map: {
          input: "$intereses",
          as: "interes",
          in: { $toUpper: "$$interes" }
        }
      }
  }}
]);

// --- 94. $filter: Filtrar elementos dentro de un array ---
db.pedidos.aggregate([
  { $project: {
      _id: 0,
      numeroPedido: 1,
      productosCaros: {
        $filter: {
          input: "$productos",
          as: "prod",
          cond: { $gte: ["$$prod.precioUnitario", 1000000] }
        }
      }
  }},
  { $match: { "productosCaros.0": { $exists: true } } }
]);

// --- 95. $reduce: Calcular total de productos en cada pedido manualmente ---
db.pedidos.aggregate([
  { $project: {
      _id: 0,
      numeroPedido: 1,
      totalCalculado: {
        $reduce: {
          input: "$productos",
          initialValue: 0,
          in: {
            $add: [
              "$$value",
              { $multiply: ["$$this.cantidad", "$$this.precioUnitario"] }
            ]
          }
        }
      },
      totalRegistrado: "$total"
  }}
]);

// --- 96. $graphLookup: Relaciones recursivas (ejemplo con categorías) ---
// Primero crear una colección de categorías jerárquicas
db.categorias.drop();
db.categorias.insertMany([
  { _id: "Tecnología", padre: null },
  { _id: "Electrónica", padre: "Tecnología" },
  { _id: "Celulares", padre: "Electrónica" },
  { _id: "Tablets", padre: "Electrónica" },
  { _id: "Computadores", padre: "Electrónica" },
  { _id: "Periféricos", padre: "Tecnología" },
  { _id: "Audio", padre: "Tecnología" },
  { _id: "Fotografía", padre: "Tecnología" }
]);

db.categorias.aggregate([
  { $match: { _id: "Tecnología" } },
  { $graphLookup: {
      from: "categorias",
      startWith: "$_id",
      connectFromField: "_id",
      connectToField: "padre",
      as: "subcategorias",
      maxDepth: 3
  }}
]);


// =============================================
// 🔧 ÍNDICES Y RENDIMIENTO
// =============================================

// --- 97. Crear índice simple ---
db.productos.createIndex({ nombre: 1 });

// --- 98. Crear índice compuesto ---
db.productos.createIndex({ categoria: 1, precio: -1 });

// --- 99. Crear índice de texto para búsqueda full-text ---
db.productos.createIndex({ nombre: "text", categoria: "text" });

// Buscar con índice de texto
db.productos.find({ $text: { $search: "laptop gaming" } });

// Buscar con score de relevancia
db.productos.find(
  { $text: { $search: "sony audio bluetooth" } },
  { score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" } });

// --- 100. Crear índice único ---
db.clientes.createIndex({ email: 1 }, { unique: true });

// --- 101. Crear índice TTL (auto-eliminar documentos) ---
db.sesiones.drop();
db.sesiones.insertOne({
  usuario: "carlos@email.com",
  token: "abc123xyz",
  creadoEn: new Date()
});
db.sesiones.createIndex(
  { creadoEn: 1 },
  { expireAfterSeconds: 3600 }  // Eliminar después de 1 hora
);

// --- 102. Ver índices existentes ---
db.productos.getIndexes();

// --- 103. Analizar rendimiento de una consulta (explain) ---
db.productos.find({ categoria: "Celulares" }).explain("executionStats");

// --- 104. Eliminar un índice ---
// db.productos.dropIndex("nombre_1");


// =============================================
// 🔧 OPERACIONES AVANZADAS FINALES
// =============================================

// --- 105. Transacciones (requiere Replica Set) ---
// const session = db.getMongo().startSession();
// session.startTransaction();
// try {
//   db.productos.updateOne(
//     { nombre: "iPhone 15 Pro" },
//     { $inc: { stock: -1 } },
//     { session }
//   );
//   db.pedidos.insertOne({
//     numeroPedido: "PED-009",
//     clienteEmail: "nuevo@email.com",
//     productos: [{ nombre: "iPhone 15 Pro", cantidad: 1, precioUnitario: 4800000 }],
//     total: 4800000,
//     estado: "procesando",
//     metodoPago: "tarjeta_credito",
//     fechaPedido: new Date()
//   }, { session });
//   session.commitTransaction();
// } catch (e) {
//   session.abortTransaction();
//   print("Error: " + e);
// } finally {
//   session.endSession();
// }

// --- 106. Bulk Write - Operaciones masivas optimizadas ---
db.productos.bulkWrite([
  {
    updateOne: {
      filter: { nombre: "Laptop HP Pavilion" },
      update: { $inc: { stock: -1 } }
    }
  },
  {
    updateOne: {
      filter: { nombre: "iPhone 15 Pro" },
      update: { $set: { precio: 4600000 } }
    }
  },
  {
    insertOne: {
      document: {
        nombre: "Cargador USB-C 65W",
        categoria: "Accesorios",
        precio: 85000,
        stock: 150,
        marca: "Anker",
        etiquetas: ["cargador", "usb-c", "rapido"],
        calificacion: 4.5,
        activo: true,
        fechaCreacion: new Date()
      }
    }
  }
]);

// --- 107. Aggregation con $merge - Guardar resultados en otra colección ---
db.pedidos.aggregate([
  { $match: { estado: "entregado" } },
  { $group: {
      _id: "$clienteEmail",
      totalGastado: { $sum: "$total" },
      cantidadPedidos: { $sum: 1 },
      ultimaCompra: { $max: "$fechaPedido" }
  }},
  { $merge: {
      into: "resumen_clientes",
      whenMatched: "replace",
      whenNotMatched: "insert"
  }}
]);

// Verificar la colección creada
db.resumen_clientes.find().pretty();

// --- 108. $unionWith - UNION de colecciones ---
db.productos.aggregate([
  { $project: { _id: 0, tipo: { $literal: "producto" }, nombre: 1, fecha: "$fechaCreacion" } },
  { $unionWith: {
      coll: "pedidos",
      pipeline: [
        { $project: { _id: 0, tipo: { $literal: "pedido" }, nombre: "$numeroPedido", fecha: "$fechaPedido" } }
      ]
  }},
  { $sort: { fecha: -1 } },
  { $limit: 10 }
]);

// --- 109. $setWindowFields - Funciones de ventana (MongoDB 5.0+) ---
db.pedidos.aggregate([
  { $match: { estado: "entregado" } },
  { $setWindowFields: {
      sortBy: { fechaPedido: 1 },
      output: {
        ventasAcumuladas: {
          $sum: "$total",
          window: { documents: ["unbounded", "current"] }
        },
        promedioMovil: {
          $avg: "$total",
          window: { documents: [-2, 0] }
        }
      }
  }},
  { $project: {
      _id: 0,
      numeroPedido: 1,
      total: 1,
      fechaPedido: 1,
      ventasAcumuladas: 1,
      promedioMovil: { $round: ["$promedioMovil", 0] }
  }}
]);

// --- 110. Pipeline complejo: Reporte ejecutivo completo ---
db.pedidos.aggregate([
  // Excluir cancelados
  { $match: { estado: { $ne: "cancelado" } } },

  // Descomponer productos
  { $unwind: "$productos" },

  // Enriquecer con info del cliente
  { $lookup: {
      from: "clientes",
      localField: "clienteEmail",
      foreignField: "email",
      as: "cliente"
  }},
  { $unwind: "$cliente" },

  // Calcular métricas por producto y ciudad
  { $group: {
      _id: {
        producto: "$productos.nombre",
        ciudad: "$cliente.ciudad"
      },
      unidadesVendidas: { $sum: "$productos.cantidad" },
      ingresos: { $sum: { $multiply: ["$productos.cantidad", "$productos.precioUnitario"] } },
      clientesUnicos: { $addToSet: "$clienteEmail" }
  }},

  // Añadir conteo de clientes únicos
  { $addFields: {
      numClientesUnicos: { $size: "$clientesUnicos" }
  }},

  // Ordenar por ingresos
  { $sort: { ingresos: -1 } },

  // Formatear salida
  { $project: {
      _id: 0,
      producto: "$_id.producto",
      ciudad: "$_id.ciudad",
      unidadesVendidas: 1,
      ingresos: 1,
      numClientesUnicos: 1
  }},

  { $limit: 15 }
]);


// ============================================================================
// ✅ FIN DE LOS EJEMPLOS
// ============================================================================
print("\n🎉 ¡Todos los ejemplos han sido cargados exitosamente!");
print("📗 Fácil: Ejemplos 1-33 (CRUD básico)");
print("📙 Medio: Ejemplos 34-76 (Operadores, regex, actualizaciones avanzadas)");
print("📕 Difícil: Ejemplos 77-110 (Aggregation pipeline, lookup, índices)");
print("\n💡 Tip: Ejecuta cada sección por separado para ver los resultados");
