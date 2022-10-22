import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:henkin_shop/providers/product_provider.dart';
import 'package:henkin_shop/providers/products_provider.dart';
import 'package:validators/validators.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Map<String, Object?>>{};

  bool _isLoading = false;
  String? _imageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product =
          ModalRoute.of(context)!.settings.arguments as ProductProvider?;

      //Map creation
      _formData['id'] = <String, Object>{};
      _formData['title'] = <String, Object>{};
      _formData['description'] = <String, Object>{};
      _formData['price'] = <String, Object>{};
      _formData['imageUrl'] = <String, Object>{};

      //Initial values
      _formData['id']!['value'] = product?.id;
      _formData['title']!['value'] = product?.title;
      _formData['description']!['value'] = product?.description;
      _formData['price']!['value'] = product?.price.toString() ?? '';
      _formData['imageUrl']!['value'] = product?.imageUrl;
      if (product?.imageUrl != null && isValidImageUrl(product!.imageUrl)) {
        setState(() => _imageUrl = product.imageUrl);
      }

      //Focus nodes, FocusScope didn't work.
      _formData['title']!['focus'] = FocusNode();
      _formData['description']!['focus'] = FocusNode();
      _formData['price']!['focus'] = FocusNode();
      _formData['imageUrl']!['focus'] = FocusNode();
    }
  }

  Future _errorDialog(BuildContext context, Exception e) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text('$e Tente novamente mais tarde.'),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void _updateImage(String url) {
    if (isValidImageUrl(url))
      setState(() => _imageUrl = url);
    else
      setState(() => _imageUrl = null);
  }

  bool isValidImageUrl(String url) {
    return isURL(url, requireProtocol: true) &&
        (url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png'));
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context, listen: false);

    Future<void> submit() async {
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);
        _formKey.currentState!.save();
        final newProduct = ProductProvider(
          id: _formData['id']!['value'] as String?,
          title: _formData['title']!['value'] as String,
          description: _formData['description']!['value'] as String,
          price: double.parse(_formData['price']!['value'] as String),
          imageUrl: _formData['imageUrl']!['value'] as String,
        );

        try {
          final navigator = Navigator.of(context);
          if (newProduct.id == null)
            await products.addProduct(newProduct);
          else
            await products.updateProduct(newProduct);
          navigator.pop();
        } on Exception catch (e) {
          await _errorDialog(context, e);
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar produto'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //Visibility pro fab não ficar na frente do teclado
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0 && !_isLoading,
        child: FloatingActionButton(
          onPressed: submit,
          child: const Icon(Icons.save),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title']!['value'] as String?,
                      decoration: const InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      focusNode: _formData['title']!['focus'] as FocusNode?,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(
                              _formData['price']!['focus'] as FocusNode?),
                      onSaved: (value) => _formData['title']!['value'] = value,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 3)
                          return 'Informe um título válido com no mínimo 3 caracteres!';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']!['value'] as String?,
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusNode: _formData['price']!['focus'] as FocusNode?,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(
                              _formData['description']!['focus'] as FocusNode?),
                      onSaved: (value) => _formData['price']!['value'] = value,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            double.tryParse(value) == null)
                          return 'Informe um preço válido!';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _formData['description']!['value'] as String?,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      focusNode:
                          _formData['description']!['focus'] as FocusNode?,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(
                              _formData['imageUrl']!['focus'] as FocusNode?),
                      onSaved: (value) =>
                          _formData['description']!['value'] = value,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 10)
                          return 'Informe uma descrição válida com no mínimo 10 caracteres!';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                _formData['imageUrl']!['value'] as String?,
                            decoration: const InputDecoration(
                                labelText: 'URL da Imagem'),
                            onChanged: _updateImage,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode:
                                _formData['imageUrl']!['focus'] as FocusNode?,
                            onFieldSubmitted: (_) => submit(),
                            onSaved: (value) =>
                                _formData['imageUrl']!['value'] = value,
                            validator: (value) {
                              if (value == null || !isValidImageUrl(value))
                                return 'Informe um URL válido!';
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrl == null
                              ? const Text('Informe o URL')
                              : Image.network(_imageUrl!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
