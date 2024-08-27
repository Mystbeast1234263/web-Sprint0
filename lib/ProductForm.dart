import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductForm extends StatefulWidget {
  final String? productoId; // Para el caso de edición
  final Map<String, dynamic>? productoData; // Los datos del producto

  const ProductForm({this.productoId, this.productoData, super.key});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.productoData != null) {
      _nombreController.text = widget.productoData!['Nombre'] ?? '';
      _descripcionController.text = widget.productoData!['Descripcion'] ?? '';
      _categoriaController.text = widget.productoData!['Categoría'] ?? '';
      _precioController.text = widget.productoData!['Precio'].toString();
      _cantidadController.text = widget.productoData!['Cantidad'].toString();
    }
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> producto = {
        'Nombre': _nombreController.text,
        'Descripcion': _descripcionController.text,
        'Categoría': _categoriaController.text,
        'Precio': double.parse(_precioController.text),
        'Cantidad': int.parse(_cantidadController.text),
      };

      if (widget.productoId == null) {
        // Agregar nuevo producto
        await FirebaseFirestore.instance.collection('Productos').add(producto);
      } else {
        // Editar producto existente
        await FirebaseFirestore.instance
            .collection('Productos')
            .doc(widget.productoId)
            .update(producto);
      }

      Navigator.pop(context); // Volver a la lista de productos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.productoId == null ? 'Agregar Producto' : 'Editar Producto'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo para el nombre del producto
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo para la descripción del producto
                    TextFormField(
                      controller: _descripcionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo para la categoría del producto
                    TextFormField(
                      controller: _categoriaController,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo para el precio del producto
                    TextFormField(
                      controller: _precioController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo para la cantidad del producto
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Botón para guardar el producto
                    ElevatedButton(
                      onPressed: _guardarProducto,
                      child: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
