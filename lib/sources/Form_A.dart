import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class primerForm extends StatefulWidget {
  const primerForm({super.key});
  @override
  State<primerForm> createState() {
    return _primerFormState();
  }
}

class _primerFormState extends State<primerForm> {
  bool autoValidate = true; // Activar o desactivar la validación automática del formulario.
  bool readOnly = false; // Controla si el formulario es solo de lectura.
  bool showSegmentedControl = true; // Mostrar control segmentado en UI.
  final _formKey = GlobalKey<FormBuilderState>(); // Clave global para acceder al estado del formulario.
  bool _speedTextHasError = false; // Indica error en el campo de texto de velocidad.
  bool _speedHasError = false; // Indica error en el campo Dropdown de alta velocidad.

  // Opciones del Dropdown para seleccionar velocidad.
  var speedOptions = ['High', 'Medium', 'Low'];

  // Función que maneja cambios en el formulario y muestra en consola.
  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
              debugPrint(_formKey.currentState!.value.toString());
            },
            autovalidateMode: AutovalidateMode.disabled,
            skipDisabled: true,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),

                // Título de la opción para velocidad del vehículo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please provide the speed of the vehicle?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Subtítulo en gris para la opción de velocidad del vehículo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please select one option given below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),

                // Grupo de botones de opción única para seleccionar velocidad
                FormBuilderRadioGroup<String>(
                  initialValue: null,
                  name: 'speed',
                  onChanged: _onChanged,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  options: ['above 40 km/h', 'below 40 km/h', '0 km/h']
                      .map((speed) => FormBuilderFieldOption(
                    value: speed,
                    child: Text(speed),
                  ))
                      .toList(growable: false),
                  controlAffinity: ControlAffinity.leading, // Botón a la izquierda del texto
                  orientation: OptionsOrientation.vertical, // Opciones en orientación vertical
                ),

                // Título de la opción para comentarios
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Remarks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Campo de texto para ingresar comentarios
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'remark',
                  decoration: InputDecoration(
                    hintText: 'Enter your remarks', // Texto por defecto en el campo
                  ),
                  onChanged: (val) {
                    setState(() {
                      _speedTextHasError =
                      !(_formKey.currentState?.fields['remark']?.validate() ?? false);
                    });
                  },
                  textInputAction: TextInputAction.next,
                ),

                // Título de la opción para velocidad máxima del vehículo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please provide the high speed of the vehicle?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Subtítulo en gris para la opción de velocidad máxima
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please select one option given below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),

                // Dropdown para seleccionar velocidad máxima del vehículo
                FormBuilderDropdown<String>(
                  name: 'highspeed',
                  decoration: InputDecoration(
                    hintText: 'Select option', // Texto por defecto en el Dropdown
                  ),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  items: speedOptions
                      .map((speed) => DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value: speed,
                    child: Text(speed),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _speedHasError = !(_formKey
                          .currentState?.fields['highspeed']
                          ?.validate() ?? false);
                    });
                  },
                  valueTransformer: (val) => val?.toString(),
                ),

                // Título para la opción de velocidad en la última hora
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please provide the speed of vehicle past 1 hour?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Subtítulo en gris para la opción de velocidad en la última hora
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please select one or more options given below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),

                // Grupo de checkboxes para seleccionar múltiples velocidades pasadas
                FormBuilderCheckboxGroup<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'selectSpeed',
                  options: const [
                    FormBuilderFieldOption(value: '20 km/h'),
                    FormBuilderFieldOption(value: '30 km/h'),
                    FormBuilderFieldOption(value: '40 km/h'),
                    FormBuilderFieldOption(value: '50 km/h'),
                  ],
                  orientation: OptionsOrientation.vertical, // Opciones en orientación vertical
                  onChanged: _onChanged,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(1),
                    FormBuilderValidators.maxLength(3),
                  ]),
                ),
              ],
            ),
          ),

          // Botón flotante de envío
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Alinea los elementos a la derecha
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Bordes redondeados
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green), // Icono de éxito
                              SizedBox(width: 8), // Espacio entre icono y título
                              Text('Submission Completed'),
                            ],
                          ),
                          content: Text(
                            _formKey.currentState?.value.toString() ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    debugPrint(_formKey.currentState?.value.toString());
                    debugPrint('validation failed');
                  }
                },
                child: Icon(Icons.upload, color: Colors.lightBlue), // Icono de subida
              ),
              const SizedBox(width: 20), // Espacio opcional
            ],
          ),
        ],
      ),
    );
  }
}