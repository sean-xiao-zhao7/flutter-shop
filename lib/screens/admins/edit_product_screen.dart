import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _product =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');
  // editing mode
  var _isInit = true;
  var _editInitValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editInitValues = {
          'title': _product.title,
          'description': _product.description,
          'price': _product.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _product.imageUrl;
      }
      ;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void dispose() {
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (_product.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(_product);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_product);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _editInitValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Title is empty.';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _product = Product(
                      title: value,
                      price: _product.price,
                      description: _product.description,
                      imageUrl: _product.imageUrl,
                      id: _product.id,
                      isFav: _product.isFav,
                    );
                  },
                ),
                TextFormField(
                    initialValue: _editInitValues['price'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _product = Product(
                        title: _product.title,
                        price: double.parse(value),
                        description: _product.description,
                        imageUrl: _product.imageUrl,
                        id: _product.id,
                        isFav: _product.isFav,
                      );
                    }),
                TextFormField(
                  initialValue: _editInitValues['description'],
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _product = Product(
                      title: _product.title,
                      price: _product.price,
                      description: value,
                      imageUrl: _product.imageUrl,
                      id: _product.id,
                      isFav: _product.isFav,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey[350],
                      )),
                      child: FittedBox(
                        child: _imageUrlController.text.isEmpty
                            ? Text('Upload an image.')
                            : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) {
                          setState(() {
                            _imageUrlController.text = value;
                          });
                        },
                        onSaved: (value) {
                          _product = Product(
                            title: _product.title,
                            price: _product.price,
                            description: _product.description,
                            imageUrl: value,
                            id: _product.id,
                            isFav: _product.isFav,
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
