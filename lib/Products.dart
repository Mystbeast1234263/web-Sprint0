import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductForm.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  // Función para eliminar un producto con confirmación
  Future<void> _eliminarProducto(
      BuildContext context, String productoId) async {
    // Mostramos una ventana preguntando si de verdad quieres eliminar el producto
    bool confirmarEliminar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: const Text('¿Está seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    // Si confirmaste que sí lo quieres eliminar, adiós producto :(
    if (confirmarEliminar) {
      await FirebaseFirestore.instance
          .collection('Productos')
          .doc(productoId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Agregar Producto'),
            ),
            const SizedBox(height: 20),
            Expanded(
              // Aquí empieza la magia de Firebase para obtener los productos en tiempo real
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Productos')
                    .snapshots(),
                builder: (context, snapshot) {
                  // Si aún está cargando, mostramos un spinner
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Si no hay productos, le decimos al usuario que se anime a agregar algo o lo bananeamos
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No hay productos disponibles.'));
                  }

                  // Aquí ya mostramos los productos ugu
                  return DataTable(
                    columnSpacing:
                        20, // Espacio entre columnas para que no se vea todo pegado y feo ugu
                    columns: const [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Descripción')),
                      DataColumn(label: Text('Categoría')),
                      DataColumn(label: Text('Precio')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Acción')),
                    ],
                    rows: snapshot.data!.docs.map((producto) {
                      return DataRow(
                        cells: [
                          DataCell(Text(producto.get('Nombre') ?? '')),
                          DataCell(Text(producto.get('Descripcion') ?? '')),
                          DataCell(Text(producto.get('Categoría') ?? '')),
                          DataCell(Text(producto.get('Precio').toString())),
                          DataCell(Text(producto.get('Cantidad').toString())),
                          DataCell(Row(
                            children: [
                              // Botón para modificar el producto (por si te equivocaste al agregarlo)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductForm(
                                        productoId: producto.id,
                                        productoData: producto.data()
                                            as Map<String, dynamic>,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Modificar'),
                              ),
                              const SizedBox(width: 8),
                              // Botón para eliminar el producto
                              ElevatedButton(
                                onPressed: () =>
                                    _eliminarProducto(context, producto.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Rojo = peligro
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
